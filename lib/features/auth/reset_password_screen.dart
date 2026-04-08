import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';

final resetLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final resetSuccessProvider = StateProvider.autoDispose<bool>((ref) => false);
final resetObscurePwProvider = StateProvider.autoDispose<bool>((ref) => true);
final resetObscureConfirmProvider = StateProvider.autoDispose<bool>((ref) => true);
final resetPasswordTextProvider = StateProvider.autoDispose<String>((ref) => '');

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(() {
      ref.read(resetPasswordTextProvider.notifier).state = _passwordCtrl.text;
    });
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  /// 0-4 strength based on character types present
  int _passwordStrength(String pw) {
    if (pw.isEmpty) return 0;
    int score = 0;
    if (pw.length >= 8) score++;
    if (pw.contains(RegExp(r'[A-Z]'))) score++;
    if (pw.contains(RegExp(r'[0-9]'))) score++;
    if (pw.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    return score;
  }

  Color _strengthColor(int level) {
    if (level <= 1) return AppTheme.dangerColor;
    if (level == 2) return AppTheme.primaryColor;
    if (level == 3) return const Color(0xFFFBBF24); // amber
    return AppTheme.playColor; // green
  }

  String _strengthLabel(int level) {
    if (level <= 1) return 'Yếu';
    if (level == 2) return 'Trung bình';
    if (level == 3) return 'Tốt';
    return 'Mạnh';
  }

  Future<void> _resetPassword() async {
    if (_passwordCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Mật khẩu không khớp'),
          backgroundColor: AppTheme.dangerColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    ref.read(resetLoadingProvider.notifier).state = true;
    await Future.delayed(const Duration(seconds: 1)); // TODO: real auth
    if (mounted) {
      ref.read(resetLoadingProvider.notifier).state = false;
      ref.read(resetSuccessProvider.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordText = ref.watch(resetPasswordTextProvider);
    final strength = _passwordStrength(passwordText);
    final obscurePw = ref.watch(resetObscurePwProvider);
    final obscureConfirm = ref.watch(resetObscureConfirmProvider);
    final isLoading = ref.watch(resetLoadingProvider);
    final success = ref.watch(resetSuccessProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3E0), Color(0xFFFFF8F0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Illustration
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 44,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppTheme.playColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  'Đặt mật khẩu mới',
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mật khẩu mới phải khác mật khẩu trước đó',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 36),

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthTextField(
                        controller: _passwordCtrl,
                        hint: 'Mật khẩu mới',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: obscurePw,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePw
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppTheme.textHint,
                          ),
                          onPressed: () =>
                              ref.read(resetObscurePwProvider.notifier).state = !obscurePw,
                        ),
                      ),

                      if (passwordText.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        // Strength bar
                        Row(
                          children: List.generate(4, (i) {
                            final filled = i < strength;
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                                height: 4,
                                decoration: BoxDecoration(
                                  color: filled
                                      ? _strengthColor(strength)
                                      : AppTheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Độ mạnh: ${_strengthLabel(strength)}',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: _strengthColor(strength),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _confirmCtrl,
                        hint: 'Xác nhận mật khẩu mới',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: obscureConfirm,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppTheme.textHint,
                          ),
                          onPressed: () =>
                              ref.read(resetObscureConfirmProvider.notifier).state = !obscureConfirm,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Rules
                      _PasswordRule(
                        label: 'Ít nhất 8 ký tự',
                        satisfied: passwordText.length >= 8,
                      ),
                      const SizedBox(height: 6),
                      _PasswordRule(
                        label: 'Có chữ hoa',
                        satisfied: passwordText.contains(RegExp(r'[A-Z]')),
                      ),
                      const SizedBox(height: 6),
                      _PasswordRule(
                        label: 'Có số',
                        satisfied: passwordText.contains(RegExp(r'[0-9]')),
                      ),

                      const SizedBox(height: 28),
                      PrimaryButton(
                        label: 'Đặt lại mật khẩu',
                        isLoading: isLoading,
                        onPressed: _resetPassword,
                      ),
                    ],
                  ),
                ),

                // Success overlay
                if (success) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppTheme.playColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.playColor.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 56,
                          color: AppTheme.playColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Đặt lại thành công!',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mật khẩu đã được thay đổi. Đăng nhập để lướt cùng Kids Care!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            onPressed: () => context.go('/login'),
                            child: Text(
                              'Đăng nhập ngay',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordRule extends StatelessWidget {
  final String label;
  final bool satisfied;

  const _PasswordRule({required this.label, required this.satisfied});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          satisfied
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 18,
          color: satisfied ? AppTheme.playColor : AppTheme.textHint,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: satisfied ? AppTheme.textPrimary : AppTheme.textHint,
          ),
        ),
      ],
    );
  }
}
