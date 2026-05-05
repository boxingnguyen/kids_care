import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/models/todo_model.dart';

// ── Constants ──────────────────────────────────────────────────────────────
const _kCollection = 'todos';
const _kDefaultChildId = 'child-001'; // TODO: replace with auth user id

// ── Stream Provider ────────────────────────────────────────────────────────

/// Streams all todos for [childId] ordered by creation time.
/// Both parent & child use this — parent sees all, child filters their own.
final todosStreamProvider =
    StreamProvider.family<List<TodoModel>, String>((ref, childId) {
  return FirebaseFirestore.instance
      .collection(_kCollection)
      .where('assignedChildId', isEqualTo: childId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map(TodoModel.fromFirestore).toList());
});

/// Convenience provider that uses the default child id
final defaultTodosStreamProvider = StreamProvider<List<TodoModel>>((ref) {
  return FirebaseFirestore.instance
      .collection(_kCollection)
      .where('assignedChildId', isEqualTo: _kDefaultChildId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map(TodoModel.fromFirestore).toList());
});

// ── Action Notifier ────────────────────────────────────────────────────────

class TodoActions {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Create a new todo in Firestore
  Future<void> addTodo({
    required String title,
    String description = '',
    String emoji = '📝',
    String assignedChildId = _kDefaultChildId,
    String createdBy = 'parent-001',
    DateTime? dueDate,
  }) async {
    final todo = TodoModel(
      id: '', // Firestore will assign
      title: title,
      description: description,
      emoji: emoji,
      assignedChildId: assignedChildId,
      createdBy: createdBy,
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );
    await _db.collection(_kCollection).add(todo.toFirestore());
  }

  /// Toggle completion status of a todo
  Future<void> toggleTodo(TodoModel todo) async {
    final isNowCompleted = !todo.isCompleted;
    await _db.collection(_kCollection).doc(todo.id).update({
      'isCompleted': isNowCompleted,
      'completedAt': isNowCompleted
          ? Timestamp.fromDate(DateTime.now())
          : null,
    });
  }

  /// Delete a todo
  Future<void> deleteTodo(String todoId) async {
    await _db.collection(_kCollection).doc(todoId).delete();
  }
}

final todoActionsProvider = Provider<TodoActions>((ref) => TodoActions());
