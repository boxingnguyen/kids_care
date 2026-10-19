import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/core/notifications/local_notifications.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/models/geofence_event_model.dart';
import 'package:kids_care/models/location_event_model.dart';

/// Stream sự kiện geofence của bố/mẹ đang đăng nhập từ
/// users/{parentId}/geofence_events và bắn thông báo local cho sự kiện mới.
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<LocationEventModel>>((ref) {
  final notifier = NotificationsNotifier();
  ref.listen(currentUserProvider, (_, next) {
    final user = next.value;
    if (user != null && user.role == 'parent') {
      notifier.startListening(user.uid);
    } else {
      notifier.stopListening();
    }
  }, fireImmediately: true);
  return notifier;
});

class NotificationsNotifier extends StateNotifier<List<LocationEventModel>> {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  String? _listeningParentId;
  final DateTime _startedAt = DateTime.now();

  NotificationsNotifier() : super([]);

  /// Chỉ thông báo sự kiện xảy ra sau khi app mở — tránh phát lại lịch sử.
  static bool shouldNotify(DateTime eventTime, DateTime startedAt) =>
      eventTime.isAfter(startedAt);

  /// Thêm sự kiện local (vd. con tự báo trạng thái trên máy của con).
  void addEvent(LocationEventModel event) {
    state = [event, ...state];
  }

  /// Call this once the parent's UID is known (after auth + link).
  void startListening(String parentId) {
    if (_listeningParentId == parentId && _sub != null) return;
    _sub?.cancel();
    _listeningParentId = parentId;
    _sub = _db
        .collection(AppConstants.usersCollection)
        .doc(parentId)
        .collection(AppConstants.geofenceEventsSubcollection)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .listen((snap) {
      state = snap.docs
          .map((d) => _toLocationEvent(GeofenceEventModel.fromJson(d.data())))
          .toList();

      for (final change in snap.docChanges) {
        if (change.type != DocumentChangeType.added) continue;
        final model = GeofenceEventModel.fromJson(change.doc.data()!);
        if (shouldNotify(model.timestamp, _startedAt)) {
          _notify(model);
        }
      }
    }, onError: (e) => debugPrint('NotificationsNotifier error: $e'));
  }

  void stopListening() {
    _sub?.cancel();
    _sub = null;
    _listeningParentId = null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  LocationEventModel _toLocationEvent(GeofenceEventModel e) {
    return LocationEventModel(
      id: e.id,
      childId: e.childUid,
      childName: e.childName,
      eventType:
          e.status == 'exit' ? LocationEventType.left : LocationEventType.arrived,
      zoneName: e.zoneName,
      timestamp: e.timestamp.toLocal(),
      statusLabel: e.status == 'exit' ? 'Rời khỏi' : 'Đã đến',
    );
  }

  Future<void> _notify(GeofenceEventModel event) async {
    if (!localNotificationsSupported) return;
    final isExit = event.status == 'exit';
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'geofence_channel',
        'Thông báo vùng an toàn',
        channelDescription: 'Thông báo khi con vào/ra khỏi vùng an toàn',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await localNotificationsPlugin.show(
      event.id.hashCode,
      isExit ? '⚠️ ${event.zoneName}' : '✅ ${event.zoneName}',
      isExit
          ? '${event.childName} vừa rời khỏi ${event.zoneName}'
          : '${event.childName} đã vào ${event.zoneName}',
      details,
    );
  }
}
