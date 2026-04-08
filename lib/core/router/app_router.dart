import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_care/features/auth/login_screen.dart';
import 'package:kids_care/features/auth/register_screen.dart';
import 'package:kids_care/features/auth/forgot_password_screen.dart';
import 'package:kids_care/features/auth/reset_password_screen.dart';
import 'package:kids_care/features/mode_selection/mode_selection_screen.dart';
import 'package:kids_care/features/child/home/child_home_screen.dart';
import 'package:kids_care/features/child/call/call_screen.dart';
import 'package:kids_care/features/parent/notifications/parent_notifications_screen.dart';
import 'package:kids_care/features/parent/map/map_setup_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      // ── Auth ─────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      // ── App ──────────────────────────────────────────
      GoRoute(
        path: '/',
        builder: (context, state) => const ModeSelectionScreen(),
      ),
      GoRoute(
        path: '/child',
        builder: (context, state) => const ChildHomeScreen(),
      ),
      GoRoute(
        path: '/call',
        builder: (context, state) => const CallScreen(),
      ),
      GoRoute(
        path: '/parent',
        builder: (context, state) => const ParentNotificationsScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapSetupScreen(),
      ),
    ],
  );
});
