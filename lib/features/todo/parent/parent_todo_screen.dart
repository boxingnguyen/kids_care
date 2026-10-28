import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/features/todo/providers/todo_provider.dart';
import 'package:kids_care/models/todo_model.dart';
import 'package:kids_care/l10n/l10n.dart';

// ── Emoji options for task creation ──────────────────────────────────────
const _kEmojis = ['📚', '🍽️', '🛁', '🏃', '🎨', '🧹', '🌙', '🐕', '🎯', '💊'];

class ParentTodoScreen extends ConsumerStatefulWidget {
  const ParentTodoScreen({super.key});

  @override
  ConsumerState<ParentTodoScreen> createState() => _ParentTodoScreenState();
}

class _ParentTodoScreenState extends ConsumerState<ParentTodoScreen> {
  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(defaultTodosStreamProvider);

    return AppBackScope(
      fallbackLocation: '/parent-home',
      child: Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: todosAsync.when(
                data: (todos) => todos.isEmpty
                    ? _EmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
                        itemCount: todos.length,
                        itemBuilder: (context, i) =>
                            _ParentTodoTile(todo: todos[i]),
                      ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppTheme.primaryColor),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      context.l10n.parentTasksLoadError('$e'),
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
      floatingActionButton: _AddTodoFab(),
    ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final todosAsync = ref.watch(defaultTodosStreamProvider);
    final total = todosAsync.valueOrNull?.length ?? 0;
    final done = todosAsync.valueOrNull?.where((t) => t.isCompleted).length ?? 0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
      child: Row(
        children: [
          const AppBackButton(fallbackLocation: '/parent-home'),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.parentTasksTitle,
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.tasksCompleted('$done', '$total'),
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (total > 0)
            _ProgressCircle(done: done, total: total),
        ],
      ),
    );
  }
}

// ── Progress circle ───────────────────────────────────────────────────────
class _ProgressCircle extends StatelessWidget {
  final int done;
  final int total;
  const _ProgressCircle({required this.done, required this.total});

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

// ── Todo tile for Parent ──────────────────────────────────────────────────
class _ParentTodoTile extends ConsumerWidget {
  final TodoModel todo;
  const _ParentTodoTile({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(todoActionsProvider);

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.dangerColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: AppTheme.dangerColor, size: 28),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(context.l10n.deleteTaskTitle,
                style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
            content: Text(context.l10n.deleteTaskMessage(todo.title),
                style: GoogleFonts.nunito()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(context.l10n.cancel,
                      style: GoogleFonts.nunito(color: AppTheme.textSecondary))),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(context.l10n.delete,
                      style: GoogleFonts.nunito(
                          color: AppTheme.dangerColor,
                          fontWeight: FontWeight.w800))),
            ],
          ),
        );
      },
      onDismissed: (_) => actions.deleteTodo(todo.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: todo.isCompleted
              ? Border.all(color: AppTheme.playColor.withValues(alpha: 0.4), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: todo.isCompleted
                  ? AppTheme.playColor.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: todo.isCompleted
                    ? AppTheme.playColor.withValues(alpha: 0.12)
                    : AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(todo.emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      decoration:
                          todo.isCompleted ? TextDecoration.lineThrough : null,
                      decorationColor: AppTheme.textHint,
                    ),
                  ),
                  if (todo.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      todo.description,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (todo.dueDate != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 12, color: AppTheme.textHint),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM').format(todo.dueDate!),
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: AppTheme.textHint,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Status badge
            if (todo.isCompleted)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.playColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 14, color: AppTheme.playColor),
                    const SizedBox(width: 4),
                    Text(
                      context.l10n.taskDone,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.playColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  context.l10n.taskPending,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── FAB → bottom sheet to create ─────────────────────────────────────────
class _AddTodoFab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddSheet(context, ref),
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(Icons.add_rounded, color: Colors.white),
      label: Text(
        context.l10n.addTask,
        style: GoogleFonts.nunito(
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddTodoSheet(ref: ref),
    );
  }
}

class _AddTodoSheet extends StatefulWidget {
  final WidgetRef ref;
  const _AddTodoSheet({required this.ref});

  @override
  State<_AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<_AddTodoSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedEmoji = '📝';
  DateTime? _dueDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await widget.ref.read(todoActionsProvider).addTodo(
            title: _titleCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            emoji: _selectedEmoji,
            dueDate: _dueDate,
          );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.addNewTask,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Emoji picker
          Text(context.l10n.chooseIcon,
              style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _kEmojis.map((e) {
                final selected = e == _selectedEmoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primaryColor
                          : AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Text(e,
                            style: const TextStyle(fontSize: 22))),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          TextField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              hintText: context.l10n.taskNameHint,
              hintStyle: GoogleFonts.nunito(color: AppTheme.textHint),
              filled: true,
              fillColor: AppTheme.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 12),

          // Description
          TextField(
            controller: _descCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: context.l10n.taskDescriptionHint,
              hintStyle: GoogleFonts.nunito(color: AppTheme.textHint),
              filled: true,
              fillColor: AppTheme.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.nunito(fontSize: 14),
          ),
          const SizedBox(height: 12),

          // Due date picker
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(
                        primary: AppTheme.primaryColor),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setState(() => _dueDate = picked);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 18, color: AppTheme.primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    _dueDate != null
                        ? context.l10n.dueDateLabel(DateFormat('dd/MM/yyyy').format(_dueDate!))
                        : context.l10n.pickDueDate,
                    style: GoogleFonts.nunito(
                      color: _dueDate != null
                          ? AppTheme.textPrimary
                          : AppTheme.textHint,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (_dueDate != null) ...[
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _dueDate = null),
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: AppTheme.textHint),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(
                      context.l10n.assignTask,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w800, fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📋', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            context.l10n.noTasksYetParent,
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.tapPlusToAssign,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
