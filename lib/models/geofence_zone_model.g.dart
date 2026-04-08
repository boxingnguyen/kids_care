// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_zone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GeofenceZoneModelImpl _$$GeofenceZoneModelImplFromJson(
  Map<String, dynamic> json,
) => _$GeofenceZoneModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  radiusMeters: (json['radiusMeters'] as num?)?.toDouble() ?? 1000.0,
  emoji: json['emoji'] as String? ?? '🏠',
);

Map<String, dynamic> _$$GeofenceZoneModelImplToJson(
  _$GeofenceZoneModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lng': instance.lng,
  'radiusMeters': instance.radiusMeters,
  'emoji': instance.emoji,
};
