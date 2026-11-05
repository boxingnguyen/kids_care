import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/core/widgets/app_tab_shell.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/features/auth/forgot_password_screen.dart';
import 'package:kids_care/features/auth/link_email_screen.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/features/auth/verify_email_screen.dart';
import 'package:kids_care/features/auth/welcome_screen.dart';
import 'package:kids_care/features/link/link_account_screen.dart';
import 'package:kids_care/features/notes/child_notes_screen.dart';
import 'package:kids_care/features/notes/parent_notes_screen.dart';
import 'package:kids_care/features/auth/login_screen.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/register_child_screen.dart';
import 'package:kids_care/features/auth/register_screen.dart';
import 'package:kids_care/features/auth/reset_password_screen.dart';
import 'package:kids_care/features/child/call/call_screen.dart';
import 'package:kids_care/features/child/home/child_home_screen.dart';
import 'package:kids_care/features/parent/home/parent_home_screen.dart';
import 'package:kids_care/features/parent/map/map_setup_screen.dart';
import 'package:kids_care/features/settings/settings_screen.dart';
import 'package:kids_care/features/todo/child/child_todo_screen.dart';
import 'package:kids_care/features/todo/parent/parent_todo_screen.dart';
import 'package:kids_care/l10n/l10n.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => const _NotFoundScreen(),
    redirect: (context, state) async {
      // Email thật chưa xác thực → bắt buộc qua màn xác thực trước khi vào app
      // (kể cả khi tắt app rồi mở lại giữa chừng).
      if (AuthService.needsEmailVerification(
        FirebaseAuth.instance.currentUser,
      )) {
        return state.matchedLocation == '/verify-email'
            ? null
            : '/verify-email';
      }

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
        path: '/link-email',
        builder: (context, state) =>
            LinkEmailScreen(then: state.uri.queryParameters['then']),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) =>
            VerifyEmailScreen(then: state.uri.queryParameters['then']),
      ),
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
      // Bố/mẹ: Trang chủ (thông báo) · Bản đồ · Giao việc · Việc cần làm
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            AppTabShell(navigationShell: shell, isParent: true),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/parent-home',
                builder: (context, state) => const ParentHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/parent-map',
                builder: (context, state) => const MapSetupScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/parent-todo',
                builder: (context, state) => const ParentTodoScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/parent-notes',
                builder: (context, state) => const ParentNotesScreen(),
              ),
            ],
          ),
        ],
      ),
      // Bé: Trang chủ · Việc cần làm · Lời nhắn gửi
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            AppTabShell(navigationShell: shell, isParent: false),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/child',
                builder: (context, state) => const ChildHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/child-todo',
                builder: (context, state) => const ChildTodoScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/child-notes',
                builder: (context, state) => const ChildNotesScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/call', builder: (context, state) => const CallScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // Đường dẫn cũ — trang thông báo nay là trang chủ của bố/mẹ.
      GoRoute(path: '/parent', redirect: (context, state) => '/parent-home'),
      GoRoute(
        path: '/map',
        // Bé không còn tab bản đồ.
        redirect: (context, state) async =>
            await ref.read(userRoleProvider.future) == 'parent'
            ? '/parent-map'
            : '/child',
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
