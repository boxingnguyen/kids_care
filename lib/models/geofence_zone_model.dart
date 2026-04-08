import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofence_zone_model.freezed.dart';
part 'geofence_zone_model.g.dart';

@freezed
class GeofenceZoneModel with _$GeofenceZoneModel {
  const factory GeofenceZoneModel({
    required String id,
    required String name,
    required double lat,
    required double lng,
    @Default(1000.0) double radiusMeters,
    @Default('🏠') String emoji,
  }) = _GeofenceZoneModel;

  factory GeofenceZoneModel.fromJson(Map<String, dynamic> json) =>
      _$GeofenceZoneModelFromJson(json);
}
