import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/models/user_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text(
                'Tài khoản & bảo mật',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
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
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text('Đăng xuất'),
                  subtitle: const Text('Đăng xuất khỏi tài khoản hiện tại'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
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
    );
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
        title: const Text(
          'Nâng cấp tài khoản',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        subtitle: const Text('Liên kết với Google để không mất dữ liệu'),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.primaryColor,
        ),
        onTap: () async {
          final messenger = ScaffoldMessenger.of(context);
          try {
            final upgraded = await ref.read(authServiceProvider).upgradeGuest();
            if (!upgraded) return;
            ref.invalidate(currentUserProvider);
            messenger.showSnackBar(
              const SnackBar(content: Text('Tài khoản đã được nâng cấp!')),
            );
          } on FirebaseAuthException catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  e.code == 'credential-already-in-use'
                      ? 'Tài khoản Google này đã được dùng cho tài khoản khác'
                      : 'Lỗi: ${e.message}',
                ),
              ),
            );
          } catch (e) {
            messenger.showSnackBar(SnackBar(content: Text('Lỗi: $e')));
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
              title: const Text('Mã liên kết của bạn'),
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
                tooltip: 'Sao chép',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã sao chép mã liên kết')),
                  );
                },
              ),
            ),
          ListTile(
            leading: const Icon(Icons.link_rounded),
            title: const Text('Liên kết tài khoản'),
            subtitle: Text(
              isLinked
                  ? 'Đã liên kết — nhập mã để liên kết thêm'
                  : user.role == 'parent'
                      ? 'Nhập mã của con để liên kết'
                      : 'Nhập mã của bố/mẹ để liên kết',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push('/link'),
          ),
        ],
      ),
    );
  }
}
