import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_event_model.freezed.dart';
part 'geofence_event_model.g.dart';

@freezed
abstract class GeofenceEventModel with _$GeofenceEventModel {
  const factory GeofenceEventModel({
    required String id,
    required String zoneId,
    required String zoneName,
    required String childUid,
    required String childName,
    required String status, // 'enter' | 'exit'
    required DateTime timestamp,
  }) = _GeofenceEventModel;

  factory GeofenceEventModel.fromJson(Map<String, dynamic> json) =>
      _$GeofenceEventModelFromJson(json);
}
