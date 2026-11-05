import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/utils/stream_utils.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/models/todo_model.dart';

// ── Constants ──────────────────────────────────────────────────────────────
const _kCollection = 'todos';

// ── Stream Provider ────────────────────────────────────────────────────────

/// Nhiệm vụ thuộc về bé [childId] (mọi bố/mẹ đang liên kết cùng thấy) — realtime.
Stream<List<TodoModel>> _todosForChild(String childId) {
  return FirebaseFirestore.instance
      .collection(_kCollection)
      .where('assignedChildId', isEqualTo: childId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map(TodoModel.fromFirestore).toList());
}

/// Nhiệm vụ của con đang đăng nhập (từ mọi bố/mẹ đang liên kết).
final childTodosStreamProvider = StreamProvider<List<TodoModel>>((ref) {
  final uid = ref.watch(authUidProvider).valueOrNull;
  if (uid == null) return Stream.value([]);
  return _todosForChild(uid);
});

/// Nhiệm vụ của mọi bé đang liên kết với bố/mẹ hiện tại — gồm cả việc do
/// bố/mẹ khác của bé giao. Mỗi bé một truy vấn (rules kiểm tra theo bé), gộp lại.
final parentTodosStreamProvider = StreamProvider<List<TodoModel>>((ref) {
  final key = ref.watch(
    linkedChildrenProvider.select(
      (v) => v.whenData(
        (kids) => (kids.map((k) => k.uid).toList()..sort()).join(','),
      ),
    ),
  );
  return switch (key) {
    AsyncData(:final value) when value.isEmpty => Stream.value([]),
    AsyncData(:final value) =>
      combineLatest(value.split(',').map(_todosForChild).toList()).map(
        (lists) =>
            lists.expand((l) => l).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      ),
    AsyncError(:final error, :final stackTrace) => Stream.error(
      error,
      stackTrace,
    ),
    _ => const Stream.empty(),
  };
});

// ── Action Notifier ────────────────────────────────────────────────────────

class TodoActions {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Create a new todo in Firestore
  Future<void> addTodo({
    required String title,
    String description = '',
    String emoji = '📝',
    required String assignedChildId,
    DateTime? dueDate,
  }) async {
    final todo = TodoModel(
      id: '', // Firestore will assign
      title: title,
      description: description,
      emoji: emoji,
      assignedChildId: assignedChildId,
      createdBy: FirebaseAuth.instance.currentUser!.uid,
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
      'completedAt': isNowCompleted ? Timestamp.fromDate(DateTime.now()) : null,
    });
  }

  /// Delete a todo
  Future<void> deleteTodo(String todoId) async {
    await _db.collection(_kCollection).doc(todoId).delete();
  }
}

final todoActionsProvider = Provider<TodoActions>((ref) => TodoActions());
