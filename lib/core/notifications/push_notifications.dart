import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:kids_care/core/constants/app_constants.dart';

/// Thông báo đẩy (FCM) cho bố/mẹ khi app ở nền hoặc đã tắt. Cloud Function
/// `onGeofenceEventCreated` (functions/index.js) gửi tới mọi token trong
/// users/{uid}.fcmTokens, theo ngôn ngữ ở users/{uid}.locale.
///
/// Khi app đang mở, thông báo FCM không hiện (mặc định của Android/iOS) —
/// NotificationsNotifier tự bắn thông báo local từ stream Firestore.
class PushNotifications {
  PushNotifications._();
  static final PushNotifications instance = PushNotifications._();

  static bool get supported => !kIsWeb;

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  String? _uid;
  String? _token;
  StreamSubscription<String>? _refreshSub;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection(AppConstants.usersCollection).doc(uid);

  /// Xin quyền, lấy token và lưu vào doc của [uid]. Gọi lại nhiều lần không sao.
  Future<void> register(String uid, {required String locale}) async {
    if (!supported || _uid == uid) return;
    _uid = uid;
    try {
      final settings = await _fcm.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('PushNotifications: permission denied');
        return;
      }
      final token = await _getToken();
      if (token == null || _uid != uid) return;
      await _saveToken(uid, token, locale: locale);

      await _refreshSub?.cancel();
      _refreshSub = _fcm.onTokenRefresh.listen((t) async {
        final current = _uid;
        if (current == null) return;
        final old = _token;
        await _saveToken(current, t);
        if (old != null && old != t) {
          await _userDoc(current).update({
            'fcmTokens': FieldValue.arrayRemove([old]),
          });
        }
      });
    } catch (e) {
      debugPrint('PushNotifications: register failed: $e');
      if (_uid == uid) _uid = null; // cho phép thử lại lần sau
    }
  }

  /// Cập nhật ngôn ngữ thông báo đẩy khi người dùng đổi trong Cài đặt.
  Future<void> updateLocale(String locale) async {
    final uid = _uid;
    if (!supported || uid == null) return;
    try {
      await _userDoc(uid).update({'locale': locale});
    } catch (e) {
      debugPrint('PushNotifications: updateLocale failed: $e');
    }
  }

  /// Gỡ token khỏi doc — phải gọi TRƯỚC khi đăng xuất (rule cần còn đăng nhập),
  /// nếu không máy này vẫn nhận thông báo của tài khoản cũ.
  /// [removeFromProfile] false khi hồ sơ đã bị xoá cùng tài khoản.
  Future<void> unregister({bool removeFromProfile = true}) async {
    final uid = _uid;
    final token = _token;
    _uid = null;
    _token = null;
    await _refreshSub?.cancel();
    _refreshSub = null;
    if (!supported || uid == null) return;
    try {
      if (token != null && removeFromProfile) {
        await _userDoc(uid).update({
          'fcmTokens': FieldValue.arrayRemove([token]),
        });
      }
      await _fcm.deleteToken();
    } catch (e) {
      debugPrint('PushNotifications: unregister failed: $e');
    }
  }

  /// iOS: getToken() lỗi khi chưa có APNs token → chờ một chút rồi thử lại.
  Future<String?> _getToken() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      var apns = await _fcm.getAPNSToken();
      for (var i = 0; apns == null && i < 5; i++) {
        await Future<void>.delayed(const Duration(seconds: 2));
        apns = await _fcm.getAPNSToken();
      }
      if (apns == null) {
        debugPrint('PushNotifications: no APNs token (simulator?)');
        return null;
      }
    }
    return _fcm.getToken();
  }

  Future<void> _saveToken(String uid, String token, {String? locale}) async {
    _token = token;
    await _userDoc(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
      'locale': ?locale,
    });
  }
}
