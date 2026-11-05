import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';
import 'package:kids_care/l10n/l10n.dart';

final registerLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final registerObscureProvider = StateProvider.autoDispose<bool>((ref) => true);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.fillAllFields)));
      return;
    }

    ref.read(registerLoadingProvider.notifier).state = true;

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await ref
            .read(guestAuthServiceProvider)
            .createProfile(
              uid: userCredential.user!.uid,
              name: name,
              nameSet: true,
              email: email,
              role: 'parent',
            );
        if (!mounted) return;
        await ref
            .read(authServiceProvider)
            .sendVerificationEmail(
              languageCode: Localizations.localeOf(context).languageCode,
            );
      }

      if (mounted) {
        ref.read(registerLoadingProvider.notifier).state = false;
        // Xác thực email xong mới vào home (router cũng chặn nếu bỏ qua).
        context.go('/verify-email');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ref.read(registerLoadingProvider.notifier).state = false;

        var msgErrAlreadyUsed = e.code == 'email-already-in-use'
            ? context.l10n.emailTaken
            : null;
        log('${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msgErrAlreadyUsed ?? context.l10n.signUpFailed),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ref.read(registerLoadingProvider.notifier).state = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errorGeneric('$e'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(registerLoadingProvider);
    final obscurePassword = ref.watch(registerObscureProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: const Center(child: AppBackButton(fallbackLocation: '/login')),
      ),
      extendBodyBehindAppBar: true,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Text(
                  context.l10n.createNewAccount,
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  context.l10n.registerSubtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),

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
                        controller: _nameCtrl,
                        hint: context.l10n.parentFullName,
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 14),
                      AuthTextField(
                        controller: _emailCtrl,
                        hint: context.l10n.email,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
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
                              ref.read(registerObscureProvider.notifier).state =
                                  !obscurePassword,
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: context.l10n.register,
                        isLoading: isLoading,
                        onPressed: _register,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.haveAccount,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/login'),
                      child: Text(
                        context.l10n.login,
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
