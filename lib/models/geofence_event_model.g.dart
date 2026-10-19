// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeofenceEventModel _$GeofenceEventModelFromJson(Map<String, dynamic> json) =>
    _GeofenceEventModel(
      id: json['id'] as String,
      zoneId: json['zoneId'] as String,
      zoneName: json['zoneName'] as String,
      childUid: json['childUid'] as String,
      childName: json['childName'] as String,
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$GeofenceEventModelToJson(_GeofenceEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'zoneId': instance.zoneId,
      'zoneName': instance.zoneName,
      'childUid': instance.childUid,
      'childName': instance.childName,
      'status': instance.status,
      'timestamp': instance.timestamp.toIso8601String(),
    };
