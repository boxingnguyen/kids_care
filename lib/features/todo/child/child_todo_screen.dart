import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/todo/providers/todo_provider.dart';
import 'package:kids_care/models/todo_model.dart';

class ChildTodoScreen extends ConsumerWidget {
  const ChildTodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(defaultTodosStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(todosAsync),
            Expanded(
              child: todosAsync.when(
                data: (todos) {
                  final pending = todos.where((t) => !t.isCompleted).toList();
                  final done = todos.where((t) => t.isCompleted).toList();

                  if (todos.isEmpty) return _EmptyState();

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
                    children: [
                      if (pending.isNotEmpty) ...[
                        _SectionHeader(
                          emoji: '⏳',
                          label: 'Cần làm (${pending.length})',
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 10),
                        ...pending.map((t) => _ChildTodoCard(todo: t)),
                      ],
                      if (done.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _SectionHeader(
                          emoji: '🎉',
                          label: 'Đã hoàn thành (${done.length})',
                          color: AppTheme.playColor,
                        ),
                        const SizedBox(height: 10),
                        ...done.map((t) => _ChildTodoCard(todo: t)),
                      ],
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: AppTheme.primaryColor),
                ),
                error: (e, _) => Center(
                  child: Text('Lỗi: $e',
                      style: GoogleFonts.nunito(color: AppTheme.dangerColor)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AsyncValue<List<TodoModel>> todosAsync) {
    final todos = todosAsync.valueOrNull ?? [];
    final done = todos.where((t) => t.isCompleted).length;
    final total = todos.length;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFAA00), Color(0xFFFF8C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhiệm vụ của mình 🌟',
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            total == 0
                ? 'Chưa có nhiệm vụ nào!'
                : 'Đã xong $done/$total nhiệm vụ hôm nay!',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (total > 0) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _SectionHeader(
      {required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Individual child todo card ────────────────────────────────────────────
class _ChildTodoCard extends ConsumerWidget {
  final TodoModel todo;
  const _ChildTodoCard({required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(todoActionsProvider);

    return GestureDetector(
      onTap: () async {
        await actions.toggleTodo(todo);
        if (context.mounted && !todo.isCompleted) {
          // Show celebration when completing
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🎉 Giỏi lắm! Hoàn thành "${todo.title}"!',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
              ),
              backgroundColor: AppTheme.playColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: todo.isCompleted
              ? Colors.white.withValues(alpha: 0.7)
              : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: todo.isCompleted
              ? Border.all(
                  color: AppTheme.playColor.withValues(alpha: 0.3), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: todo.isCompleted
                  ? Colors.transparent
                  : AppTheme.primaryColor.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Big emoji
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: todo.isCompleted
                      ? AppTheme.playColor.withValues(alpha: 0.1)
                      : AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    todo.isCompleted ? '✅' : todo.emoji,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title + meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: todo.isCompleted
                            ? AppTheme.textHint
                            : AppTheme.textPrimary,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppTheme.textHint,
                      ),
                    ),
                    if (todo.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
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
                    if (todo.dueDate != null && !todo.isCompleted) ...[
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule_rounded,
                                size: 11, color: AppTheme.primaryColor),
                            const SizedBox(width: 3),
                            Text(
                              'Hạn ${DateFormat('dd/MM').format(todo.dueDate!)}',
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (todo.isCompleted && todo.completedAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Xong lúc ${DateFormat('HH:mm').format(todo.completedAt!)}',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: AppTheme.playColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Checkbox indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: todo.isCompleted
                      ? AppTheme.playColor
                      : Colors.transparent,
                  border: Border.all(
                    color: todo.isCompleted
                        ? AppTheme.playColor
                        : AppTheme.textHint,
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                    : null,
              ),
            ],
          ),
        ),
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
          const Text('🌈', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Chưa có nhiệm vụ nào!',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bố/mẹ sẽ giao nhiệm vụ cho mình sớm nhé 😊',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
