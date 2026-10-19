import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/guest_auth_service.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';

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
    final code = GuestAuthService.normalizeLinkCode(_codeCtrl.text);
    if (code == null) {
      setState(() => _errorText = 'Nhập mã 6 ký tự (VD: ABC-123)');
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
            'Liên kết thành công!',
            style: GoogleFonts.nunito(fontWeight: FontWeight.w900),
          ),
          content: Text(
            'Tài khoản đã được liên kết. Bắt đầu sử dụng ngay?',
            style: GoogleFonts.nunito(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Để sau'),
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
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      if (confirmed == true) _goHome(currentUser?.role);
    } on ArgumentError catch (e) {
      setState(() => _errorText = '${e.message}');
    } on StateError catch (e) {
      setState(() => _errorText = e.message);
    } catch (e) {
      setState(() => _errorText = 'Lỗi không xác định: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Liên kết tài khoản',
          style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () async {
            if (context.canPop()) {
              context.pop();
            } else {
              final user = await ref.read(currentUserProvider.future);
              if (mounted) _goHome(user?.role);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              'Nhập mã liên kết',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhập mã 6 ký tự của bố/mẹ hoặc con để liên kết hai tài khoản với nhau.',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            AuthTextField(
              controller: _codeCtrl,
              hint: 'VD: ABC-123',
              label: 'Mã liên kết',
              errorText: _errorText,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Liên kết',
              isLoading: _loading,
              onPressed: _loading ? null : _link,
            ),
          ],
        ),
      ),
    );
  }
}
