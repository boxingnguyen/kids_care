// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_zone_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeofenceZoneModel _$GeofenceZoneModelFromJson(Map<String, dynamic> json) =>
    _GeofenceZoneModel(
      id: json['id'] as String,
      name: json['name'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num?)?.toDouble() ?? 1000.0,
      emoji: json['emoji'] as String? ?? '🏠',
    );

Map<String, dynamic> _$GeofenceZoneModelToJson(_GeofenceZoneModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'radiusMeters': instance.radiusMeters,
      'emoji': instance.emoji,
    };
