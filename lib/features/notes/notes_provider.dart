import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/core/utils/stream_utils.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';

/// "Lời nhắn gửi": việc bé nhờ bố/mẹ làm (parent_todos). Bé viết; mọi bố/mẹ
/// đang liên kết cùng thấy và đánh dấu đã làm.
class ParentNote {
  final String id;
  final String childId;
  final String title;
  final String emoji;
  final DateTime createdAt;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? completedBy;
  final String? completedByName;

  const ParentNote({
    required this.id,
    required this.childId,
    required this.title,
    required this.emoji,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
    this.completedBy,
    this.completedByName,
  });

  factory ParentNote.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data() ?? const {};
    return ParentNote(
      id: d.id,
      childId: data['childId'] as String,
      title: (data['title'] as String?) ?? '',
      emoji: (data['emoji'] as String?) ?? '💌',
      // serverTimestamp → null trong snapshot local đầu tiên.
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isCompleted: (data['isCompleted'] as bool?) ?? false,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      completedBy: data['completedBy'] as String?,
      completedByName: data['completedByName'] as String?,
    );
  }
}

CollectionReference<Map<String, dynamic>> get _notes =>
    FirebaseFirestore.instance.collection(AppConstants.parentTodosCollection);

Stream<List<ParentNote>> _notesForChild(String childId) => _notes
    .where('childId', isEqualTo: childId)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((s) => s.docs.map(ParentNote.fromDoc).toList());

/// Bé: lời nhắn của mình — realtime.
final childNotesProvider = StreamProvider<List<ParentNote>>((ref) {
  final uid = ref.watch(authUidProvider).valueOrNull;
  if (uid == null) return Stream.value([]);
  return _notesForChild(uid);
});

/// Bố/mẹ: lời nhắn của mọi bé đang liên kết, mới nhất trước.
final parentNotesProvider = StreamProvider<List<ParentNote>>((ref) {
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
      combineLatest(value.split(',').map(_notesForChild).toList()).map(
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

class NoteActions {
  Future<void> add({
    required String childId,
    required String title,
    required String emoji,
  }) {
    return _notes.add({
      'childId': childId,
      'title': title,
      'emoji': emoji,
      'createdAt': FieldValue.serverTimestamp(),
      'isCompleted': false,
      'completedAt': null,
      'completedBy': null,
      'completedByName': null,
    });
  }

  /// Bố/mẹ đánh dấu đã làm (ghi tên mình) hoặc bỏ đánh dấu.
  Future<void> setDone(
    ParentNote note, {
    required bool done,
    required String byUid,
    required String byName,
  }) {
    return _notes.doc(note.id).update({
      'isCompleted': done,
      'completedAt': done ? FieldValue.serverTimestamp() : null,
      'completedBy': done ? byUid : null,
      'completedByName': done ? byName : null,
    });
  }

  Future<void> delete(String id) => _notes.doc(id).delete();
}

final noteActionsProvider = Provider((_) => NoteActions());
