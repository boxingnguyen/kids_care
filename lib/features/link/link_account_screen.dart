import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/auth/services/guest_auth_service.dart';
import 'package:kids_care/features/auth/widgets/auth_text_field.dart';
import 'package:kids_care/features/auth/widgets/primary_button.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/link/services/link_service.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Nhập mã của người kia → gửi yêu cầu liên kết. Người kia chấp nhận ở màn
/// home thì mới liên kết. Bên dưới là các yêu cầu đang chờ (huỷ được).
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

  Future<void> _send() async {
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
      final me = await ref.read(currentUserProvider.future);
      if (me == null) throw StateError('Chưa đăng nhập');

      await ref.read(linkServiceProvider).sendRequest(me, code);
      if (!mounted) return;
      _codeCtrl.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.linkRequestSent)));
    } on ArgumentError catch (e) {
      setState(() => _errorText = localizeServiceError(l10n, e.message));
    } on StateError catch (e) {
      setState(() => _errorText = localizeServiceError(l10n, e.message));
    } catch (e) {
      setState(() => _errorText = l10n.unknownError('$e'));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final outgoing = ref.watch(outgoingLinkRequestsProvider).valueOrNull ?? [];

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
                label: context.l10n.sendLinkRequest,
                isLoading: _loading,
                onPressed: _loading ? null : _send,
              ),
              if (outgoing.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text(
                  context.l10n.pendingRequestsTitle,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                for (final req in outgoing) _PendingRequestTile(request: req),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingRequestTile extends ConsumerWidget {
  final LinkRequest request;

  const _PendingRequestTile({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(
          Icons.hourglass_top_rounded,
          color: AppTheme.primaryColor,
        ),
        title: Text(context.l10n.pendingRequestCode(request.code)),
        subtitle: Text(context.l10n.pendingRequestsTitle),
        trailing: TextButton(
          onPressed: () => ref.read(linkServiceProvider).cancel(request),
          style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
          child: Text(context.l10n.cancelRequest),
        ),
      ),
    );
  }
}
