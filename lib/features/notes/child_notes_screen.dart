import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/core/widgets/emoji_title_sheet.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/child/child_events.dart';
import 'package:kids_care/features/notes/notes_provider.dart';
import 'package:kids_care/l10n/l10n.dart';
import 'package:kids_care/models/geofence_event_model.dart';

const _kNoteEmojis = ['💌', '🛒', '🎂', '✏️', '🧸', '🍦', '📖', '🚲'];
const _kNoteColor = Color(0xFFEC4899);

/// Tab "Lời nhắn gửi" của bé: việc bé nhờ bố/mẹ làm. Bố/mẹ đánh dấu đã làm
/// thì bé thấy ngay (kèm tên người làm).
class ChildNotesScreen extends ConsumerWidget {
  const ChildNotesScreen({super.key});

  Future<void> _addNote(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final result = await showEmojiTitleSheet(
      context,
      title: l10n.addNoteTitle,
      hint: l10n.addNoteHint,
      submitLabel: l10n.sendNote,
      emojis: _kNoteEmojis,
    );
    if (result == null) return;
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;
    await ref
        .read(noteActionsProvider)
        .add(childId: user.uid, title: result.title, emoji: result.emoji);
    ChildEvents.publishFor(
      user,
      type: ChildEventType.noteCreated,
      zoneName: result.title,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(childNotesProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _addNote(context, ref),
        backgroundColor: _kNoteColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded, size: 26),
        label: Text(
          l10n.writeNote,
          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _Header(notes: notesAsync.valueOrNull ?? const []),
            Expanded(
              child: notesAsync.when(
                data: (notes) {
                  if (notes.isEmpty) return const _EmptyState();
                  final pending = notes.where((n) => !n.isCompleted).toList();
                  final done = notes.where((n) => n.isCompleted).toList();
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
                    children: [
                      ...pending.map((n) => _NoteCard(note: n)),
                      if (done.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          '🎉 ${l10n.notesDoneCount('${done.length}')}',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.playColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...done.map((n) => _NoteCard(note: n)),
                      ],
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: _kNoteColor),
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
    final waiting = notes.where((n) => !n.isCompleted).length;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF472B6), _kNoteColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.notesTitle,
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  waiting == 0
                      ? context.l10n.notesSubtitle
                      : context.l10n.notesWaiting('$waiting'),
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SettingsAction(color: Colors.white),
        ],
      ),
    );
  }
}

class _NoteCard extends ConsumerWidget {
  final ParentNote note;

  const _NoteCard({required this.note});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    HapticFeedback.mediumImpact();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          ctx.l10n.deleteNoteTitle,
          style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
        ),
        content: Text(ctx.l10n.deleteTaskMessage(note.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              ctx.l10n.delete,
              style: const TextStyle(color: AppTheme.dangerColor),
            ),
          ),
        ],
      ),
    );
    if (ok == true) await ref.read(noteActionsProvider).delete(note.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = note.isCompleted;
    return GestureDetector(
      // Giữ lâu để xoá lời nhắn.
      onLongPress: () => _confirmDelete(context, ref),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: done ? Colors.white.withValues(alpha: 0.7) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: done
              ? Border.all(
                  color: AppTheme.playColor.withValues(alpha: 0.3),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            if (!done)
              BoxShadow(
                color: _kNoteColor.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: (done ? AppTheme.playColor : _kNoteColor).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  done ? '✅' : note.emoji,
                  style: const TextStyle(fontSize: 28),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: done ? AppTheme.textHint : AppTheme.textPrimary,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: AppTheme.textHint,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    done
                        ? context.l10n.noteDoneBy(
                            note.completedByName ?? '',
                            DateFormat(
                              'HH:mm',
                            ).format(note.completedAt ?? DateTime.now()),
                          )
                        : context.l10n.noteWaiting,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: done ? AppTheme.playColor : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💌', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              context.l10n.noNotesYet,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.noNotesHint,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
