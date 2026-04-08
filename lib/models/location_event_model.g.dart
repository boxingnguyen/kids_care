// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationEventModelImpl _$$LocationEventModelImplFromJson(
  Map<String, dynamic> json,
) => _$LocationEventModelImpl(
  id: json['id'] as String,
  childId: json['childId'] as String,
  childName: json['childName'] as String,
  eventType: $enumDecode(_$LocationEventTypeEnumMap, json['eventType']),
  zoneName: json['zoneName'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  statusLabel: json['statusLabel'] as String?,
);

Map<String, dynamic> _$$LocationEventModelImplToJson(
  _$LocationEventModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'childId': instance.childId,
  'childName': instance.childName,
  'eventType': _$LocationEventTypeEnumMap[instance.eventType]!,
  'zoneName': instance.zoneName,
  'timestamp': instance.timestamp.toIso8601String(),
  'lat': instance.lat,
  'lng': instance.lng,
  'statusLabel': instance.statusLabel,
};

const _$LocationEventTypeEnumMap = {
  LocationEventType.arrived: 'arrived',
  LocationEventType.left: 'left',
  LocationEventType.statusUpdate: 'statusUpdate',
  LocationEventType.emergency: 'emergency',
};
