import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/l10n/l10n.dart';

/// Bọc màn home: lần đầu vào (chưa đặt tên — `nameSet` false) hỏi tên người
/// dùng và lưu vào hồ sơ. [onNameSet] chạy sau khi lưu (vd. cập nhật tên con
/// trong GeofenceService).
class NamePrompt extends ConsumerStatefulWidget {
  final Widget child;
  final ValueChanged<String>? onNameSet;

  const NamePrompt({super.key, required this.child, this.onNameSet});

  @override
  ConsumerState<NamePrompt> createState() => _NamePromptState();
}

class _NamePromptState extends ConsumerState<NamePrompt> {
  bool _asked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAsk());
  }

  Future<void> _maybeAsk() async {
    final user = await ref.read(currentUserProvider.future);
    if (_asked || user == null || user.nameSet || !mounted) return;
    _asked = true;

    final name = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _NameDialog(isParent: user.role == 'parent'),
    );
    if (name == null || !mounted) return;

    await ref.read(guestAuthServiceProvider).updateName(user.uid, name);
    ref.invalidate(currentUserProvider);
    widget.onNameSet?.call(name);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _NameDialog extends StatefulWidget {
  final bool isParent;

  const _NameDialog({required this.isParent});

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _ctrl.text.trim();
    if (name.isNotEmpty) Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          context.l10n.setNameTitle,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
          ),
        ),
        content: TextField(
          controller: _ctrl,
          autofocus: true,
          maxLength: 30,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.isParent
                ? context.l10n.setNameParentHint
                : context.l10n.setNameChildHint,
            hintStyle: GoogleFonts.nunito(color: AppTheme.textHint),
            filled: true,
            fillColor: AppTheme.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: _ctrl.text.trim().isEmpty ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              context.l10n.save,
              style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
