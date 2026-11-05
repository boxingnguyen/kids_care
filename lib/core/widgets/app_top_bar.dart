import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/l10n/l10n.dart';

/// AppBar chuẩn của app: nền trắng, tiêu đề giữa (theo AppTheme),
/// nút quay lại tròn to ở bên trái.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final String? fallbackLocation;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const AppTopBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.fallbackLocation,
    this.actions,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      leadingWidth: 64,
      leading: showBack
          ? Center(child: AppBackButton(fallbackLocation: fallbackLocation))
          : null,
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [...?actions, const SizedBox(width: 8)],
    );
  }
}

/// Nút Cài đặt trên header của các tab.
class SettingsAction extends StatelessWidget {
  final Color? color;

  const SettingsAction({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.settings,
      onPressed: () => context.push('/settings'),
      icon: const Icon(Icons.settings_rounded),
      color: color ?? AppTheme.textSecondary,
    );
  }
}
