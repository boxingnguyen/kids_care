import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_care/features/auth/forgot_password_screen.dart';
import 'package:kids_care/features/auth/welcome_screen.dart';
import 'package:kids_care/features/link/link_account_screen.dart';
import 'package:kids_care/features/auth/login_screen.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/register_child_screen.dart';
import 'package:kids_care/features/auth/register_screen.dart';
import 'package:kids_care/features/auth/reset_password_screen.dart';
import 'package:kids_care/features/child/call/call_screen.dart';
import 'package:kids_care/features/child/home/child_home_screen.dart';
import 'package:kids_care/features/parent/home/parent_home_screen.dart';
import 'package:kids_care/features/parent/map/map_setup_screen.dart';
import 'package:kids_care/features/parent/notifications/parent_notifications_screen.dart';
import 'package:kids_care/features/settings/settings_screen.dart';
import 'package:kids_care/features/todo/child/child_todo_screen.dart';
import 'package:kids_care/features/todo/parent/parent_todo_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Check if user is already logged in and route accordingly.
      // ref.read (không watch): invalidate currentUserProvider không được
      // dựng lại GoRouter — nếu không sẽ reset về '/' giữa luồng liên kết.
      final userRole = await ref.read(userRoleProvider.future);

      final isAuthRoute =
          state.matchedLocation == '/' ||
          state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot-password') ||
          state.matchedLocation.startsWith('/reset-password');

      // If user has a role, redirect to appropriate home screen
      if (userRole != null && isAuthRoute) {
        return userRole == 'parent' ? '/parent-home' : '/child';
      }

      return null;
    },
    routes: [
      // ── Auth ─────────────────────────────────────────
      GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
      GoRoute(
        path: '/link',
        builder: (context, state) => const LinkAccountScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/register-child',
        builder: (context, state) => const RegisterChildScreen(),
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
        path: '/child',
        builder: (context, state) => const ChildHomeScreen(),
      ),
      GoRoute(path: '/call', builder: (context, state) => const CallScreen()),
      GoRoute(
        path: '/parent-home',
        builder: (context, state) => const ParentHomeScreen(),
      ),
      GoRoute(
        path: '/parent',
        builder: (context, state) => const ParentNotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapSetupScreen(),
      ),
      // ── Todo ─────────────────────────────────────────
      GoRoute(
        path: '/parent-todo',
        builder: (context, state) => const ParentTodoScreen(),
      ),
      GoRoute(
        path: '/child-todo',
        builder: (context, state) => const ChildTodoScreen(),
      ),
    ],
  );
});
