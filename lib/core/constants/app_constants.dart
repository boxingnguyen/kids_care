class AppConstants {
  // Firestore collections
  static const String usersCollection = 'users';
  static const String locationEventsCollection = 'location_events';
  static const String geofenceZonesCollection = 'geofence_zones';
  static const String statusCollection = 'child_status';
  static const String zonesSubcollection = 'zones';
  static const String geofenceEventsSubcollection = 'geofence_events';

  // Geofence defaults
  static const double defaultGeofenceRadius = 150.0; // meters

  // Shared prefs keys
  static const String prefUserMode = 'user_mode'; // 'child' or 'parent'
  static const String prefChildName = 'child_name';
  static const String prefParentFcmToken = 'parent_fcm_token';

  // Demo / stub parent phone
  static const String demoParentPhone = 'tel:+84338305895';

  // Google Maps placeholder key - replace with real key in Info.plist / AndroidManifest
  static const String mapsApiKeyPlaceholder = 'YOUR_GOOGLE_MAPS_API_KEY';

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
