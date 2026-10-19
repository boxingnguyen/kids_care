import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
abstract class TodoModel with _$TodoModel {
  const factory TodoModel({
    required String id,
    required String title,
    @Default('') String description,
    @Default('📝') String emoji,
    required String assignedChildId,
    required String createdBy,
    @Default(false) bool isCompleted,
    DateTime? dueDate,
    DateTime? completedAt,
    required DateTime createdAt,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      id: doc.id,
      title: data['title'] as String,
      description: (data['description'] as String?) ?? '',
      emoji: (data['emoji'] as String?) ?? '📝',
      assignedChildId: data['assignedChildId'] as String,
      createdBy: data['createdBy'] as String,
      isCompleted: (data['isCompleted'] as bool?) ?? false,
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Cannot define methods directly in freezed — use extension
}

extension TodoModelFirestore on TodoModel {
  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'emoji': emoji,
        'assignedChildId': assignedChildId,
        'createdBy': createdBy,
        'isCompleted': isCompleted,
        'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
        'completedAt':
            completedAt != null ? Timestamp.fromDate(completedAt!) : null,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
