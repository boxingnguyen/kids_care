# Guest Mode & Geofencing Design

**Date:** 2026-10-15  
**Status:** Approved

---

## Overview

Two features added to Kids Care:

1. **Guest/Try Mode** — users can try the app without signing up. They pick a role (parent or child), get an anonymous Firebase account, share a 6-char link code to connect to each other, and both confirm the link.

2. **OS Geofencing** — parent sets up to 3 safe zones on a map. Child device monitors using native OS APIs (CLLocationManager iOS / Android Geofence API via `geofencing_api`). When child leaves a zone, an event is written to Firestore; parent app listens via stream and fires a local notification.

---

## Feature 1: Guest Mode & Account Linking

### User Flow

```
App launch
  └─ WelcomeScreen
       ├─ "Thử với tư cách Bố/Mẹ"  → GuestAuthService.signInAsGuest(role: 'parent')
       ├─ "Thử với tư cách Con"     → GuestAuthService.signInAsGuest(role: 'child')
       └─ "Đăng nhập"              → /login (existing)

After guest sign-in → routed to role home screen
  Parent home shows:  "Mã của bạn: ABC-123" + "Liên kết với con" button → /link
  Child home shows:   "Mã của bạn: XYZ-456" + "Liên kết với bố/mẹ" button → /link

LinkAccountScreen:
  - Text field: "Nhập mã của [bố/mẹ / con]"
  - Submit → query Firestore for user with that linkCode
  - Found → show confirm dialog: "Liên kết với [tên]?"
  - Confirm → write linkedParentId / linkedChildIds to both user docs
  - Both devices see link confirmed on next Firestore snapshot
```

### GuestAuthService

- `signInAsGuest(role)`: calls `FirebaseAuth.signInAnonymously()`, generates `linkCode`, writes `UserModel` to Firestore `users/{uid}`
- `generateLinkCode()`: produces a 6-char alphanumeric string (e.g. `ABC-123`) — must be unique, checked against Firestore before use
- `linkToUser(myUid, theirLinkCode)`: queries `users` collection where `linkCode == theirLinkCode`, validates role compatibility (parent↔child only), writes link to both documents atomically

### Data Model Changes

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String name,
    String? photoUrl,
    String? fcmToken,
    @Default('child') String role,
    // --- new fields ---
    @Default(false) bool isGuest,
    String? linkCode,           // "ABC-123", set on guest creation
    String? linkedParentId,     // child → parent uid
    @Default([]) List<String> linkedChildIds, // parent → child uids
  }) = _UserModel;
  ...
}
```

### Firestore Structure

```
users/
  {uid}/
    uid, name, photoUrl, fcmToken, role,
    isGuest, linkCode, linkedParentId, linkedChildIds

  {parentUid}/
    zones/
      {zoneId}/  ← GeofenceZoneModel
    geofence_events/
      {eventId}/ ← GeofenceEventModel
```

### Routing Changes

| Route | Screen |
|---|---|
| `/` | `WelcomeScreen` (new landing) |
| `/login` | `LoginScreen` (existing, unchanged) |
| `/link` | `LinkAccountScreen` (new) |
| `/parent-home` | unchanged |
| `/child` | unchanged |

Router redirect logic: if `userRoleProvider` returns non-null → skip welcome → go to role home (unchanged). If null → go to `/` (WelcomeScreen).

### Guest Upgrade Path

- Settings screen shows "Nâng cấp tài khoản" button for guest users
- Calls `FirebaseAuth.linkWithCredential(googleCredential)` — keeps same UID, all data preserved

---

## Feature 2: OS Geofencing

### Architecture

```
Parent device                    Firestore                    Child device
─────────────                    ─────────                    ────────────
MapSetupScreen
  add/remove zones  ──────────► users/{parentId}/zones ◄──── GeofenceService
                                                              loads zones on link

                                users/{parentId}/
                                  geofence_events  ◄───────── GeofenceService
                                                              writes on enter/exit

NotificationsProvider
  listens to stream ◄──────────  geofence_events
  fires local notif
```

### Zone Limits

- Maximum 3 zones per parent, enforced in:
  - UI: "+" button hidden/disabled when `zones.length >= 3`
  - `GeofenceZonesNotifier.addZone()`: throws if limit exceeded
  - Firestore security rules: reject write if zone count > 3

### GeofenceZoneModel (unchanged fields, new Firestore persistence)

```dart
// No field changes needed.
// zones are now persisted under users/{parentId}/zones/{id}
```

### GeofenceService (child-side, new file)

Responsibilities:
- Called after link confirmation on child device
- Loads parent's zones from `users/{parentId}/zones` (one-time + listen for changes)
- Registers each zone with `geofencing_api` (OS-level, no paid API)
- On `GeofenceStatus.exit` or `GeofenceStatus.enter` → writes `GeofenceEventModel` to Firestore
- Handles permission requests (always-on location required for background monitoring)

### GeofenceEventModel (new)

```dart
@freezed
class GeofenceEventModel with _$GeofenceEventModel {
  const factory GeofenceEventModel({
    required String id,
    required String zoneId,
    required String zoneName,
    required String childUid,
    required String status,   // 'enter' | 'exit'
    required DateTime timestamp,
  }) = _GeofenceEventModel;
  ...
}
```

### NotificationsProvider (parent-side, updated)

- Listens to `users/{parentId}/geofence_events` Firestore stream
- On new event with `status == 'exit'` → fires local notification via `flutter_local_notifications`
  - Title: "⚠️ [zoneName]"
  - Body: "[childName] vừa rời khỏi [zoneName]"
- On `enter` → fires softer notification: "[childName] đã vào [zoneName]"

**Limitation:** Local notifications require parent app to be running (foreground or background). If app is fully killed, the stream is inactive. Cloud Function push can be added later without redesign.

### MapSetupScreen Changes

- Save zones to Firestore on add/remove (currently in-memory only)
- Show parent's `linkCode` in a banner at top: "Mã liên kết của bạn: **ABC-123**"
- Enforce 3-zone limit in UI

### permissions

**iOS** (`Info.plist`):
- `NSLocationAlwaysAndWhenInUseUsageDescription`
- `NSLocationWhenInUseUsageDescription`

**Android** (`AndroidManifest.xml`):
- `ACCESS_FINE_LOCATION`
- `ACCESS_BACKGROUND_LOCATION`
- `RECEIVE_BOOT_COMPLETED` (restart geofence after reboot)

---

## Files Touched

| File | Action |
|---|---|
| `lib/features/auth/welcome_screen.dart` | **Create** |
| `lib/features/auth/guest_auth_service.dart` | **Create** |
| `lib/features/link/link_account_screen.dart` | **Create** |
| `lib/features/geofence/geofence_service.dart` | **Create** |
| `lib/models/user_model.dart` | **Modify** — add 4 fields |
| `lib/models/user_model.freezed.dart` | **Regenerate** |
| `lib/models/user_model.g.dart` | **Regenerate** |
| `lib/models/geofence_event_model.dart` | **Create** |
| `lib/providers/geofence_provider.dart` | **Modify** — limit 3, Firestore sync |
| `lib/providers/notifications_provider.dart` | **Modify** — Firestore stream + local notif |
| `lib/features/parent/map/map_setup_screen.dart` | **Modify** — persist zones, show linkCode |
| `lib/features/settings/settings_screen.dart` | **Modify** — upgrade account button for guests |
| `lib/core/router/app_router.dart` | **Modify** — `/` → WelcomeScreen, add `/link` |
| `ios/Runner/Info.plist` | **Modify** — location permission strings |
| `android/app/src/main/AndroidManifest.xml` | **Modify** — background location permission |

---

## Out of Scope

- Real-time map tracking (child's live dot on parent's map) — future feature
- Multiple children UI in parent home — future feature
- Cloud Function push when parent app is killed — future feature, addable without redesign
- Guest account expiry / cleanup — future feature
