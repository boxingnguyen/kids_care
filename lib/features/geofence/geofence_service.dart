import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofencing_api/geofencing_api.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/models/geofence_event_model.dart';
import 'package:kids_care/providers/geofence_provider.dart';

/// Child-side geofencing: theo dõi các vùng của bố/mẹ và ghi sự kiện
/// vào users/{parentId}/geofence_events.
class GeofenceService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  String? _parentId;
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

  /// Starts child-side geofencing. No-op (returns false) if parentId is null.
  Future<bool> start({
    required String? parentId,
    required String childUid,
    required String childName,
    required GeofenceZonesNotifier zonesNotifier,
  }) async {
    if (parentId == null) {
      debugPrint('GeofenceService: no parent linked, skipping start');
      return false;
    }
    _parentId = parentId;
    _childUid = childUid;
    _childName = childName;
    _zonesNotifier = zonesNotifier;

    // Load parent's zones + start location monitoring
    await zonesNotifier.loadZonesForParent(parentId, monitor: true);

    if (!_listenerAttached) {
      Geofencing.instance.addGeofenceStatusChangedListener(_onStatusChanged);
      _listenerAttached = true;
    }
    return true;
  }

  Future<void> _onStatusChanged(
    GeofenceRegion region,
    GeofenceStatus status,
    Location location,
  ) async {
    if (_parentId == null || _childUid == null) return;

    final statusStr = eventStatusFor(status);
    if (statusStr == null) return;

    final zoneName = _zonesNotifier?.zones
            .where((z) => z.id == region.id)
            .map((z) => z.name)
            .firstOrNull ??
        region.id;

    final now = DateTime.now().toUtc();
    final eventId = '${_childUid}_${region.id}_${now.millisecondsSinceEpoch}';

    final event = GeofenceEventModel(
      id: eventId,
      zoneId: region.id,
      zoneName: zoneName,
      childUid: _childUid!,
      childName: _childName ?? 'Con',
      status: statusStr,
      timestamp: now,
    );

    try {
      await _db
          .collection(AppConstants.usersCollection)
          .doc(_parentId)
          .collection(AppConstants.geofenceEventsSubcollection)
          .doc(eventId)
          .set(event.toJson());
      debugPrint('GeofenceService: wrote event $statusStr for zone ${region.id}');
    } catch (e) {
      debugPrint('GeofenceService: failed to write event: $e');
    }
  }
}

final geofenceServiceProvider = Provider<GeofenceService>((ref) {
  return GeofenceService.instance;
});
