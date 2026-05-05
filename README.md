# Kids Care 👧👦

**Kids Care** is a Flutter application designed to keep children safe and parents informed. It features real-time location tracking, geofencing, voice/video calling, and task management through separate interfaces for parents and children.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Configuration](#configuration)
- [Running the App](#running-the-app)
- [Testing](#testing)

---

## 🎯 Overview

Kids Care is a dual-interface Flutter application that:

- **Parents** can monitor their child's location, set safe zones, manage tasks, and receive notifications
- **Children** can share their location, receive tasks, make voice/video calls to parents, and navigate to safe zones

The app uses:

- **Firebase** for authentication, real-time database, and cloud messaging
- **Riverpod** for state management
- **Go Router** for navigation
- **Zego Cloud** for voice/video calling

---

## ✨ Features

### Parent Features

- 📍 **Real-time Location Tracking**: View child's current location on an interactive map
- 🛡️ **Geofencing**: Set safe zones (school, home, playground) and receive alerts when child leaves/enters
- 📞 **Voice/Video Calling**: Initiate calls with Zego Cloud integration
- 📋 **Task Management**: Assign and track daily tasks for children
- 🔔 **Notifications**: Receive alerts for location changes and task updates
- 👤 **Multi-child Support**: Manage multiple children (expandable)

### Child Features

- 📍 **Location Sharing**: Share location with parents in real-time
- 📞 **Emergency Calling**: Quick access to parent calls
- 📋 **Task Checklist**: View and complete assigned tasks
- 🛰️ **Background Tracking**: Location updates even when app is minimized
- 🎮 **Gamification**: Earn rewards for task completion (future feature)

---

## 🏗️ Architecture

### Design Pattern: Feature-First Clean Architecture

The app follows a **feature-based structure** where each feature is self-contained and isolated:

```
lib/
├── core/                    # Shared infrastructure
│   ├── constants/          # App-wide constants (Firestore collections, API keys)
│   ├── router/             # Navigation and route definitions
│   └── theme/              # Design system (colors, typography)
├── features/               # Feature modules
│   ├── auth/               # Authentication (login, registration)
│   ├── child/              # Child-mode features
│   ├── parent/             # Parent-mode features
│   └── todo/               # Task management
├── models/                 # Data models (Freezed classes)
├── providers/              # Global state providers
└── main.dart              # App entry point
```

### State Management: Riverpod

We use **Riverpod** for a compile-safe, testable state management solution:

- **`StateNotifierProvider`**: Mutable state (location updates, task lists)
- **`Provider`**: Computed/derived state (current user role, active geofences)
- **`FutureProvider`**: Async operations (fetching user data from Firestore)
- **Persistence**: User preferences stored in SharedPreferences through providers

### Data Layer: Freezed + JSON Serialization

All data models use **Freezed** for immutability and equality:

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String name,
    required String role,      // 'parent' or 'child'
    String? photoUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

### Navigation: Go Router

Path-based declarative navigation with automatic redirect logic:

```dart
/login              → LoginScreen
/register           → RegisterScreen
/parent-home        → ParentHomeScreen (after login)
/child              → ChildHomeScreen (after login)
/map                → MapSetupScreen
/call               → CallScreen
```

**Role-Based Redirect**: After login, users are automatically routed to the appropriate home screen based on their role stored in Firestore.

### Backend: Firebase

| Service             | Purpose                                               |
| ------------------- | ----------------------------------------------------- |
| **Auth**            | User login/registration with Google Sign-In support   |
| **Firestore**       | Real-time database for users, locations, zones, tasks |
| **Cloud Messaging** | Push notifications                                    |
| **Storage**         | User avatars and media                                |

**Firestore Collections**:

- `users/` — User profiles with role ('parent' or 'child')
- `location_events/` — Historical location data
- `geofence_zones/` — Safe zones (school, home, etc.)
- `tasks/` — Daily tasks for children

### Real-time Features

- **Location Tracking**: Uses `geolocator` + `geofence_service` for background location updates
- **Geofencing**: Automatically detects when child enters/exits zones using location distance calculations
- **Calling**: Integrated with Zego Cloud for peer-to-peer voice/video calls

---

## 📁 Project Structure

### Core Modules

**`lib/core/constants/app_constants.dart`**

- Firestore collection names
- SharedPreferences keys
- Default geofence coordinates (Ho Chi Minh City: 10.7769, 106.7009)
- API placeholders

**`lib/core/router/app_router.dart`**

- GoRouter configuration
- Redirect logic for authenticated/unauthenticated users
- Role-based navigation

**`lib/core/theme/app_theme.dart`**

- Material 3 design system
- Primary color: `#1392EC` (blue)
- Semantic colors: `schoolColor`, `playColor`, `dangerColor`
- Typography: Google Fonts (Nunito, Inter)

### Features

**`lib/features/auth/`**

- Login/Registration screens
- Password reset flows
- Auth service and user service
- Google Sign-In integration

**`lib/features/parent/`**

- `home/` — Parent dashboard
- `map/` — Geofence setup and visualization
- `notifications/` — Alert history

**`lib/features/child/`**

- `home/` — Child dashboard
- `call/` — Voice/video call interface

**`lib/features/todo/`**

- `parent/` — Task creation and management
- `child/` — Task completion interface

### Models

All data models are in `lib/models/`:

- `user_model.dart` — User profile (role: 'parent' or 'child')
- `location_event_model.dart` — Location coordinates with timestamp
- `geofence_zone_model.dart` — Safe zones with lat/lng/radius
- `todo_model.dart` — Task details and completion status

---

## 📋 Prerequisites

### System Requirements

- **Flutter SDK**: 3.11.1 or higher
- **Dart SDK**: Latest (comes with Flutter)
- **Android SDK**: API level 21+
- **iOS**: Deployment target 12.0+
- **macOS**: For iOS development

### Required Accounts

- **Firebase Project**: For backend services
- **Zego Cloud**: For voice/video calling
- **Google Sign-In**: OAuth credentials

### Tools

- Android Studio or Xcode (IDE)
- VS Code with Flutter extension (optional)
- Git

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/kids_care.git
cd kids_care
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Install iOS Pods (iOS only)

```bash
cd ios
pod install
pod repo update
cd ..
```

### 4. Generate Code

Build runner generates Freezed classes and Riverpod providers:

```bash
flutter pub run build_runner build
```

For continuous generation during development:

```bash
flutter pub run build_runner watch
```

### 5. Configure Firebase

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and iOS apps to your project
3. Download `google-services.json` (Android) and place in `android/app/`
4. Download `GoogleService-Info.plist` (iOS) and add to Xcode
5. Enable Authentication (Google Sign-In), Firestore, and Cloud Messaging services

### 6. Configure Zego Cloud

1. Sign up at [Zego Console](https://console.zegocloud.com/)
2. Create an app and note your `AppID`
3. Add to `lib/core/constants/app_constants.dart`:

```dart
const String ZEGO_APP_ID = 'YOUR_ZEGO_APP_ID';
```

### 7. Configure Google Maps (Optional)

1. Get an API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Enable Maps JavaScript API and Maps SDK for Android/iOS
3. Update in `lib/core/constants/app_constants.dart`:

```dart
const String GOOGLE_MAPS_API_KEY = 'YOUR_API_KEY';
```

---

## 💻 Development Workflow

### During Development: Watch Mode

Keep build_runner watching for changes:

```bash
flutter pub run build_runner watch
```

This automatically regenerates Freezed classes and Riverpod providers when you modify:

- `@freezed` classes
- `@riverpod` providers
- JSON serializable models

### Code Structure Standards

**Providers** (in each feature):

```dart
// Use StateNotifierProvider for mutable state
final todoListProvider = StateNotifierProvider<TodoListNotifier, List<TodoModel>>((ref) {
  return TodoListNotifier(ref.watch(userServiceProvider));
});

// Use Provider for derived state
final completedTasksProvider = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((task) => task.isCompleted).length;
});
```

**Models** (always use Freezed):

```dart
@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

**Services** (business logic):

```dart
class LocationService {
  Future<void> updateLocation(Location newLocation) async {
    await _firestore.collection('location_events').add(newLocation.toJson());
  }
}
```

### Imports Convention

```dart
// Within a feature: relative imports
import 'providers/todo_provider.dart';

// Core/shared: absolute imports
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/models/user_model.dart';
```

---

## ⚙️ Configuration

### `lib/core/constants/app_constants.dart`

Update these constants for your environment:

```dart
class AppConstants {
  // Firestore collections
  static const String USERS_COLLECTION = 'users';
  static const String LOCATION_EVENTS_COLLECTION = 'location_events';
  static const String GEOFENCE_ZONES_COLLECTION = 'geofence_zones';
  static const String TASKS_COLLECTION = 'tasks';

  // SharedPreferences keys
  static const String USER_MODE_KEY = 'user_mode'; // 'parent' or 'child'
  static const String CHILD_NAME_KEY = 'child_name';

  // Default geofence (Ho Chi Minh City)
  static const double DEFAULT_LAT = 10.7769;
  static const double DEFAULT_LNG = 106.7009;
  static const double DEFAULT_RADIUS = 500; // meters

  // APIs
  static const String ZEGO_APP_ID = 'mapsApiKeyPlaceholder';
  static const String GOOGLE_MAPS_API_KEY = 'mapsApiKeyPlaceholder';
}
```

### Permissions (`android/app/src/main/AndroidManifest.xml` & `ios/Runner/Info.plist`)

**Android permissions** needed:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

**iOS permissions** in `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to track safe zones</string>
<key>NSCameraUsageDescription</key>
<string>We need camera access for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for calls</string>
```

---

## 🎮 Running the App

### On Android Emulator

```bash
flutter run
```

Or specify a device:

```bash
flutter run -d emulator-5554
```

### On Android Device

```bash
flutter run -d <device-id>
```

List devices:

```bash
flutter devices
```

### On iOS Simulator

```bash
flutter run -d "iPhone 15"
```

### On iOS Device

1. Connect device to Mac
2. Trust the computer on device
3. Open `ios/Runner.xcworkspace` in Xcode
4. Select your device as target
5. Press Play or:

```bash
flutter run -d <device-id>
```

### Release Build

**Android**:

```bash
flutter build apk --release
# or AAB for Play Store:
flutter build appbundle --release
```

**iOS**:

```bash
flutter build ios --release
```

---

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/widget_test.dart
```

### Test Coverage

```bash
flutter test --coverage
# View coverage:
open coverage/index.html
```

### Widget Testing Pattern

Always wrap app in `ProviderScope`:

```dart
testWidgets('Parent login flows to parent home', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(child: KidsCareApp(navigatorKey: GlobalKey())),
  );

  // Test login flow
  expect(find.byType(LoginScreen), findsOneWidget);
});
```

---

## 📚 Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev/)
- [Firebase Docs](https://firebase.google.com/docs)
- [Go Router Docs](https://pub.dev/packages/go_router)
- [Freezed Guide](https://pub.dev/packages/freezed)
- [Zego Cloud Docs](https://docs.zegocloud.com/)

---

## 🔄 Development Cycle Example

### Adding a New Feature

1. **Create feature folder** under `lib/features/my_feature/`
2. **Create models** in `lib/models/` with `@freezed` annotation
3. **Create providers** in `lib/features/my_feature/providers/`
4. **Create UI screens** in `lib/features/my_feature/`
5. **Add routes** in `lib/core/router/app_router.dart`
6. **Run build_runner**: `flutter pub run build_runner build`
7. **Test**: `flutter test`

---

## 🐛 Troubleshooting

### Build Runner Issues

```bash
# Clean build cache
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build
```

### Firebase Initialization Error

- Check `google-services.json` is in `android/app/`
- Check `GoogleService-Info.plist` is added to Xcode (in Runner target)
- Ensure Firebase services are enabled in console

### Location Permission Issues

- Grant location permission on device settings
- For Android 12+, ensure you request approximate + precise location
- On iOS, check `Info.plist` has location descriptions

### Hot Reload Not Working

```bash
# Use hot restart instead
flutter run -d <device-id>
# Then press 'R' for hot reload or 'r' for full rebuild
```

---

## 📦 Dependencies Overview

| Package                                             | Purpose             |
| --------------------------------------------------- | ------------------- |
| `flutter_riverpod`                                  | State management    |
| `go_router`                                         | Navigation          |
| `firebase_core`, `cloud_firestore`, `firebase_auth` | Backend             |
| `freezed_annotation`                                | Data models         |
| `google_fonts`                                      | Typography          |
| `geolocator`                                        | Location services   |
| `zego_uikit`                                        | Voice/video calling |
| `permission_handler`                                | Runtime permissions |
| `shared_preferences`                                | Local persistence   |

---

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/my-feature`
2. Follow the architecture patterns described above
3. Run tests: `flutter test`
4. Run build_runner: `flutter pub run build_runner build`
5. Commit with clear messages
6. Push and create a pull request

---

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

---

## ✉️ Support

For questions or issues, please:

1. Check the [Troubleshooting](#troubleshooting) section
2. Review the [Flutter Documentation](https://flutter.dev/docs)
3. Open an issue on GitHub

---

**Happy Coding! 🚀**
# kids_care
