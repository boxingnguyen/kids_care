import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/link/services/link_service.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Yêu cầu liên kết đang chờ mình trả lời — đặt ở đầu màn home.
/// Không có yêu cầu thì không chiếm chỗ.
class LinkRequestsBanner extends ConsumerWidget {
  const LinkRequestsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(incomingLinkRequestsProvider).valueOrNull ?? [];
    if (requests.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (final req in requests)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _RequestCard(request: req),
          ),
      ],
    );
  }
}

class _RequestCard extends ConsumerStatefulWidget {
  final LinkRequest request;

  const _RequestCard({required this.request});

  @override
  ConsumerState<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<_RequestCard> {
  bool _busy = false;

  Future<void> _respond({required bool accept}) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final service = ref.read(linkServiceProvider);
    setState(() => _busy = true);
    try {
      if (accept) {
        final me = await ref.read(currentUserProvider.future);
        if (me == null) throw StateError('Chưa đăng nhập');
        await service.accept(me, widget.request);
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.linkRequestAccepted(widget.request.fromName)),
          ),
        );
      } else {
        await service.reject(widget.request);
      }
    } on StateError catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(localizeServiceError(l10n, e.message))),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorWithMessage('$e'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔗', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  req.fromRole == 'parent'
                      ? l10n.linkRequestFromParent(req.fromName)
                      : l10n.linkRequestFromChild(req.fromName),
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.linkRequestHint,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _busy ? null : () => _respond(accept: false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(l10n.reject),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _busy ? null : () => _respond(accept: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l10n.accept,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
