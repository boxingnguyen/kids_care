import 'package:flutter/material.dart';
import 'package:kids_care/core/theme/app_theme.dart';

/// Kids Care shield+heart logo widget.
class KidsCareLogo extends StatelessWidget {
  final double size;

  const KidsCareLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shield_rounded,
            size: size * 0.75,
            color: AppTheme.primaryColor,
          ),
          Icon(
            Icons.favorite_rounded,
            size: size * 0.32,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
