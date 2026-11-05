import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/session/session_effects.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/auth_service.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Chờ người dùng bấm link xác thực trong email. Tự kiểm tra định kỳ và khi
/// quay lại app; xác thực xong mới vào home.
///
/// Hai luồng:
///  - Đăng ký bằng email: xác thực xong → home.
///  - Khách gắn email ([then] = 'logout' khi mở từ đăng xuất): xác thực xong
///    → đánh dấu không còn là khách → đăng xuất (nếu đang đăng xuất) hoặc home.
class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String? then;

  const VerifyEmailScreen({super.key, this.then});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen>
    with WidgetsBindingObserver {
  static const _resendCooldown = 60;

  Timer? _pollTimer;
  Timer? _cooldownTimer;
  int _cooldown = _resendCooldown;
  bool _checking = false;
  bool _manualChecking = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) => _check());
    _startCooldown();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Người dùng vừa bấm link trong app email rồi quay lại.
    if (state == AppLifecycleState.resumed) _check();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = _resendCooldown);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _cooldown--);
      if (_cooldown <= 0) t.cancel();
    });
  }

  Future<void> _check({bool manual = false}) async {
    if (_checking || _done) return;
    _checking = true;
    if (manual) setState(() => _manualChecking = true);
    try {
      final verified = await ref
          .read(authServiceProvider)
          .reloadAndCheckVerified();
      if (verified) {
        await _onVerified();
      } else if (manual && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.verifyEmailNotYet)));
      }
    } catch (_) {
      // Lỗi mạng khi reload — lần kiểm tra sau sẽ thử lại.
    } finally {
      _checking = false;
      if (manual && mounted) setState(() => _manualChecking = false);
    }
  }

  Future<void> _onVerified() async {
    _done = true;
    _pollTimer?.cancel();
    final auth = ref.read(authServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    await auth.markEmailVerified();
    ref.invalidate(currentUserProvider);

    if (widget.then == 'logout') {
      await stopSessionBeforeSignOut(ref);
      await auth.signOut();
      ref.invalidate(currentUserProvider);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.emailLinkedLoggedOut)),
      );
      context.go('/login');
      return;
    }
    final home = await homeLocationFor(ref);
    if (mounted) context.go(home);
  }

  Future<void> _resend() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(authServiceProvider)
          .sendVerificationEmail(
            languageCode: Localizations.localeOf(context).languageCode,
          );
      _startCooldown();
      messenger.showSnackBar(SnackBar(content: Text(l10n.verifyEmailSent)));
    } on FirebaseAuthException catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            e.code == 'too-many-requests'
                ? l10n.tooManyRequests
                : l10n.errorWithMessage('${e.message}'),
          ),
        ),
      );
    }
  }

  /// Khách gắn email: huỷ gắn, trở lại tài khoản khách như cũ.
  /// Đăng ký email: đăng xuất về màn đăng nhập (đăng nhập lại sẽ quay lại đây).
  Future<void> _cancel() async {
    _pollTimer?.cancel();
    final auth = ref.read(authServiceProvider);
    final isGuest = (await ref.read(currentUserProvider.future))?.isGuest;
    if (isGuest == true) {
      await auth.cancelEmailLink();
      if (!mounted) return;
      if (widget.then == 'logout') {
        context.go('/settings');
      } else {
        context.go(await homeLocationFor(ref));
      }
      return;
    }
    await auth.signOut();
    ref.invalidate(currentUserProvider);
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Center(child: Text('📬', style: TextStyle(fontSize: 72))),
                const SizedBox(height: 16),
                Text(
                  l10n.verifyEmailTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.verifyEmailMessage(email),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: l10n.verifyEmailCheck,
                  isLoading: _manualChecking,
                  onPressed: () => _check(manual: true),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: _cooldown > 0
                      ? l10n.verifyEmailResendIn(_cooldown)
                      : l10n.verifyEmailResend,
                  outlined: true,
                  onPressed: _cooldown > 0 ? null : _resend,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _cancel,
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                  ),
                  child: Text(l10n.cancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
