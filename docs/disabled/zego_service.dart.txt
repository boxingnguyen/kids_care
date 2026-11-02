import 'package:flutter/foundation.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../core/constants/app_constants.dart';

/// ZegoService handles initializing and terminating the ZegoCloud call service.
/// Call [init] when the user enters the app (Child or Parent mode).
/// Call [uninit] when the user logs out or switches mode.
class ZegoService {
  ZegoService._();
  static final ZegoService instance = ZegoService._();

  bool _initialized = false;

  /// Initialize Zego call invitation service.
  /// [userId] - Unique ID of the current user (child or parent)
  /// [userName] - Display name shown to the other party
  Future<void> init({required String userId, required String userName}) async {
    if (_initialized) {
      debugPrint('[ZegoService] Already initialized, skipping.');
      return;
    }

    if (AppConstants.zegoAppId == 0 || AppConstants.zegoAppSign.isEmpty) {
      debugPrint(
        '[ZegoService] ⚠️  ZegoCloud credentials not configured! '
        'Please set zegoAppId and zegoAppSign in AppConstants.',
      );
      return;
    }

    // await ZegoUIKitPrebuiltCallInvitationService().init(
    //   appID: AppConstants.zegoAppId,
    //   appSign: AppConstants.zegoAppSign,
    //   userID: userId,
    //   userName: userName,
    //   plugins: [ZegoUIKitSignalingPlugin()],
    //   // Optional: notification config for offline calls
    //   // notificationConfig: ZegoCallInvitationNotificationConfig(
    //   //   androidNotificationConfig: ZegoAndroidNotificationConfig(
    //   //     channelID: 'kids_care_calls',
    //   //     channelName: 'Kids Care Calls',
    //   //   ),
    //   // ),
    // );

    _initialized = true;
    debugPrint('[ZegoService] ✅ Initialized for user: $userName ($userId)');
  }

  /// Deinitialize Zego service (call on logout or mode switch)
  Future<void> uninit() async {
    if (!_initialized) return;
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    _initialized = false;
    debugPrint('[ZegoService] 🛑 Deinitialized.');
  }
}
