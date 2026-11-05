import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofencing_api/geofencing_api.dart';
import '../core/constants/app_constants.dart';
import '../models/geofence_zone_model.dart';

final geofenceZonesProvider =
    StateNotifierProvider<GeofenceZonesNotifier, List<GeofenceZoneModel>>((
      ref,
    ) {
      return GeofenceZonesNotifier();
    });

/// Vùng an toàn của một bé (users/{childId}/zones), realtime — mọi bố/mẹ đang
/// liên kết cùng thêm/xoá. Tối đa [maxZones], mỗi vùng chiếm một ô cố định
/// ([slotIds]); rules không cho ghi đè ô đã có.
class GeofenceZonesNotifier extends StateNotifier<List<GeofenceZoneModel>> {
  static const int maxZones = 3;
  static const slotIds = ['z1', 'z2', 'z3'];

  FirebaseFirestore get _db => FirebaseFirestore.instance;
  String? _childId;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  bool _listenersAttached = false;

  /// Đăng ký vùng với Geofencing chạy nối tiếp (start() lần 2 song song sẽ throw).
  Future<void> _monitorQueue = Future.value();

  GeofenceZonesNotifier() : super([]);

  /// Danh sách vùng hiện tại (cho code ngoài notifier, vd. GeofenceService).
  List<GeofenceZoneModel> get zones => state;

  /// Throws [StateError] nếu đã đủ [maxZones] vùng.
  static void checkZoneLimit(int currentCount) {
    if (currentCount >= maxZones) {
      throw StateError('Tối đa 3 vùng an toàn');
    }
  }

  /// Ô trống đầu tiên, hoặc null nếu đã đủ [maxZones].
  static String? freeSlot(Iterable<String> taken) {
    final used = taken.toSet();
    for (final id in slotIds) {
      if (!used.contains(id)) return id;
    }
    return null;
  }

  CollectionReference<Map<String, dynamic>> _zonesRef(String childId) => _db
      .collection(AppConstants.usersCollection)
      .doc(childId)
      .collection(AppConstants.zonesSubcollection);

  /// Theo dõi realtime vùng của bé [childId] (thay cho bé đang theo dõi trước đó).
  /// [monitor] = true chỉ dùng ở máy con: đăng ký các vùng để theo dõi vị trí.
  void watchZones(String childId, {bool monitor = false}) {
    if (_childId == childId && _sub != null) return;
    _sub?.cancel();
    _childId = childId;
    state = [];
    _sub = _zonesRef(childId).snapshots().listen((snap) {
      final zones = snap.docs
          .map((d) => GeofenceZoneModel.fromJson({...d.data(), 'id': d.id}))
          .toList();
      state = zones;
      if (monitor) {
        _monitorQueue = _monitorQueue
            .then((_) => _startMonitoring(zones))
            .catchError((Object e) => debugPrint('GEOFENCE monitor: $e'));
      }
    }, onError: (Object e) => debugPrint('GEOFENCE zones stream: $e'));
  }

  /// Ngừng theo dõi vùng (vd. bé vừa gỡ hết liên kết, bố/mẹ đổi tài khoản).
  void stopWatching() {
    _sub?.cancel();
    _sub = null;
    _childId = null;
    state = [];
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
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
    LocationPermission permission = await Geofencing.instance
        .getLocationPermission();
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

  /// Thêm vùng vào ô trống đầu tiên. Hai bố/mẹ cùng thêm một lúc mà trùng ô
  /// thì người sau bị rules từ chối → thử ô kế tiếp.
  /// Throws [StateError] nếu đã đủ [maxZones] vùng.
  Future<void> addZone(GeofenceZoneModel zone) async {
    final childId = _childId;
    if (childId == null) throw StateError('Chưa chọn bé');
    final taken = (await _zonesRef(
      childId,
    ).get()).docs.map((d) => d.id).toSet();
    while (true) {
      final slot = freeSlot(taken);
      if (slot == null) throw StateError('Tối đa 3 vùng an toàn');
      try {
        await _zonesRef(
          childId,
        ).doc(slot).set(zone.copyWith(id: slot).toJson());
        return;
      } on FirebaseException catch (e) {
        if (e.code != 'permission-denied') rethrow;
        taken.add(slot);
      }
    }
  }

  /// Xoá vùng (snapshot realtime sẽ cập nhật danh sách và vùng theo dõi).
  Future<void> removeZone(String id) async {
    final childId = _childId;
    if (childId == null) return;
    await _zonesRef(childId).doc(id).delete();
  }
}
