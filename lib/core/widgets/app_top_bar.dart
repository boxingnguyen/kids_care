import 'package:flutter/material.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';

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
