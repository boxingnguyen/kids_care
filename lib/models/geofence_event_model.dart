import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_event_model.freezed.dart';
part 'geofence_event_model.g.dart';

/// Loại cập nhật bé gửi cho bố/mẹ (users/{parentId}/geofence_events).
abstract final class ChildEventType {
  static const geofence = 'geofence'; // status: 'enter' | 'exit'
  static const status = 'status'; // status: tên ChildStatusType
  static const shareStarted = 'share_started';
  static const shareStopped = 'share_stopped';
  static const todoCreated = 'todo_created'; // zoneName: tiêu đề việc
  static const todoDone = 'todo_done'; // zoneName: tiêu đề việc
  static const noteCreated = 'note_created'; // zoneName: lời nhắn gửi bố/mẹ
}

@freezed
abstract class GeofenceEventModel with _$GeofenceEventModel {
  const factory GeofenceEventModel({
    required String id,
    // Doc cũ (build ≤ 3) không có type → mặc định là sự kiện vùng an toàn.
    @Default(ChildEventType.geofence) String type,
    @Default('') String zoneId,
    // Tên vùng, hoặc tiêu đề việc cần làm với todo_*.
    @Default('') String zoneName,
    required String childUid,
    required String childName,
    @Default('') String status,
    required DateTime timestamp,
  }) = _GeofenceEventModel;

  factory GeofenceEventModel.fromJson(Map<String, dynamic> json) =>
      _$GeofenceEventModelFromJson(json);
}
