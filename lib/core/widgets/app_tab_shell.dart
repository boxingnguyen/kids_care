import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Khung tab dùng chung cho cả hai vai trò — thanh điều hướng dưới, mỗi tab
/// giữ nguyên trạng thái khi chuyển qua lại (StatefulShellRoute.indexedStack).
///  - Bố/mẹ: Trang chủ (thông báo) · Bản đồ · Giao việc · Việc cần làm
///    (= lời nhắn bé gửi)
///  - Bé:    Trang chủ · Việc cần làm · Lời nhắn gửi (nhờ bố/mẹ làm)
class AppTabShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final bool isParent;

  const AppTabShell({
    super.key,
    required this.navigationShell,
    required this.isParent,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final home = BottomNavigationBarItem(
      icon: Icon(isParent ? Icons.notifications_rounded : Icons.home_rounded),
      label: l10n.home,
    );
    final todo = BottomNavigationBarItem(
      icon: const Icon(Icons.checklist_rounded),
      label: l10n.tasks,
    );
    final map = BottomNavigationBarItem(
      icon: const Icon(Icons.map_rounded),
      label: l10n.map,
    );
    final assign = BottomNavigationBarItem(
      icon: const Icon(Icons.assignment_rounded),
      label: l10n.assignTab,
    );
    final notes = BottomNavigationBarItem(
      icon: const Icon(Icons.mail_rounded),
      label: l10n.notesTab,
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) {
          HapticFeedback.selectionClick();
          // Bấm lại tab đang mở → về màn gốc của tab.
          navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          );
        },
        // Bé: icon và chữ to hơn cho dễ bấm.
        iconSize: isParent ? 26 : 30,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w900,
          fontSize: isParent ? 13 : 14,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w700,
          fontSize: isParent ? 12 : 13,
        ),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: isParent ? [home, map, assign, todo] : [home, todo, notes],
      ),
    );
  }
}
