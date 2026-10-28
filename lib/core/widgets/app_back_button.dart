import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Trang chủ theo vai trò của người dùng hiện tại:
/// bố/mẹ → '/parent-home', con → '/child', chưa đăng nhập → '/'.
Future<String> homeLocationFor(WidgetRef ref) async {
  try {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return '/';
    return user.role == 'parent' ? '/parent-home' : '/child';
  } catch (_) {
    return '/';
  }
}

/// Quay lại an toàn: pop nếu còn màn trước trong stack, nếu không thì
/// về [fallbackLocation] (mặc định là trang chủ theo vai trò).
///
/// Tránh lỗi "There is nothing to pop" khi màn hình được mở bằng
/// `context.go(...)` hoặc mở thẳng từ deep link.
Future<void> goBack(
  BuildContext context,
  WidgetRef ref, {
  String? fallbackLocation,
}) async {
  if (context.canPop()) {
    context.pop();
    return;
  }
  final target = fallbackLocation ?? await homeLocationFor(ref);
  if (context.mounted) context.go(target);
}

/// Nút quay lại dùng chung toàn app — tròn, to (≥ 48dp) để trẻ dễ bấm.
class AppBackButton extends ConsumerWidget {
  final String? fallbackLocation;
  final Color? color;
  final Color? backgroundColor;

  const AppBackButton({
    super.key,
    this.fallbackLocation,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: backgroundColor ?? AppTheme.surfaceVariant,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          tooltip: context.l10n.back,
          iconSize: 24,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          color: color ?? AppTheme.textPrimary,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            HapticFeedback.selectionClick();
            goBack(context, ref, fallbackLocation: fallbackLocation);
          },
        ),
      ),
    );
  }
}

/// Bọc màn hình để nút Back hệ thống (Android / vuốt iOS) cũng quay về
/// đúng chỗ thay vì thoát app khi stack trống.
class AppBackScope extends ConsumerWidget {
  final Widget child;
  final String? fallbackLocation;

  const AppBackScope({super.key, required this.child, this.fallbackLocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        goBack(context, ref, fallbackLocation: fallbackLocation);
      },
      child: child,
    );
  }
}
