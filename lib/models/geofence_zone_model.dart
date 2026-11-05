import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kids_care/core/constants/app_constants.dart';

part 'geofence_zone_model.freezed.dart';
part 'geofence_zone_model.g.dart';

@freezed
abstract class GeofenceZoneModel with _$GeofenceZoneModel {
  const factory GeofenceZoneModel({
    required String id,
    required String name,
    required double lat,
    required double lng,
    @Default(AppConstants.defaultGeofenceRadius) double radiusMeters,
    @Default('🏠') String emoji,
  }) = _GeofenceZoneModel;

  factory GeofenceZoneModel.fromJson(Map<String, dynamic> json) =>
      _$GeofenceZoneModelFromJson(json);
}
