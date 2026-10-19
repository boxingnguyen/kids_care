import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Global notifications plugin instance — used by NotificationsProvider
final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// flutter_local_notifications không hỗ trợ web → bỏ qua trên web.
bool get localNotificationsSupported => !kIsWeb;

Future<void> initLocalNotifications() async {
  if (!localNotificationsSupported) return;
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  await localNotificationsPlugin.initialize(
    const InitializationSettings(android: androidSettings, iOS: iosSettings),
  );
}
