import 'dart:async';
import 'dart:ui' show Locale, PlatformDispatcher;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState, WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/core/notifications/local_notifications.dart';
import 'package:kids_care/core/notifications/push_notifications.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/l10n/l10n.dart';
import 'package:kids_care/l10n/locale_provider.dart';
import 'package:kids_care/models/geofence_event_model.dart';

/// Stream cập nhật của các bé từ users/{parentId}/geofence_events (vùng an
/// toàn, trạng thái, chia sẻ vị trí, việc cần làm) và bắn thông báo local có
/// âm thanh cho cập nhật mới.
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<GeofenceEventModel>>((
      ref,
    ) {
      // Đọc ngôn ngữ mỗi lần bắn thông báo để luôn khớp lựa chọn mới nhất.
      final notifier = NotificationsNotifier(
        localeOf: () => ref.read(localeProvider),
      );
      String pushLocale() =>
          (ref.read(localeProvider) ??
                  resolveLocale(PlatformDispatcher.instance.locales))
              .languageCode;
      ref.listen(currentUserProvider, (_, next) {
        final user = next.value;
        if (user != null && user.role == 'parent') {
          notifier.startListening(user.uid);
          // Token FCM để Cloud Function đẩy thông báo khi app ở nền / đã tắt.
          PushNotifications.instance.register(user.uid, locale: pushLocale());
        } else {
          notifier.stopListening();
        }
      }, fireImmediately: true);
      ref.listen(localeProvider, (_, _) {
        PushNotifications.instance.updateLocale(pushLocale());
      });
      return notifier;
    });

/// Tiêu đề + nội dung thông báo cho một cập nhật của bé.
({String title, String body}) describeChildEvent(
  AppLocalizations l10n,
  GeofenceEventModel e,
) {
  final name = e.childName;
  return switch (e.type) {
    ChildEventType.status => (
      title: '${statusCodeEmoji(e.status)} $name',
      body: localizedStatusCode(l10n, e.status),
    ),
    ChildEventType.shareStarted => (
      title: '📍 $name',
      body: l10n.eventShareStarted(name),
    ),
    ChildEventType.shareStopped => (
      title: '📍 $name',
      body: l10n.eventShareStopped(name),
    ),
    ChildEventType.todoCreated => (
      title: '📝 $name',
      body: l10n.eventTodoCreated(name, e.zoneName),
    ),
    ChildEventType.noteCreated => (
      title: '💌 $name',
      body: l10n.eventNoteCreated(name, e.zoneName),
    ),
    ChildEventType.todoDone => (
      title: '🎉 $name',
      body: l10n.eventTodoDone(name, e.zoneName),
    ),
    _ =>
      e.status == 'exit'
          ? (
              title: '⚠️ ${e.zoneName}',
              body: l10n.geofenceLeft(name, e.zoneName),
            )
          : (
              title: '✅ ${e.zoneName}',
              body: l10n.geofenceEntered(name, e.zoneName),
            ),
  };
}

class NotificationsNotifier extends StateNotifier<List<GeofenceEventModel>> {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  String? _listeningParentId;
  final DateTime _startedAt = DateTime.now();

  /// Ngôn ngữ người dùng chọn (null = theo thiết bị) — dùng cho thông báo đẩy.
  final Locale? Function() _localeOf;

  NotificationsNotifier({Locale? Function()? localeOf})
    : _localeOf = localeOf ?? (() => null),
      super([]);

  /// Chỉ thông báo sự kiện xảy ra sau khi app mở — tránh phát lại lịch sử.
  static bool shouldNotify(DateTime eventTime, DateTime startedAt) =>
      eventTime.isAfter(startedAt);

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
          state = [for (final d in snap.docs) ?_parse(d.data())];

          for (final change in snap.docChanges) {
            if (change.type != DocumentChangeType.added) continue;
            final model = _parse(change.doc.data());
            if (model != null && shouldNotify(model.timestamp, _startedAt)) {
              _notify(model);
            }
          }
        }, onError: (e) => debugPrint('NotificationsNotifier error: $e'));
  }

  /// Bỏ qua doc lỗi thay vì làm hỏng cả danh sách.
  static GeofenceEventModel? _parse(Map<String, dynamic>? data) {
    if (data == null) return null;
    try {
      return GeofenceEventModel.fromJson(data);
    } catch (e) {
      debugPrint('NotificationsNotifier: bad event $data: $e');
      return null;
    }
  }

  void stopListening() {
    _sub?.cancel();
    _sub = null;
    _listeningParentId = null;
    state = [];
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _notify(GeofenceEventModel event) async {
    // Khi đã có Cloud Function đẩy FCM, app ở nền nhận thông báo từ FCM →
    // không bắn thêm thông báo local (tránh 2 thông báo cho một sự kiện).
    // iOS khi app đang mở không hiện FCM nên vẫn bắn local.
    if (AppConstants.serverPushEnabled &&
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return;
    }
    final l10n = l10nWithoutContext(_localeOf());
    final text = describeChildEvent(l10n, event);
    await showAlertNotification(
      id: event.id.hashCode,
      title: text.title,
      body: text.body,
      l10n: l10n,
    );
  }
}
