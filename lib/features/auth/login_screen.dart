import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/features/auth/services/user_service.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';

final loginLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final loginObscureProvider = StateProvider.autoDispose<bool>((ref) => true);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    ref.read(loginLoadingProvider.notifier).state = true;
    await Future.delayed(const Duration(seconds: 1)); // TODO: Email login

    if (mounted) {
      ref.read(loginLoadingProvider.notifier).state = false;

      // Check user role and route accordingly
      final userService = ref.read(userServiceProvider);
      final userData = await userService.getCurrentUserData();

      if (userData != null) {
        if (userData.role == 'parent') {
          context.go('/parent-home');
        } else {
          context.go('/child');
        }
      } else {
        // New user - go to child registration
        context.go('/register-child');
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    ref.read(googleSignInLoadingProvider.notifier).state = true;
    try {
      final userCred = await ref.read(authServiceProvider).signInWithGoogle();
      if (mounted && userCred != null) {
        // Check if user already has a role
        final userService = ref.read(userServiceProvider);
        final userData = await userService.getCurrentUserData();

        if (userData != null) {
          // User already registered, route by role
          if (userData.role == 'parent') {
            context.go('/parent-home');
          } else {
            context.go('/child');
          }
        } else {
          // New user - go to child registration
          context.go('/register-child');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập Google thất bại: $e'),
            backgroundColor: AppTheme.dangerColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        ref.read(googleSignInLoadingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final obscurePassword = ref.watch(loginObscureProvider);
    final isLoading = ref.watch(loginLoadingProvider);

    final googleIsLoading = ref.watch(googleSignInLoadingProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF3E0), Color(0xFFFFF8F0), Color(0xFFFFF3E0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 48),

                // Kite & String logo
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.child_care_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Kids Care',
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'An toàn cho trẻ, bình yên cho bố mẹ',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 44),

                // "Chào mừng ba mẹ!" – the Kite & String signature
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chào mừng ba mẹ! 👋',
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bắt đầu hành trình nuôi dưỡng con yêu',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Form card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AuthTextField(
                        controller: _emailCtrl,
                        hint: 'Email hoặc số điện thoại',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        controller: _passwordCtrl,
                        hint: 'Mật khẩu',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppTheme.textHint,
                          ),
                          onPressed: () =>
                              ref.read(loginObscureProvider.notifier).state =
                                  !obscurePassword,
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push('/forgot-password'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Quên mật khẩu?',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      PrimaryButton(
                        label: 'Đăng nhập',
                        isLoading: isLoading,
                        onPressed: _login,
                      ),
                      const SizedBox(height: 20),
                      // TODO: Add Social media sign in later
                      // Row(
                      //   children: [
                      //     Expanded(child: Divider(color: Colors.grey.shade200)),
                      //     Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 12),
                      //       child: Text(
                      //         'hoặc',
                      //         style: GoogleFonts.nunito(
                      //           fontSize: 13,
                      //           color: AppTheme.textHint,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(child: Divider(color: Colors.grey.shade200)),
                      //   ],
                      // ),
                      // const SizedBox(height: 16),

                      // SocialButton(
                      //   label: 'Sign in with Google',
                      //   iconPath: 'assets/icons/google_logo.png',
                      //   isLoading: googleIsLoading,
                      //   onPressed: _signInWithGoogle,
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chưa có tài khoản? ',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: Text(
                        'Đăng ký',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
