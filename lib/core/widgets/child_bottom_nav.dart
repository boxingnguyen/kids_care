import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/l10n/l10n.dart';

enum ChildTab { home, todo, map }

/// Thanh điều hướng dưới dùng chung cho các màn của bé.
/// Icon và chữ to, chỉ giữ các tab thực sự hoạt động để bé không bị rối.
class ChildBottomNav extends StatelessWidget {
  final ChildTab current;

  const ChildBottomNav({super.key, required this.current});

  static const _routes = {
    ChildTab.home: '/child',
    ChildTab.todo: '/child-todo',
    ChildTab.map: '/map',
  };

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current.index,
      onTap: (i) {
        final tab = ChildTab.values[i];
        if (tab == current) return;
        HapticFeedback.selectionClick();
        context.go(_routes[tab]!);
      },
      iconSize: 30,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.textSecondary,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.nunito(
        fontWeight: FontWeight.w900,
        fontSize: 14,
      ),
      unselectedLabelStyle: GoogleFonts.nunito(
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_rounded),
          label: context.l10n.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.checklist_rounded),
          label: context.l10n.tasks,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map_rounded),
          label: context.l10n.map,
        ),
      ],
    );
  }
}
