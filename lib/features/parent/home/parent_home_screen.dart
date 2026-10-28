import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/providers/notifications_provider.dart';
import 'package:kids_care/l10n/l10n.dart';

class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Giữ stream sự kiện geofence chạy khi bố/mẹ ở màn hình chính
    // (để bắn thông báo local), không rebuild màn hình khi có sự kiện.
    ref.listen(notificationsProvider, (_, _) {});

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppTopBar(
        title: context.l10n.appTitle,
        showBack: false,
        actions: [
          IconButton(
            tooltip: context.l10n.settings,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_rounded),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            Text(
              context.l10n.helloParents,
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.whatToDoToday,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            _MenuCard(
              emoji: '🔔',
              color: AppTheme.dangerColor,
              title: context.l10n.menuNotificationsTitle,
              description: context.l10n.menuNotificationsDesc,
              onTap: () => context.push('/parent'),
            ),
            const SizedBox(height: 14),
            _MenuCard(
              emoji: '🗺️',
              color: AppTheme.schoolColor,
              title: context.l10n.menuMapTitle,
              description: context.l10n.menuMapDesc,
              onTap: () => context.push('/map'),
            ),
            const SizedBox(height: 14),
            _MenuCard(
              emoji: '📋',
              color: AppTheme.playColor,
              title: context.l10n.menuTasksTitle,
              description: context.l10n.menuTasksDesc,
              onTap: () => context.push('/parent-todo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String emoji;
  final Color color;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MenuCard({
    required this.emoji,
    required this.color,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 28,
                color: AppTheme.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
