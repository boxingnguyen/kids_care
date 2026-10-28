import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/models/user_model.dart';
import 'package:kids_care/l10n/l10n.dart';
import 'package:kids_care/l10n/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    return AppBackScope(
      child: Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppTopBar(title: context.l10n.settings),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _LanguageCard(),
              const SizedBox(height: 24),
              Text(
                context.l10n.accountSecurity,
                style: GoogleFonts.nunito(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              if (user?.isGuest == true) ...[
                _UpgradeCard(),
                const SizedBox(height: 12),
              ],
              if (user != null) ...[
                _LinkCard(user: user),
                const SizedBox(height: 12),
              ],
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  iconColor: AppTheme.dangerColor,
                  leading: const Icon(Icons.logout_rounded),
                  title: Text(context.l10n.logout),
                  subtitle: Text(context.l10n.logoutSubtitle),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    final confirmed = await _confirmLogout(
                      context,
                      isGuest: user?.isGuest == true,
                    );
                    if (!confirmed) return;
                    await ref.read(authServiceProvider).signOut();
                    ref.invalidate(currentUserProvider);
                    if (context.mounted) {
                      context.go('/');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  /// Hỏi lại trước khi đăng xuất — tránh bé bấm nhầm. Với tài khoản khách,
  /// nhắc rằng có thể mất dữ liệu.
  Future<bool> _confirmLogout(
    BuildContext context, {
    required bool isGuest,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.logoutConfirmTitle),
        content: Text(
          isGuest
              ? context.l10n.logoutGuestWarning
              : context.l10n.logoutConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
            ),
            child: Text(context.l10n.stay),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.dangerColor,
            ),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
    return result == true;
  }
}

/// Nâng cấp tài khoản khách lên Google — chỉ hiện với user isGuest.
class _UpgradeCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: AppTheme.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.upgrade_rounded,
          color: AppTheme.primaryColor,
        ),
        title: Text(
          context.l10n.upgradeAccount,
          style: const TextStyle(color: AppTheme.primaryColor),
        ),
        subtitle: Text(context.l10n.upgradeAccountSubtitle),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.primaryColor,
        ),
        onTap: () async {
          final messenger = ScaffoldMessenger.of(context);
          final l10n = context.l10n;
          try {
            final upgraded = await ref.read(authServiceProvider).upgradeGuest();
            if (!upgraded) return;
            ref.invalidate(currentUserProvider);
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.accountUpgraded)),
            );
          } on FirebaseAuthException catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  e.code == 'credential-already-in-use'
                      ? l10n.googleAccountInUse
                      : l10n.errorWithMessage('${e.message}'),
                ),
              ),
            );
          } catch (e) {
            messenger.showSnackBar(SnackBar(content: Text(l10n.errorWithMessage('$e'))));
          }
        },
      ),
    );
  }
}

/// Hiện mã liên kết của mình và mở màn nhập mã của người kia.
class _LinkCard extends StatelessWidget {
  final UserModel user;

  const _LinkCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final code = user.linkCode;
    final isLinked = user.role == 'parent'
        ? user.linkedChildIds.isNotEmpty
        : user.linkedParentId != null;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (code != null)
            ListTile(
              leading: const Icon(Icons.qr_code_2_rounded),
              title: Text(context.l10n.yourLinkCode),
              subtitle: Text(
                code,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: AppTheme.primaryColor,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy_rounded, size: 20),
                tooltip: context.l10n.copy,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.linkCodeCopied)),
                  );
                },
              ),
            ),
          ListTile(
            leading: const Icon(Icons.link_rounded),
            title: Text(context.l10n.linkAccountTitle),
            subtitle: Text(
              isLinked
                  ? context.l10n.linkedAddMore
                  : user.role == 'parent'
                      ? context.l10n.enterChildCode
                      : context.l10n.enterParentCode,
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/link'),
          ),
        ],
      ),
    );
  }
}

/// Chọn ngôn ngữ — hiện cờ + tên ngôn ngữ bằng chính ngôn ngữ đó để bé và
/// bố mẹ nhận ra ngay, kể cả khi app đang ở ngôn ngữ mình không đọc được.
class _LanguageCard extends ConsumerWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chosen = ref.watch(localeProvider);
    final current = Localizations.localeOf(context).languageCode;
    final info = kLanguageNames[current];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Text(
          info?.flag ?? '🌐',
          style: const TextStyle(fontSize: 28),
        ),
        title: Text(context.l10n.language),
        subtitle: Text(
          chosen == null
              ? '${context.l10n.languageSystem} · ${info?.name ?? current}'
              : info?.name ?? current,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _showLanguagePicker(context, ref, chosen),
      ),
    );
  }

  Future<void> _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    Locale? chosen,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        Widget option({
          required String flag,
          required String name,
          required bool selected,
          required Locale? value,
        }) {
          return ListTile(
            minTileHeight: 60,
            leading: Text(flag, style: const TextStyle(fontSize: 28)),
            title: Text(
              name,
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                color: selected ? AppTheme.primaryColor : AppTheme.textPrimary,
              ),
            ),
            trailing: selected
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.primaryColor,
                    size: 28,
                  )
                : null,
            onTap: () {
              HapticFeedback.selectionClick();
              ref.read(localeProvider.notifier).setLocale(value);
              Navigator.pop(sheetContext);
            },
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    context.l10n.chooseLanguage,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                option(
                  flag: '📱',
                  name: context.l10n.languageSystem,
                  selected: chosen == null,
                  value: null,
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                for (final entry in kLanguageNames.entries)
                  option(
                    flag: entry.value.flag,
                    name: entry.value.name,
                    selected: chosen?.languageCode == entry.key,
                    value: Locale(entry.key),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
