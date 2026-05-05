import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';

final registerChildLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final registerChildObscureProvider = StateProvider.autoDispose<bool>((ref) => true);
final registerChildConfirmObscureProvider = StateProvider.autoDispose<bool>((ref) => true);

class RegisterChildScreen extends ConsumerStatefulWidget {
  const RegisterChildScreen({super.key});

  @override
  ConsumerState<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends ConsumerState<RegisterChildScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _registerChild() async {
    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirmPassword = _confirmPasswordCtrl.text;

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    ref.read(registerChildLoadingProvider.notifier).state = true;

    try {
      // Logic for creating a child account
      // This is a placeholder for actual backend logic (e.g. creating a child profile under the parent)
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ref.read(registerChildLoadingProvider.notifier).state = false;
        context.go('/home'); // Go to parent home or where it's appropriate
      }
    } catch (e) {
      if (mounted) {
        ref.read(registerChildLoadingProvider.notifier).state = false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đã có lỗi xảy ra: $e')));
      }
    }
  }

  Widget _buildLabelField({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF8A93A6),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(registerChildLoadingProvider);
    final obscurePassword = ref.watch(registerChildObscureProvider);
    final obscureConfirmPassword = ref.watch(registerChildConfirmObscureProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3E0), Color(0xFFFFF8F0), Color(0xFFFFF3E0)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Avatar icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.face_rounded,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Tạo tài khoản cho con',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bắt đầu hành trình làm bạn cùng bé yêu',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),

                // Form card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabelField(
                        icon: Icons.person_outline_rounded,
                        label: 'TÊN ĐĂNG NHẬP',
                      ),
                      AuthTextField(
                        controller: _usernameCtrl,
                        hint: 'tên/ nickname của bé',
                      ),
                      const SizedBox(height: 20),

                      _buildLabelField(
                        icon: Icons.lock_outline_rounded,
                        label: 'MẬT KHẨU',
                      ),
                      AuthTextField(
                        controller: _passwordCtrl,
                        hint: '••••••••',
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppTheme.textHint,
                          ),
                          onPressed: () => ref
                              .read(registerChildObscureProvider.notifier)
                              .state = !obscurePassword,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildLabelField(
                        icon: Icons.verified_user_outlined,
                        label: 'XÁC NHẬN MẬT KHẨU',
                      ),
                      AuthTextField(
                        controller: _confirmPasswordCtrl,
                        hint: '••••••••',
                        obscureText: obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppTheme.textHint,
                          ),
                          onPressed: () => ref
                              .read(registerChildConfirmObscureProvider.notifier)
                              .state = !obscureConfirmPassword,
                        ),
                      ),
                      const SizedBox(height: 36),

                      PrimaryButton(
                        label: 'BẮT ĐẦU NGAY →',
                        isLoading: isLoading,
                        onPressed: _registerChild,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
