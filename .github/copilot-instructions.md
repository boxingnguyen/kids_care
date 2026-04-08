# Kids Care - AI Coding Guidelines

## Architecture Overview
- **Feature-based structure**: Code organized under `lib/features/` with child/parent modes
- **State management**: Riverpod with `StateNotifier` for mutable state, `Provider` for computed values
- **Data models**: Freezed classes with JSON serialization (run `flutter pub run build_runner build` after changes)
- **Navigation**: Go Router with simple path-based routes (e.g., `/child`, `/parent`, `/map`)

## Key Patterns
- **Providers**: Use `StateNotifierProvider` for stateful logic, e.g., `userModeProvider` persists mode in SharedPreferences
- **Models**: All data classes use Freezed with `@freezed` annotation and `.freezed.dart`/`.g.dart` parts
- **Theming**: Custom colors in `AppTheme` (primary: #1392EC), Google Fonts Inter, Material 3
- **Localization**: Vietnamese text throughout UI (e.g., "Nhà" for home, "Trường học" for school)

## Development Workflow
- **Code generation**: Run `flutter pub run build_runner watch` during development for Freezed/Riverpod auto-generation
- **Firebase setup**: Uncomment Firebase init in `main.dart` after adding `google-services.json`
- **Google Maps**: Replace `mapsApiKeyPlaceholder` in `AppConstants` with real API key
- **Geofencing**: Default zones centered on Ho Chi Minh City (10.7769, 106.7009)

## Conventions
- **Imports**: Relative imports within features, absolute for core/models/providers
- **Constants**: All magic strings/numbers in `AppConstants` (Firestore collections, SharedPreferences keys)
- **Colors**: Semantic color names (schoolColor, playColor, dangerColor) for status indicators
- **Persistence**: User mode and child name stored in SharedPreferences via providers

## External Dependencies
- **Firebase**: Auth, Firestore (`users`, `location_events`, `geofence_zones`), FCM messaging
- **Maps**: Google Maps Flutter with circles for geofence visualization
- **Location**: Geolocator + geofence_service for background monitoring
- **Permissions**: permission_handler for location/camera/microphone access

## Testing
- Wrap app in `ProviderScope` for widget tests
- Basic smoke test exists but needs updating for actual app functionality</content>
<parameter name="filePath">/Users/boxing/projects/vibe_coding/kids_care/.github/copilot-instructions.md