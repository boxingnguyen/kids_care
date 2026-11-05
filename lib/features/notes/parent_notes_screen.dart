import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/core/widgets/progress_circle.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/notes/notes_provider.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Tab "Việc con nhắn gửi" của bố/mẹ: lời nhắn các bé gửi (giao diện giống
/// tab Giao việc). Chạm để đánh dấu đã làm (bé thấy tên người làm), chạm lại
/// để bỏ đánh dấu.
class ParentNotesScreen extends ConsumerWidget {
  const ParentNotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(parentNotesProvider);
    final kids = ref.watch(linkedChildrenProvider).valueOrNull ?? const [];
    final names = {for (final k in kids) k.uid: k.name};

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: SafeArea(
        child: Column(
          children: [
            _Header(notes: notesAsync.valueOrNull ?? const []),
            Expanded(
              child: notesAsync.when(
                data: (notes) {
                  if (notes.isEmpty) {
                    return _EmptyState(hasChild: kids.isNotEmpty);
                  }
                  // Chưa làm lên trước, trong mỗi nhóm giữ thứ tự mới nhất trước.
                  final sorted = [
                    ...notes.where((n) => !n.isCompleted),
                    ...notes.where((n) => n.isCompleted),
                  ];
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                    itemCount: sorted.length,
                    itemBuilder: (context, i) => _ParentNoteTile(
                      note: sorted[i],
                      childName: kids.length > 1
                          ? names[sorted[i].childId]
                          : null,
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      context.l10n.errorWithMessage('$e'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(color: AppTheme.dangerColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final List<ParentNote> notes;
  const _Header({required this.notes});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = notes.length;
    final done = notes.where((n) => n.isCompleted).length;
    final waiting = total - done;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.parentNotesTitle,
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (total > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    waiting == 0
                        ? l10n.parentNotesAllDone
                        : l10n.parentNotesWaiting('$waiting'),
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (total > 0) ProgressCircle(done: done, total: total),
          const SettingsAction(),
        ],
      ),
    );
  }
}

class _ParentNoteTile extends ConsumerWidget {
  final ParentNote note;

  /// Tên bé — chỉ hiện khi có nhiều bé.
  final String? childName;

  const _ParentNoteTile({required this.note, this.childName});

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final me = await ref.read(currentUserProvider.future);
    if (me == null) return;
    HapticFeedback.mediumImpact();
    try {
      await ref
          .read(noteActionsProvider)
          .setDone(
            note,
            done: !note.isCompleted,
            byUid: me.uid,
            byName: me.name,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorWithMessage('$e'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = note.isCompleted;
    final l10n = context.l10n;
    final meta = [
      ?childName,
      done
          ? l10n.noteDoneBy(
              note.completedByName ?? '',
              DateFormat('HH:mm').format(note.completedAt ?? DateTime.now()),
            )
          : DateFormat('dd/MM HH:mm').format(note.createdAt),
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: done
            ? Border.all(
                color: AppTheme.playColor.withValues(alpha: 0.4),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: done
                ? AppTheme.playColor.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _toggle(context, ref),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Emoji badge
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: done
                        ? AppTheme.playColor.withValues(alpha: 0.12)
                        : AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      note.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: AppTheme.textHint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meta,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: done ? AppTheme.playColor : AppTheme.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(done: done),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool done;
  const _StatusBadge({required this.done});

  @override
  Widget build(BuildContext context) {
    final color = done ? AppTheme.playColor : AppTheme.primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: done
            ? AppTheme.playColor.withValues(alpha: 0.12)
            : AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (done) ...[
            Icon(Icons.check_circle_rounded, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            done ? context.l10n.taskDone : context.l10n.taskPending,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasChild;

  const _EmptyState({required this.hasChild});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💌', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              context.l10n.parentNotesEmpty,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasChild
                  ? context.l10n.parentNotesEmptyHint
                  : context.l10n.noChildLinkedTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
