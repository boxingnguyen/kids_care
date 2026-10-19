import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_event_model.freezed.dart';
part 'location_event_model.g.dart';

enum LocationEventType {
  arrived,
  left,
  statusUpdate,
  emergency,
}

extension LocationEventTypeExt on LocationEventType {
  String get label {
    switch (this) {
      case LocationEventType.arrived:
        return 'Đã đến';
      case LocationEventType.left:
        return 'Rời khỏi';
      case LocationEventType.statusUpdate:
        return 'Cập nhật trạng thái';
      case LocationEventType.emergency:
        return 'Khẩn cấp';
    }
  }
}

@freezed
abstract class LocationEventModel with _$LocationEventModel {
  const factory LocationEventModel({
    required String id,
    required String childId,
    required String childName,
    required LocationEventType eventType,
    required String zoneName,
    required DateTime timestamp,
    double? lat,
    double? lng,
    String? statusLabel,
  }) = _LocationEventModel;

  factory LocationEventModel.fromJson(Map<String, dynamic> json) =>
      _$LocationEventModelFromJson(json);
}
