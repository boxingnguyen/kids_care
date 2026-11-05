import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Gắn email + mật khẩu vào tài khoản khách (giữ nguyên UID và dữ liệu),
/// rồi sang màn xác thực email. [then] = 'logout' khi mở từ luồng đăng xuất.
class LinkEmailScreen extends ConsumerStatefulWidget {
  final String? then;

  const LinkEmailScreen({super.key, this.then});

  @override
  ConsumerState<LinkEmailScreen> createState() => _LinkEmailScreenState();
}

class _LinkEmailScreenState extends ConsumerState<LinkEmailScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.dangerColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _showError(l10n.fillAllFields);
      return;
    }
    if (password.length < 6) {
      _showError(l10n.passwordTooShort);
      return;
    }
    if (password != _confirmCtrl.text) {
      _showError(l10n.passwordConfirmMismatch);
      return;
    }

    setState(() => _loading = true);
    try {
      await ref
          .read(authServiceProvider)
          .linkGuestWithEmail(
            email,
            password,
            languageCode: Localizations.localeOf(context).languageCode,
          );
      if (!mounted) return;
      final query = widget.then == null ? '' : '?then=${widget.then}';
      context.go('/verify-email$query');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _showError(switch (e.code) {
        'email-already-in-use' ||
        'credential-already-in-use' => l10n.emailTaken,
        'invalid-email' => l10n.invalidEmail,
        'weak-password' => l10n.passwordTooShort,
        'too-many-requests' => l10n.tooManyRequests,
        _ => l10n.errorWithMessage('${e.message}'),
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: const Center(
          child: AppBackButton(fallbackLocation: '/settings'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                l10n.linkEmailTitle,
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.linkEmailSubtitle,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
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
                      hint: l10n.email,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _passwordCtrl,
                      hint: l10n.password,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppTheme.textHint,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 14),
                    AuthTextField(
                      controller: _confirmCtrl,
                      hint: l10n.confirmPasswordHint,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscure,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: l10n.linkEmailAction,
                      isLoading: _loading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
