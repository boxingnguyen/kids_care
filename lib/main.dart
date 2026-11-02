import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/notifications/local_notifications.dart';
import 'firebase_options.dart';

/// Global navigator key (also needed by ZegoCloud when calling is re-enabled)
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalNotifications();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Calling (ZegoCloud) disabled for first release — see docs/disabled/.

  runApp(ProviderScope(child: KidsCareApp(navigatorKey: navigatorKey)));
}
