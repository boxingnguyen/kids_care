class AppConstants {
  // Firestore collections
  static const String usersCollection = 'users';
  static const String linkCodesCollection = 'link_codes';
  static const String linkRequestsCollection = 'link_requests';
  static const String parentTodosCollection = 'parent_todos';
  static const String locationEventsCollection = 'location_events';
  static const String geofenceZonesCollection = 'geofence_zones';
  static const String statusCollection = 'child_status';
  static const String zonesSubcollection = 'zones';
  static const String geofenceEventsSubcollection = 'geofence_events';
  static const String locationSubcollection = 'location';
  static const String locationRequestsSubcollection = 'location_requests';

  // Username của con đăng nhập bằng email giả <username>@<domain> —
  // không xác thực được nên được miễn bước xác thực email.
  static const String childUsernameDomain = 'kidscare.app';

  // Cùng vùng với Cloud Functions (functions/index.js).
  static const String functionsRegion = 'asia-southeast1';

  // Trang chính sách quyền riêng tư (hosting/privacy.html, Firebase Hosting).
  static const String privacyPolicyUrl =
      'https://www.crosstechedu.com/projects/fam-hub/privacy/';

  // Geofence defaults
  static const double defaultGeofenceRadius = 500.0; // meters

  // Đã deploy Cloud Function đẩy FCM (functions/, cần gói Blaze + APNs key)?
  // false → app ở nền vẫn tự bắn thông báo local từ stream Firestore;
  // true → chỉ bắn local khi app đang mở, ở nền để FCM lo (không trùng).
  static const bool serverPushEnabled = true;

  // Shared prefs keys
  static const String prefUserMode = 'user_mode'; // 'child' or 'parent'
  static const String prefChildName = 'child_name';
  static const String prefParentFcmToken = 'parent_fcm_token';

  // Demo / stub parent phone
  static const String demoParentPhone = 'tel:+84338305895';

  // Mapbox public token (pk.*) — truyền khi build:
  // flutter run --dart-define=MAPBOX_ACCESS_TOKEN=pk.xxx
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
  );

  // ZegoCloud credentials - get from console.zegocloud.com
  // Replace with your actual AppID (integer) and AppSign (string)
  static const int zegoAppId = 1148150326; // YOUR_ZEGO_APP_ID
  static const String zegoAppSign = '';

  // Zego User IDs for demo mode
  // In production, these should come from your auth system (e.g. Firebase UID)
  static const String zegoChildUserId = 'child_user_001';
  static const String zegoChildUserName = 'Con';
  static const String zegoParentUserId = 'parent_user_001';
  static const String zegoParentUserName = 'Bố/Mẹ';
}
