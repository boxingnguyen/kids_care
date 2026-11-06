import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/privacy_policy.dart';
import 'package:kids_care/core/session/session_effects.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/link/services/link_service.dart';
import 'package:kids_care/features/location/location_consent.dart';
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
                  const _LinkEmailCard(),
                  const SizedBox(height: 12),
                ],
                if (user != null) ...[
                  _LinkCard(user: user),
                  const SizedBox(height: 12),
                  _LinkedAccountsCard(user: user),
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
                      if (user?.isGuest == true) {
                        final choice = await _confirmGuestLogout(context);
                        if (choice == _GuestLogoutChoice.linkEmail) {
                          if (context.mounted) {
                            context.push('/link-email?then=logout');
                          }
                          return;
                        }
                        if (choice != _GuestLogoutChoice.logout) return;
                      } else {
                        final confirmed = await _confirmLogout(context);
                        if (!confirmed) return;
                      }
                      // Dừng vùng an toàn + chia sẻ vị trí của tài khoản cũ (máy có thể đổi vai).
                      await stopSessionBeforeSignOut(ref);
                      await ref.read(authServiceProvider).signOut();
                      ref.invalidate(currentUserProvider);
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                  ),
                ),
                if (user != null) ...[
                  const SizedBox(height: 12),
                  _DeleteAccountCard(user: user),
                ],
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(context.l10n.privacyPolicy),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                    onTap: openPrivacyPolicy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tài khoản khách đăng xuất là mất dữ liệu vĩnh viễn → mời liên kết email.
  Future<_GuestLogoutChoice?> _confirmGuestLogout(BuildContext context) {
    return showDialog<_GuestLogoutChoice>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: AppTheme.dangerColor,
          size: 40,
        ),
        title: Text(context.l10n.logoutGuestLinkTitle),
        content: Text(context.l10n.logoutGuestLinkMessage),
        actionsOverflowDirection: VerticalDirection.up,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
            ),
            child: Text(context.l10n.stay),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, _GuestLogoutChoice.logout),
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: Text(context.l10n.logoutAnyway),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, _GuestLogoutChoice.linkEmail),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(context.l10n.linkEmailTitle),
          ),
        ],
      ),
    );
  }

  /// Hỏi lại trước khi đăng xuất — tránh bé bấm nhầm.
  Future<bool> _confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.logoutConfirmTitle),
        content: Text(context.l10n.logoutConfirmMessage),
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
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
    return result == true;
  }
}

enum _GuestLogoutChoice { linkEmail, logout }

/// Mời tài khoản khách gắn email để giữ dữ liệu — chỉ hiện với user isGuest.
class _LinkEmailCard extends StatelessWidget {
  const _LinkEmailCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppTheme.primaryLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(
          Icons.mail_outline_rounded,
          color: AppTheme.primaryColor,
        ),
        title: Text(
          context.l10n.linkEmailTitle,
          style: const TextStyle(color: AppTheme.primaryColor),
        ),
        subtitle: Text(context.l10n.linkEmailSubtitle),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.primaryColor,
        ),
        onTap: () => context.push('/link-email'),
      ),
    );
  }
}

/// Xoá vĩnh viễn tài khoản và dữ liệu (cả tài khoản khách).
class _DeleteAccountCard extends ConsumerWidget {
  final UserModel user;

  const _DeleteAccountCard({required this.user});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    final message = user.role == 'child'
        ? '${l10n.deleteAccountConfirmMessage}\n\n${l10n.deleteAccountAskParent}'
        : l10n.deleteAccountConfirmMessage;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: AppTheme.dangerColor,
          size: 40,
        ),
        title: Text(l10n.deleteAccountConfirmTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
            ),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: Text(l10n.deleteAccountAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
    // Dừng ghi vị trí trước, nếu không bản ghi đến sau sẽ tạo lại dữ liệu vừa xoá.
    await stopSessionBeforeSignOut(ref);
    try {
      await ref.read(authServiceProvider).deleteAccount();
    } catch (e) {
      debugPrint('deleteAccount failed: $e');
      await resumeSessionAfterFailedDelete(ref, user);
      navigator.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteAccountFailed)));
      return;
    }
    await ref.read(locationConsentProvider.notifier).reset();
    ref.invalidate(currentUserProvider);
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.accountDeleted)));
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        iconColor: AppTheme.dangerColor,
        textColor: AppTheme.dangerColor,
        leading: const Icon(Icons.delete_forever_rounded),
        title: Text(context.l10n.deleteAccount),
        subtitle: Text(context.l10n.deleteAccountSubtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _delete(context, ref),
      ),
    );
  }
}

/// Hiện mã liên kết của mình và mở màn nhập mã của người kia.
class _LinkCard extends ConsumerWidget {
  final UserModel user;

  const _LinkCard({required this.user});

  Future<void> _regenerate(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.regenerateLinkCode),
        content: Text(l10n.regenerateLinkCodeConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.regenerateLinkCode),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(guestAuthServiceProvider).regenerateLinkCode(user);
      ref.invalidate(currentUserProvider);
      messenger.showSnackBar(SnackBar(content: Text(l10n.linkCodeRegenerated)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorWithMessage('$e'))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = user.linkCode;
    final isLinked = user.role == 'parent'
        ? user.linkedChildIds.isNotEmpty
        : user.linkedParentIds.isNotEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    tooltip: context.l10n.copy,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.linkCodeCopied)),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    tooltip: context.l10n.regenerateLinkCode,
                    onPressed: () => _regenerate(context, ref),
                  ),
                ],
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

/// Danh sách tài khoản đã liên kết, mỗi dòng có nút gỡ liên kết (hỏi lại).
/// Bố/mẹ thấy các con; con thấy bố/mẹ. Không có liên kết thì ẩn.
class _LinkedAccountsCard extends ConsumerWidget {
  final UserModel user;

  const _LinkedAccountsCard({required this.user});

  Future<void> _unlink(
    BuildContext context,
    WidgetRef ref,
    UserModel other,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.unlinkConfirmTitle(other.name)),
        content: Text(
          user.role == 'parent'
              ? l10n.unlinkConfirmMessageParent
              : l10n.unlinkConfirmMessageChild,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
            ),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: Text(l10n.unlink),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(linkServiceProvider).unlink(user, other.uid);
      messenger.showSnackBar(SnackBar(content: Text(l10n.unlinked)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorWithMessage('$e'))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<UserModel> linked = user.role == 'parent'
        ? ref.watch(linkedChildrenProvider).valueOrNull ?? []
        : ref.watch(linkedParentsProvider).valueOrNull ?? [];
    if (linked.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(
                context.l10n.linkedAccountsTitle,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            for (final other in linked)
              ListTile(
                leading: Text(
                  other.role == 'parent' ? '👨‍👩‍👧' : '🧒',
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(other.name),
                trailing: TextButton(
                  onPressed: () => _unlink(context, ref, other),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.dangerColor,
                  ),
                  child: Text(context.l10n.unlink),
                ),
              ),
          ],
        ),
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
        leading: Text(info?.flag ?? '🌐', style: const TextStyle(fontSize: 28)),
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
