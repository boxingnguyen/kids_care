import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
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
import 'package:kids_care/l10n/l10n.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => const _NotFoundScreen(),
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

/// Màn hình khi đường dẫn không tồn tại — luôn có lối về trang chủ.
class _NotFoundScreen extends ConsumerWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppTopBar(title: context.l10n.notFoundTitle),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🧭', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                context.l10n.notFoundMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final home = await homeLocationFor(ref);
                  if (context.mounted) context.go(home);
                },
                icon: const Icon(Icons.home_rounded),
                label: Text(context.l10n.goHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
