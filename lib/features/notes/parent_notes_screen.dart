import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/notes/notes_provider.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Tab "Việc cần làm" của bố/mẹ: lời nhắn các bé gửi. Chạm để đánh dấu đã
/// làm (bé thấy tên người làm), chạm lại để bỏ đánh dấu.
class ParentNotesScreen extends ConsumerWidget {
  const ParentNotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(parentNotesProvider);
    final kids = ref.watch(linkedChildrenProvider).valueOrNull ?? const [];
    final names = {for (final k in kids) k.uid: k.name};
    final l10n = context.l10n;
    final notes = notesAsync.valueOrNull ?? const <ParentNote>[];
    final waiting = notes.where((n) => !n.isCompleted).length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppTopBar(
        title: l10n.parentNotesTitle,
        showBack: false,
        actions: const [SettingsAction()],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return _EmptyState(hasChild: kids.isNotEmpty);
          }
          final pending = notes.where((n) => !n.isCompleted).toList();
          final done = notes.where((n) => n.isCompleted).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Text(
                waiting == 0
                    ? l10n.parentNotesAllDone
                    : l10n.parentNotesWaiting('$waiting'),
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              for (final n in pending)
                _ParentNoteTile(
                  note: n,
                  childName: kids.length > 1 ? names[n.childId] : null,
                ),
              if (done.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.notesDoneCount('${done.length}'),
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.playColor,
                  ),
                ),
                const SizedBox(height: 10),
                for (final n in done)
                  _ParentNoteTile(
                    note: n,
                    childName: kids.length > 1 ? names[n.childId] : null,
                  ),
              ],
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.errorWithMessage('$e'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _toggle(context, ref),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text(note.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: done
                              ? AppTheme.textHint
                              : AppTheme.textPrimary,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: AppTheme.textHint,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        meta,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: done
                              ? AppTheme.playColor
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  done
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 30,
                  color: done ? AppTheme.playColor : AppTheme.textHint,
                ),
              ],
            ),
          ),
        ),
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
            const Text('💌', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              context.l10n.parentNotesEmpty,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
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
