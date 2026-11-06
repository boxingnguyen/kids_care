// App Store screenshot harness — NOT shipped. Runs the real screens with
// invented demo data (Riverpod overrides), no Firestore reads/writes, no
// notification/geofencing side effects.
//
// Build:  flutter build ios --simulator --debug -t tool/screenshots/screenshot_main.dart \
//           --dart-define-from-file=config/env.json
// Launch: write <app data container>/tmp/shot_screen.txt (see capture.sh), then launch.
// See tool/screenshots/capture.sh.
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/core/router/app_router.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/location/live_location_service.dart';
import 'package:kids_care/features/location/location_consent.dart';
import 'package:kids_care/features/location/location_providers.dart';
import 'package:kids_care/features/notes/notes_provider.dart';
import 'package:kids_care/features/todo/providers/todo_provider.dart';
import 'package:kids_care/firebase_options.dart';
import 'package:kids_care/l10n/app_localizations.dart';
import 'package:kids_care/l10n/locale_provider.dart';
import 'package:kids_care/models/child_status.dart';
import 'package:kids_care/models/geofence_event_model.dart';
import 'package:kids_care/models/geofence_zone_model.dart';
import 'package:kids_care/models/todo_model.dart';
import 'package:kids_care/models/user_model.dart';
import 'package:kids_care/providers/geofence_provider.dart';
import 'package:kids_care/providers/notifications_provider.dart';
import 'package:kids_care/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Demo cast ──────────────────────────────────────────────────────────────
const _parent = UserModel(
  uid: 'p1',
  name: 'Anna',
  nameSet: true,
  role: 'parent',
  email: 'anna@example.com',
  linkCode: 'KDS-482',
  linkedChildIds: ['c1', 'c2'],
);
const _lily = UserModel(
  uid: 'c1',
  name: 'Lily',
  nameSet: true,
  role: 'child',
  linkCode: 'LIL-731',
  linkedParentIds: ['p1'],
);
const _max = UserModel(
  uid: 'c2',
  name: 'Max',
  nameSet: true,
  role: 'child',
  linkCode: 'MAX-205',
  linkedParentIds: ['p1'],
);

// Ho Chi Minh City, District 1 (matches the map's default centre). Phones
// show a much shorter map, so the zones sit closer together there.
final _tablet = () {
  final v = WidgetsBinding.instance.platformDispatcher.views.first;
  return v.physicalSize.shortestSide / v.devicePixelRatio >= 600;
}();
final _home = _tablet ? (10.7814, 106.6968) : (10.7779, 106.6985);
final _school = _tablet ? (10.7744, 106.7040) : (10.7766, 106.7024);
final _park = _tablet ? (10.7738, 106.6950) : (10.7763, 106.6964);

final _today = DateTime.now();
DateTime _at(int h, int m) => DateTime(_today.year, _today.month, _today.day, h, m);

final _zones = [
  GeofenceZoneModel(id: 'z1', name: 'Home', lat: _home.$1, lng: _home.$2, emoji: '🏠'),
  GeofenceZoneModel(id: 'z2', name: 'School', lat: _school.$1, lng: _school.$2, emoji: '🏫'),
  GeofenceZoneModel(id: 'z3', name: 'Park', lat: _park.$1, lng: _park.$2, emoji: '🌳'),
];

final _events = [
  GeofenceEventModel(id: 'e1', zoneId: 'z2', zoneName: 'School', childUid: 'c1', childName: 'Lily', status: 'enter', timestamp: _at(9, 32)),
  GeofenceEventModel(id: 'e2', type: ChildEventType.shareStarted, childUid: 'c1', childName: 'Lily', timestamp: _at(9, 18)),
  GeofenceEventModel(id: 'e3', type: ChildEventType.todoDone, zoneName: 'Pack school bag', childUid: 'c1', childName: 'Lily', timestamp: _at(9, 5)),
  GeofenceEventModel(id: 'e4', type: ChildEventType.status, status: 'school', childUid: 'c2', childName: 'Max', timestamp: _at(8, 47)),
  GeofenceEventModel(id: 'e5', zoneId: 'z1', zoneName: 'Home', childUid: 'c2', childName: 'Max', status: 'exit', timestamp: _at(8, 41)),
  GeofenceEventModel(id: 'e6', type: ChildEventType.noteCreated, zoneName: 'Please buy colored pencils', childUid: 'c1', childName: 'Lily', timestamp: _at(7, 55)),
];

TodoModel _todo(String id, String emoji, String title, {String child = 'c1', bool done = false, String desc = '', DateTime? due, DateTime? doneAt}) =>
    TodoModel(
      id: id,
      title: title,
      emoji: emoji,
      description: desc,
      assignedChildId: child,
      createdBy: 'p1',
      isCompleted: done,
      dueDate: due,
      completedAt: doneAt,
      createdAt: _at(7, 0),
    );

final _lilyTodos = [
  _todo('t1', '📚', 'Finish math homework', desc: 'Pages 12–13', due: _at(18, 0)),
  _todo('t2', '🎹', 'Piano practice — 20 min', due: _at(19, 0)),
  _todo('t3', '🪴', 'Water the plants'),
  _todo('t4', '🎒', 'Pack school bag', done: true, doneAt: _at(9, 5)),
  _todo('t5', '🦷', 'Brush teeth', done: true, doneAt: _at(7, 20)),
];
final _maxTodos = [
  _todo('t6', '⚽', 'Football kit in the wash', child: 'c2'),
  _todo('t7', '📖', 'Read for 15 minutes', child: 'c2', done: true, doneAt: _at(8, 10)),
];

final _notes = [
  ParentNote(id: 'n1', childId: 'c1', title: 'Please buy colored pencils', emoji: '🖍️', createdAt: _at(7, 55)),
  ParentNote(id: 'n2', childId: 'c1', title: 'Pick me up at 4:30 today', emoji: '🚗', createdAt: _at(7, 40)),
  ParentNote(id: 'n3', childId: 'c1', title: 'Can we bake cookies on Saturday?', emoji: '🍪', createdAt: _at(7, 30), isCompleted: true, completedAt: _at(8, 0), completedBy: 'p1', completedByName: 'Anna'),
];

// ── Fakes for StateNotifiers that would otherwise hit Firestore ────────────
class _FakeZones extends GeofenceZonesNotifier {
  _FakeZones() {
    state = _zones;
  }
  @override
  void watchZones(String childId, {bool monitor = false}) => state = _zones;
  @override
  void stopWatching() {}
}

class _FakeNotifications extends NotificationsNotifier {
  _FakeNotifications() {
    state = _events;
  }
  @override
  void startListening(String parentId) {}
  @override
  void stopListening() {}
}

class _FakeLiveShare extends LiveShareNotifier {
  _FakeLiveShare(DateTime? until) {
    state = until;
  }
  @override
  Future<void> start(UserModel child) async {}
  @override
  Future<void> resumeIfNeeded(String childUid) async {}
  @override
  Future<void> stop({UserModel? child, bool notify = true}) async {}
}

class _FakeStatus extends ChildStatusNotifier {
  _FakeStatus(ChildStatusType s) {
    state = s;
  }
}

// ── Screens ────────────────────────────────────────────────────────────────
/// screen id → (signed-in user or null, route)
const _screens = <String, (UserModel?, String)>{
  'welcome': (null, '/'),
  'parent-home': (_parent, '/parent-home'),
  'parent-map': (_parent, '/parent-map'),
  'parent-todo': (_parent, '/parent-todo'),
  'parent-notes': (_parent, '/parent-notes'),
  'child-home': (_lily, '/child'),
  'child-todo': (_lily, '/child-todo'),
  'child-notes': (_lily, '/child-notes'),
};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Some code paths read FirebaseAuth.instance directly (router redirect).
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // capture.sh writes the screen id to <app data container>/tmp/shot_screen.txt
  // (Directory.systemTemp = the container's tmp/ on iOS).
  final prefs = await SharedPreferences.getInstance();
  final shotFile = File('${Directory.systemTemp.path}/shot_screen.txt');
  final screen = shotFile.existsSync()
      ? shotFile.readAsStringSync().trim()
      : const String.fromEnvironment('SCREEN', defaultValue: 'parent-home');
  debugPrint('SHOT screen=$screen tmp=${Directory.systemTemp.path}');
  final (user, route) = _screens[screen] ?? _screens['parent-home']!;

  // ChildNameNotifier loads from prefs on creation.
  await prefs.setString(AppConstants.prefChildName, 'Lily');

  final now = DateTime.now();
  final liveUntil = now.add(const Duration(minutes: 42));

  final container = ProviderContainer(
    overrides: [
      authUidProvider.overrideWith((ref) => Stream.value(user?.uid)),
      currentUserProvider.overrideWith((ref) => Stream.value(user)),
      userRoleProvider.overrideWith((ref) async => user?.role),
      linkedChildrenProvider.overrideWith((ref) => Stream.value(const [_lily, _max])),
      linkedParentsProvider.overrideWith((ref) async => const [_parent]),
      incomingLinkRequestsProvider.overrideWith((ref) => Stream.value(const [])),
      outgoingLinkRequestsProvider.overrideWith((ref) => Stream.value(const [])),
      childLocationProvider.overrideWith(
        (ref, id) => Stream.value(
          id == 'c1'
              ? ChildLocation(
                  lat: _school.$1 - 0.0004,
                  lng: _school.$2 - 0.0008,
                  accuracy: 12,
                  updatedAt: now.subtract(const Duration(seconds: 40)),
                  sharingUntil: liveUntil,
                )
              : ChildLocation(lat: _school.$1, lng: _school.$2, updatedAt: _at(8, 52)),
        ),
      ),
      myLocationRequestProvider.overrideWith((ref, id) => Stream.value(null)),
      incomingLocationRequestsProvider.overrideWith((ref) => Stream.value(const [])),
      childTodosStreamProvider.overrideWith((ref) => Stream.value(_lilyTodos)),
      parentTodosStreamProvider.overrideWith((ref) => Stream.value([..._lilyTodos, ..._maxTodos])),
      childNotesProvider.overrideWith((ref) => Stream.value(_notes)),
      parentNotesProvider.overrideWith((ref) => Stream.value(_notes)),
      geofenceZonesProvider.overrideWith((ref) => _FakeZones()),
      notificationsProvider.overrideWith((ref) => _FakeNotifications()),
      liveShareProvider.overrideWith(
        (ref) => _FakeLiveShare(null),
      ),
      childStatusProvider.overrideWith((ref) => _FakeStatus(ChildStatusType.school)),
      needsLocationDisclosureProvider.overrideWithValue(false),
    ],
  );

  runApp(UncontrolledProviderScope(container: container, child: const _ShotApp()));

  if (route != '/') {
    // Let the '/' redirect settle, then jump to the target tab.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    container.read(appRouterProvider).go(route);
  }
}

/// KidsCareApp without SessionEffects (no geofencing / live-share side effects).
class _ShotApp extends ConsumerWidget {
  const _ShotApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final chosenLocale = ref.watch(localeProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: chosenLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (deviceLocales, _) => resolveLocale(deviceLocales),
    );
  }
}
