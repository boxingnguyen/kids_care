import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/models/geofence_event_model.dart';
import 'package:kids_care/models/user_model.dart';

/// Bé gửi một cập nhật (trạng thái, chia sẻ vị trí, việc cần làm, vùng an
/// toàn) vào users/{parentId}/geofence_events của từng bố/mẹ đang liên kết —
/// bố/mẹ nhận thông báo kèm âm thanh.
abstract final class ChildEvents {
  static Future<void> publish({
    required List<String> parentIds,
    required String childUid,
    required String childName,
    required String type,
    String status = '',
    String zoneId = '',
    String zoneName = '',
  }) async {
    if (parentIds.isEmpty) return;
    final now = DateTime.now().toUtc();
    // Một lần định vị có thể báo ra z1 + vào z2 cùng lúc → kèm zoneId và
    // micro giây để id không trùng (geofence_events không cho update).
    final eventId =
        '${childUid}_${type}_${zoneId.isEmpty ? '' : '${zoneId}_'}'
        '${now.microsecondsSinceEpoch}';
    final event = GeofenceEventModel(
      id: eventId,
      type: type,
      zoneId: zoneId,
      zoneName: zoneName,
      childUid: childUid,
      childName: childName,
      status: status,
      timestamp: now,
    );
    final users = FirebaseFirestore.instance.collection(
      AppConstants.usersCollection,
    );
    // Ghi riêng cho từng bố/mẹ — một người vừa gỡ liên kết không chặn người khác.
    for (final parentId in parentIds) {
      try {
        await users
            .doc(parentId)
            .collection(AppConstants.geofenceEventsSubcollection)
            .doc(eventId)
            .set(event.toJson());
      } catch (e) {
        debugPrint('ChildEvents: failed to write $type for $parentId: $e');
      }
    }
  }

  /// Gửi từ hồ sơ của bé đang đăng nhập.
  static Future<void> publishFor(
    UserModel? child, {
    required String type,
    String status = '',
    String zoneName = '',
  }) {
    if (child == null || child.role != 'child') return Future.value();
    return publish(
      parentIds: child.linkedParentIds,
      childUid: child.uid,
      childName: child.name,
      type: type,
      status: status,
      zoneName: zoneName,
    );
  }
}
