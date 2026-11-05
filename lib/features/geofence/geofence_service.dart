import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofencing_api/geofencing_api.dart';
import 'package:kids_care/features/child/child_events.dart';
import 'package:kids_care/features/location/live_location_service.dart';
import 'package:kids_care/models/geofence_event_model.dart';
import 'package:kids_care/providers/geofence_provider.dart';

/// Child-side geofencing: theo dõi các vùng của chính bé (users/{bé}/zones) và
/// ghi sự kiện vào users/{parentId}/geofence_events của từng bố/mẹ đang liên kết.
class GeofenceService {
  List<String> _parentIds = const [];
  String? _childUid;
  String? _childName;
  GeofenceZonesNotifier? _zonesNotifier;
  bool _listenerAttached = false;

  static final GeofenceService instance = GeofenceService._();
  GeofenceService._();

  /// Map trạng thái geofence → 'enter' / 'exit'. Trả về null cho dwell (bỏ qua).
  static String? eventStatusFor(GeofenceStatus status) {
    switch (status) {
      case GeofenceStatus.enter:
        return 'enter';
      case GeofenceStatus.exit:
        return 'exit';
      case GeofenceStatus.dwell:
        return null;
    }
  }

  /// Starts child-side geofencing. Chưa liên kết ai → dừng, trả về false.
  Future<bool> start({
    required List<String> parentIds,
    required String childUid,
    required String childName,
    required GeofenceZonesNotifier zonesNotifier,
  }) async {
    _zonesNotifier = zonesNotifier;
    if (parentIds.isEmpty) {
      debugPrint('GeofenceService: no parent linked, stopping');
      await stop();
      return false;
    }
    _parentIds = List.of(parentIds);
    _childUid = childUid;
    _childName = childName;

    // Vùng của bé (realtime, bố/mẹ nào sửa cũng cập nhật) + theo dõi vị trí
    zonesNotifier.watchZones(childUid, monitor: true);

    if (!_listenerAttached) {
      Geofencing.instance.addGeofenceStatusChangedListener(_onStatusChanged);
      _listenerAttached = true;
    }
    return true;
  }

  /// Dừng theo dõi (vd. vừa gỡ hết liên kết) — không ghi sự kiện nữa.
  Future<void> stop() async {
    _parentIds = const [];
    _zonesNotifier?.stopWatching();
    if (Geofencing.instance.isRunningService) {
      await Geofencing.instance.stop();
    }
  }

  Future<void> _onStatusChanged(
    GeofenceRegion region,
    GeofenceStatus status,
    Location location,
  ) async {
    if (_parentIds.isEmpty || _childUid == null) return;

    final statusStr = eventStatusFor(status);
    if (statusStr == null) return;

    final zoneName =
        _zonesNotifier?.zones
            .where((z) => z.id == region.id)
            .map((z) => z.name)
            .firstOrNull ??
        region.id;

    // Vị trí lúc vào/ra vùng cũng là "vị trí gần nhất" bố/mẹ thấy ở trang chủ.
    unawaited(
      LiveShareNotifier.writeLastLocation(
        _childUid!,
        lat: location.latitude,
        lng: location.longitude,
        accuracy: location.accuracy,
      ),
    );

    await ChildEvents.publish(
      parentIds: _parentIds,
      childUid: _childUid!,
      childName: _childName ?? 'Con',
      type: ChildEventType.geofence,
      status: statusStr,
      zoneId: region.id,
      zoneName: zoneName,
    );
  }
}

final geofenceServiceProvider = Provider<GeofenceService>((ref) {
  return GeofenceService.instance;
});
