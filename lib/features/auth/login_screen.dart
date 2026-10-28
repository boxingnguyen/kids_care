import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/features/auth/services/user_service.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';
import 'package:kids_care/l10n/l10n.dart';

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

  bool _isEmail(String input) => input.contains('@');

  Future<void> _login() async {
    final input = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (input.isEmpty || password.isEmpty) {
      _showError(context.l10n.fillAllFields);
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      // Email → parent, username → child (appended with @kidscare.app)
      final email = _isEmail(input) ? input : '$input@kidscare.app';

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!mounted) return;

      final userService = ref.read(userServiceProvider);
      final userData = await userService.getCurrentUserData();

      if (!mounted) return;

      if (userData == null) {
        // First-time login with no Firestore doc → register child
        context.go('/register-child');
      } else if (userData.role == 'parent') {
        context.go('/parent-home');
      } else {
        context.go('/child');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final msg = switch (e.code) {
        'user-not-found' => context.l10n.loginNotFound,
        'wrong-password' => context.l10n.loginWrongPassword,
        'invalid-credential' => context.l10n.loginInvalidCredential,
        _ => context.l10n.loginFailed('${e.message}'),
      };
      _showError(msg);
    } finally {
      if (mounted) ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        backgroundColor: AppTheme.dangerColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
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
            content: Text(context.l10n.googleLoginFailed('$e')),
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
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: AppBackButton(fallbackLocation: '/'),
                ),
                const SizedBox(height: 8),

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
                  context.l10n.appTitle,
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.loginTagline,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 44),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.helloWave,
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
                    context.l10n.loginSubtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
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
                        hint: context.l10n.loginIdentifierHint,
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        controller: _passwordCtrl,
                        hint: context.l10n.password,
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
                            context.l10n.forgotPasswordTitle,
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
                        label: context.l10n.login,
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
                      context.l10n.noAccount,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: Text(
                        context.l10n.register,
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
