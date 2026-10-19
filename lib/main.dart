import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'app.dart';
import 'core/notifications/local_notifications.dart';
import 'firebase_options.dart';

/// Global navigator key required by ZegoCloud to show incoming call UI
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalNotifications();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Zego Cloud only for mobile platforms (not web)
  if (!kIsWeb) {
    // 1. Register navigatorKey so Zego can navigate on incoming calls
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

    // 2. Register the system calling UI (CallKit on iOS, ConnectionService on Android)
    await ZegoUIKit().initLog().then((_) async {
      await ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
        ZegoUIKitSignalingPlugin(),
      ]);
    });
  }

  runApp(ProviderScope(child: KidsCareApp(navigatorKey: navigatorKey)));
}
