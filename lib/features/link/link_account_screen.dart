import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/guest_auth_service.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';
import 'package:kids_care/l10n/l10n.dart';

class LinkAccountScreen extends ConsumerStatefulWidget {
  const LinkAccountScreen({super.key});

  @override
  ConsumerState<LinkAccountScreen> createState() => _LinkAccountScreenState();
}

class _LinkAccountScreenState extends ConsumerState<LinkAccountScreen> {
  final _codeCtrl = TextEditingController();
  String? _errorText;
  bool _loading = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _goHome(String? role) {
    context.go(role == 'parent' ? '/parent-home' : '/child');
  }

  Future<void> _link() async {
    final l10n = context.l10n;
    final code = GuestAuthService.normalizeLinkCode(_codeCtrl.text);
    if (code == null) {
      setState(() => _errorText = l10n.linkCodeFormatError);
      return;
    }

    setState(() {
      _errorText = null;
      _loading = true;
    });

    try {
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid == null) throw StateError('Chưa đăng nhập');

      await ref.read(guestAuthServiceProvider).linkToUser(currentUid, code);

      // Làm mới user để linkedParentId / linkedChildIds được cập nhật
      ref.invalidate(currentUserProvider);
      final currentUser = await ref.read(currentUserProvider.future);
      if (!mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            l10n.linkSuccessTitle,
            style: GoogleFonts.nunito(fontWeight: FontWeight.w900),
          ),
          content: Text(
            l10n.linkSuccessMessage,
            style: GoogleFonts.nunito(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.later),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );

      if (!mounted) return;
      if (confirmed == true) _goHome(currentUser?.role);
    } on ArgumentError catch (e) {
      setState(
        () => _errorText = localizeServiceError(l10n, e.message),
      );
    } on StateError catch (e) {
      setState(
        () => _errorText = localizeServiceError(l10n, e.message),
      );
    } catch (e) {
      setState(() => _errorText = l10n.unknownError('$e'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackScope(
      child: Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppTopBar(title: context.l10n.linkAccountTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              context.l10n.enterLinkCode,
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.enterLinkCodeDescription,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            AuthTextField(
              controller: _codeCtrl,
              hint: context.l10n.linkCodeHint,
              label: context.l10n.linkCode,
              errorText: _errorText,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: context.l10n.linkAction,
              isLoading: _loading,
              onPressed: _loading ? null : _link,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
