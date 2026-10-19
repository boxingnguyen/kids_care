import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofencing_api/geofencing_api.dart';
import '../core/constants/app_constants.dart';
import '../models/geofence_zone_model.dart';

final geofenceZonesProvider =
    StateNotifierProvider<GeofenceZonesNotifier, List<GeofenceZoneModel>>((ref) {
  return GeofenceZonesNotifier();
});

class GeofenceZonesNotifier extends StateNotifier<List<GeofenceZoneModel>> {
  static const int maxZones = 3;

  FirebaseFirestore get _db => FirebaseFirestore.instance;
  String? _parentId;
  bool _listenersAttached = false;

  GeofenceZonesNotifier() : super([]);

  /// Danh sách vùng hiện tại (cho code ngoài notifier, vd. GeofenceService).
  List<GeofenceZoneModel> get zones => state;

  /// Throws [StateError] nếu đã đủ [maxZones] vùng.
  static void checkZoneLimit(int currentCount) {
    if (currentCount >= maxZones) {
      throw StateError('Tối đa 3 vùng an toàn');
    }
  }

  CollectionReference<Map<String, dynamic>> _zonesRef(String parentId) => _db
      .collection(AppConstants.usersCollection)
      .doc(parentId)
      .collection(AppConstants.zonesSubcollection);

  /// Loads the parent's zones from Firestore.
  /// [monitor] = true chỉ dùng ở máy con: đăng ký các vùng để theo dõi vị trí.
  Future<void> loadZonesForParent(String parentId, {bool monitor = false}) async {
    _parentId = parentId;
    final snap = await _zonesRef(parentId).get();
    final zones =
        snap.docs.map((d) => GeofenceZoneModel.fromJson(d.data())).toList();
    state = zones;
    if (monitor) await _startMonitoring(zones);
  }

  Future<void> _startMonitoring(List<GeofenceZoneModel> zones) async {
    final regions = zones.map(_createRegion).toSet();

    // Đã chạy rồi → chỉ thay danh sách vùng (start() lần 2 sẽ throw).
    if (Geofencing.instance.isRunningService) {
      Geofencing.instance.clearAllRegions();
      Geofencing.instance.addRegions(regions);
      return;
    }

    final hasPermission = await _requestLocationPermission();
    if (!hasPermission) return;

    Geofencing.instance.setup(
      interval: 10000, // 10s to save battery while moving
      accuracy: 100,
      statusChangeDelay: 5000,
      allowsMockLocation: true,
      printsDebugLog: kDebugMode,
    );

    if (!_listenersAttached) {
      Geofencing.instance.addGeofenceStatusChangedListener(_onStatusChanged);
      Geofencing.instance.addGeofenceErrorCallbackListener(_onError);
      _listenersAttached = true;
    }

    await Geofencing.instance.start(regions: regions);
  }

  GeofenceRegion _createRegion(GeofenceZoneModel z) => GeofenceRegion.circular(
        id: z.id,
        center: LatLng(z.lat, z.lng),
        radius: z.radiusMeters,
        loiteringDelay: 30000,
      );

  Future<void> _onStatusChanged(
    GeofenceRegion region,
    GeofenceStatus status,
    Location location,
  ) async {
    debugPrint('GEOFENCE => ID: ${region.id}, Status: ${status.name}');
  }

  void _onError(Object error, StackTrace stackTrace) {
    debugPrint('GEOFENCE ERROR => $error');
  }

  Future<bool> _requestLocationPermission() async {
    if (!await Geofencing.instance.isLocationServicesEnabled) return false;
    LocationPermission permission =
        await Geofencing.instance.getLocationPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geofencing.instance.requestLocationPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    if (!kIsWeb &&
        Platform.isAndroid &&
        permission == LocationPermission.whileInUse) {
      permission = await Geofencing.instance.requestLocationPermission();
      if (permission != LocationPermission.always) {
        return false; // Background required for geofencing monitoring
      }
    }
    return true;
  }

  /// Adds a zone and persists it to Firestore. Max [maxZones].
  Future<void> addZone(GeofenceZoneModel zone) async {
    checkZoneLimit(state.length);
    state = [...state, zone];
    if (_parentId != null) {
      await _zonesRef(_parentId!).doc(zone.id).set(zone.toJson());
    }
    if (Geofencing.instance.isRunningService) {
      Geofencing.instance.addRegion(_createRegion(zone));
    }
  }

  /// Removes a zone and deletes it from Firestore.
  Future<void> removeZone(String id) async {
    state = state.where((z) => z.id != id).toList();
    if (_parentId != null) {
      await _zonesRef(_parentId!).doc(id).delete();
    }
    if (Geofencing.instance.isRunningService) {
      Geofencing.instance.removeRegionById(id);
    }
  }
}
