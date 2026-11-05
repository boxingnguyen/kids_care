import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';

/// Vòng tiến độ "x%" ở header các danh sách việc.
class ProgressCircle extends StatelessWidget {
  final int done;
  final int total;
  const ProgressCircle({super.key, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : done / total;
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: pct,
            backgroundColor: AppTheme.surfaceVariant,
            color: AppTheme.playColor,
            strokeWidth: 5,
          ),
          Text(
            '${(pct * 100).round()}%',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
