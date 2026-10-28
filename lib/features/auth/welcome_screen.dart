import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/widgets/kids_care_logo.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';
import 'package:kids_care/l10n/l10n.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  /// Role đang được tạo ('parent' | 'child'), null khi rảnh.
  String? _loadingRole;

  @override
  Widget build(BuildContext context) {
    final loading = _loadingRole;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(child: KidsCareLogo()),
              const SizedBox(height: 16),
              Text(
                context.l10n.appTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryColor,
                ),
              ),
              Text(
                context.l10n.welcomeTagline,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              // Guest warning
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.l10n.guestModeWarning,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryButton(
                label: context.l10n.tryAsParent,
                isLoading: loading == 'parent',
                onPressed: loading != null ? null : () => _tryAs('parent'),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: context.l10n.tryAsChild,
                isLoading: loading == 'child',
                outlined: true,
                onPressed: loading != null ? null : () => _tryAs('child'),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => context.push('/login'),
                  child: Text.rich(
                    TextSpan(
                      text: context.l10n.haveAccount,
                      style: GoogleFonts.nunito(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: context.l10n.login,
                          style: GoogleFonts.nunito(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _tryAs(String role) async {
    setState(() => _loadingRole = role);
    try {
      final user = await ref.read(guestAuthServiceProvider).signInAsGuest(role);
      // Router redirect đọc role từ currentUserProvider — làm mới sau khi tạo user.
      ref.invalidate(currentUserProvider);
      if (!mounted) return;
      context.go(user.role == 'parent' ? '/parent-home' : '/child');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorWithMessage('$e'))),
      );
    } finally {
      if (mounted) setState(() => _loadingRole = null);
    }
  }
}
