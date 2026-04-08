import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofencing_api/geofencing_api.dart';
import '../models/geofence_zone_model.dart';
import 'package:flutter/foundation.dart';

final geofenceZonesProvider =
    StateNotifierProvider<GeofenceZonesNotifier, List<GeofenceZoneModel>>((ref) {
  return GeofenceZonesNotifier();
});

class GeofenceZonesNotifier extends StateNotifier<List<GeofenceZoneModel>> {
  GeofenceZonesNotifier() : super(_defaultZones()) {
    _initGeofencing();
  }

  Future<void> _initGeofencing() async {
    bool hasPermission = await _requestLocationPermission();
    if (!hasPermission) return;

    Geofencing.instance.setup(
      interval: 10000, // 10s to save battery while moving
      accuracy: 100,
      statusChangeDelay: 5000,
      allowsMockLocation: true,
      printsDebugLog: kDebugMode,
    );

    Geofencing.instance.addGeofenceStatusChangedListener(_onGeofenceStatusChanged);
    Geofencing.instance.addGeofenceErrorCallbackListener(_onGeofenceError);

    final regions = state.map((z) => _createRegion(z)).toSet();
    await Geofencing.instance.start(regions: regions);
  }

  GeofenceRegion _createRegion(GeofenceZoneModel z) {
    return GeofenceRegion.circular(
      id: z.id,
      center: LatLng(z.lat, z.lng),
      radius: z.radiusMeters,
      loiteringDelay: 30000,
    );
  }

  Future<void> _onGeofenceStatusChanged(
    GeofenceRegion geofenceRegion,
    GeofenceStatus geofenceStatus,
    Location location,
  ) async {
    debugPrint('GEOFENCE EVENT => ID: \${geofenceRegion.id}, Status: \${geofenceStatus.name}');
    // Notification logic or Firestore sync goes here.
  }

  void _onGeofenceError(Object error, StackTrace stackTrace) {
    debugPrint('GEOFENCE ERROR => $error');
  }

  Future<bool> _requestLocationPermission() async {
    if (!await Geofencing.instance.isLocationServicesEnabled) return false;

    LocationPermission permission = await Geofencing.instance.getLocationPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geofencing.instance.requestLocationPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return false;
    }

    if (!kIsWeb && Platform.isAndroid && permission == LocationPermission.whileInUse) {
      permission = await Geofencing.instance.requestLocationPermission();
      if (permission != LocationPermission.always) {
        return false; // Background required for perfect geofencing monitoring
      }
    }
    return true;
  }

  void addZone(GeofenceZoneModel zone) {
    state = [...state, zone];
    Geofencing.instance.addRegion(_createRegion(zone));
  }

  void removeZone(String id) {
    state = state.where((z) => z.id != id).toList();
    Geofencing.instance.removeRegionById(id);
  }

  static List<GeofenceZoneModel> _defaultZones() => [
        const GeofenceZoneModel(
          id: 'home',
          name: 'Nhà',
          lat: 10.7769,
          lng: 106.7009,
          radiusMeters: 500,
          emoji: '🏠',
        ),
        const GeofenceZoneModel(
          id: 'school',
          name: 'Trường học',
          lat: 10.7800,
          lng: 106.7050,
          radiusMeters: 300,
          emoji: '🏫',
        ),
      ];
}
