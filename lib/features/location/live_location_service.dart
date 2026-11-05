import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/features/child/child_events.dart';
import 'package:kids_care/l10n/locale_provider.dart';
import 'package:kids_care/models/geofence_event_model.dart';
import 'package:kids_care/models/user_model.dart';

/// Lỗi khi bắt đầu chia sẻ — UI dịch sang thông báo phù hợp.
enum LiveShareError {
  serviceDisabled,
  permissionDenied,
  permissionForever,
  noFix,
}

class LiveShareException implements Exception {
  final LiveShareError error;
  const LiveShareException(this.error);
}

/// Bé chia sẻ vị trí trực tiếp trong [shareDuration] (giống Messenger), kể cả
/// khi app chạy nền. Vị trí ghi vào users/{bé}/location/current; bố/mẹ đang
/// liên kết đọc realtime. State = thời điểm hết hạn (null = không chia sẻ).
class LiveShareNotifier extends StateNotifier<DateTime?> {
  LiveShareNotifier({Locale? Function()? localeOf})
    : _localeOf = localeOf ?? (() => null),
      super(null);

  static const shareDuration = Duration(minutes: 60);

  /// Ghi tối đa mỗi [_minWriteGap] — đủ mượt cho bố/mẹ, đỡ tốn pin/lượt ghi.
  static const _minWriteGap = Duration(seconds: 15);

  final Locale? Function() _localeOf;
  StreamSubscription<Position>? _sub;
  Timer? _expiryTimer;
  DateTime? _lastWrite;
  String? _childUid;

  bool get isSharing => state != null;

  static DocumentReference<Map<String, dynamic>> _doc(String childUid) =>
      FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(childUid)
          .collection(AppConstants.locationSubcollection)
          .doc('current');

  /// Ghi "vị trí gần nhất" (giữ nguyên sharingUntil đang có).
  static Future<void> writeLastLocation(
    String childUid, {
    required double lat,
    required double lng,
    double? accuracy,
  }) async {
    try {
      await _doc(childUid).set({
        'lat': lat,
        'lng': lng,
        'accuracy': accuracy,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('LiveShare: write last location failed: $e');
    }
  }

  /// Xin quyền / kiểm tra dịch vụ vị trí; ném [LiveShareException] nếu không được.
  static Future<void> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LiveShareException(LiveShareError.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LiveShareException(LiveShareError.permissionForever);
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      throw const LiveShareException(LiveShareError.permissionDenied);
    }
  }

  /// Bắt đầu chia sẻ 60 phút: ghi vị trí ngay, xoá các yêu cầu đang chờ và
  /// báo cho bố/mẹ.
  Future<void> start(UserModel child) async {
    await ensurePermission();
    final until = DateTime.now().add(shareDuration);
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (_) {
      position = await Geolocator.getLastKnownPosition();
    }
    if (position == null) throw const LiveShareException(LiveShareError.noFix);

    await _doc(child.uid).set({
      'lat': position.latitude,
      'lng': position.longitude,
      'accuracy': position.accuracy,
      'updatedAt': FieldValue.serverTimestamp(),
      'sharingUntil': Timestamp.fromDate(until),
    });
    _lastWrite = DateTime.now();
    _listen(child.uid, until);

    unawaited(_clearRequests(child.uid));
    unawaited(ChildEvents.publishFor(child, type: ChildEventType.shareStarted));
  }

  /// Mở lại app khi còn hạn chia sẻ → tiếp tục gửi vị trí (không báo lại).
  Future<void> resumeIfNeeded(String childUid) async {
    if (_childUid == childUid && _sub != null) return;
    try {
      final snap = await _doc(childUid).get();
      final until = (snap.data()?['sharingUntil'] as Timestamp?)?.toDate();
      if (until == null || !until.isAfter(DateTime.now())) {
        if (until != null) await _doc(childUid).update({'sharingUntil': null});
        return;
      }
      await ensurePermission();
      _listen(childUid, until);
    } catch (e) {
      debugPrint('LiveShare: resume failed: $e');
    }
  }

  /// Bé tự dừng → báo cho bố/mẹ. [notify] false khi dừng do đăng xuất/gỡ liên kết.
  Future<void> stop({UserModel? child, bool notify = true}) async {
    final uid = _childUid;
    _cancel();
    if (uid == null) return;
    try {
      await _doc(uid).update({'sharingUntil': null});
    } catch (e) {
      debugPrint('LiveShare: stop write failed: $e');
    }
    if (notify) {
      unawaited(
        ChildEvents.publishFor(child, type: ChildEventType.shareStopped),
      );
    }
  }

  void _listen(String childUid, DateTime until) {
    _cancel();
    _childUid = childUid;
    state = until;
    _expiryTimer = Timer(until.difference(DateTime.now()), _expire);
    _sub = Geolocator.getPositionStream(locationSettings: _settings()).listen(
      (p) => _onPosition(childUid, p),
      onError: (Object e) => debugPrint('LiveShare: stream error: $e'),
    );
  }

  Future<void> _onPosition(String childUid, Position p) async {
    final until = state;
    if (until == null) return;
    if (!until.isAfter(DateTime.now())) return _expire();
    final last = _lastWrite;
    if (last != null && DateTime.now().difference(last) < _minWriteGap) return;
    _lastWrite = DateTime.now();
    try {
      await _doc(childUid).set({
        'lat': p.latitude,
        'lng': p.longitude,
        'accuracy': p.accuracy,
        'updatedAt': FieldValue.serverTimestamp(),
        'sharingUntil': Timestamp.fromDate(until),
      });
    } catch (e) {
      debugPrint('LiveShare: write failed: $e');
    }
  }

  /// Hết 60 phút: dừng gửi, bố/mẹ thấy "đã dừng" qua sharingUntil.
  Future<void> _expire() => stop(notify: false);

  void _cancel() {
    _sub?.cancel();
    _sub = null;
    _expiryTimer?.cancel();
    _expiryTimer = null;
    _lastWrite = null;
    if (mounted) state = null;
    _childUid = null;
  }

  Future<void> _clearRequests(String childUid) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(childUid)
          .collection(AppConstants.locationRequestsSubcollection)
          .get();
      for (final d in snap.docs) {
        await d.reference.delete();
      }
    } catch (e) {
      debugPrint('LiveShare: clear requests failed: $e');
    }
  }

  /// Cấu hình chạy nền: iOS cần UIBackgroundModes=location (Info.plist),
  /// Android chạy foreground service kèm thông báo cố định.
  LocationSettings _settings() {
    if (kIsWeb) return const LocationSettings(accuracy: LocationAccuracy.high);
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final l10n = l10nWithoutContext(_localeOf());
        return AndroidSettings(
          accuracy: LocationAccuracy.high,
          intervalDuration: _minWriteGap,
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationTitle: l10n.liveShareNotifTitle,
            notificationText: l10n.liveShareNotifText,
            enableWakeLock: true,
            setOngoing: true,
          ),
        );
      case TargetPlatform.iOS:
        return AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.other,
          pauseLocationUpdatesAutomatically: false,
          showBackgroundLocationIndicator: true,
          allowBackgroundLocationUpdates: true,
        );
      default:
        return const LocationSettings(accuracy: LocationAccuracy.high);
    }
  }

  @override
  void dispose() {
    _cancel();
    super.dispose();
  }
}

final liveShareProvider = StateNotifierProvider<LiveShareNotifier, DateTime?>(
  (ref) => LiveShareNotifier(localeOf: () => ref.read(localeProvider)),
);
