import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kids_care/l10n/app_localizations.dart';
import 'package:kids_care/l10n/locale_provider.dart';

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

  // Tạo sẵn kênh có âm riêng: FCM tới khi app đã tắt chỉ dùng được kênh
  // đã tồn tại (AndroidManifest default_notification_channel_id cùng id).
  final android = localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  final l10n = l10nWithoutContext(null);
  await android?.createNotificationChannel(
    AndroidNotificationChannel(
      alertChannelId,
      l10n.geofenceChannelName,
      description: l10n.geofenceChannelDesc,
      importance: Importance.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('child_alert'),
    ),
  );

  // Android 13+ tắt thông báo mặc định cho tới khi người dùng cấp quyền
  // POST_NOTIFICATIONS lúc chạy — không xin thì show() bị bỏ qua âm thầm.
  final granted = await android?.requestNotificationsPermission();
  if (granted == false) {
    debugPrint('Local notifications: permission denied');
  }
}

/// Kênh thông báo có âm `child_alert` — khớp ANDROID_CHANNEL_ID trong
/// functions/messages.js và meta-data trong AndroidManifest.
const alertChannelId = 'child_updates_v1';

/// Thông báo cập nhật từ bé / từ bố mẹ, kèm âm báo riêng `child_alert`
/// (android/app/src/main/res/raw, ios/Runner — có trong Copy Bundle Resources).
/// Kênh Android không đổi được âm sau khi tạo → kênh mới, id riêng.
Future<void> showAlertNotification({
  required int id,
  required String title,
  required String body,
  required AppLocalizations l10n,
}) async {
  if (!localNotificationsSupported) return;
  final details = NotificationDetails(
    android: AndroidNotificationDetails(
      alertChannelId,
      l10n.geofenceChannelName,
      channelDescription: l10n.geofenceChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('child_alert'),
    ),
    // Hiện và kêu cả khi app đang mở.
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound: true,
      sound: 'child_alert.wav',
    ),
  );
  await localNotificationsPlugin.show(id, title, body, details);
}
