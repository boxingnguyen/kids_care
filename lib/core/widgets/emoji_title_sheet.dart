import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';

/// Bottom sheet nhập một dòng chữ + chọn emoji (bé thêm việc, viết lời nhắn).
/// Trả về null nếu bé đóng sheet.
Future<({String title, String emoji})?> showEmojiTitleSheet(
  BuildContext context, {
  required String title,
  required String hint,
  required String submitLabel,
  required List<String> emojis,
}) {
  return showModalBottomSheet<({String title, String emoji})>(
    context: context,
    // Mở trên navigator gốc → che cả thanh tab.
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _EmojiTitleSheet(
      title: title,
      hint: hint,
      submitLabel: submitLabel,
      emojis: emojis,
    ),
  );
}

class _EmojiTitleSheet extends StatefulWidget {
  final String title;
  final String hint;
  final String submitLabel;
  final List<String> emojis;

  const _EmojiTitleSheet({
    required this.title,
    required this.hint,
    required this.submitLabel,
    required this.emojis,
  });

  @override
  State<_EmojiTitleSheet> createState() => _EmojiTitleSheetState();
}

class _EmojiTitleSheetState extends State<_EmojiTitleSheet> {
  final _ctrl = TextEditingController();
  late String _emoji = widget.emojis.first;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _ctrl.text.trim();
    if (title.isEmpty) return;
    Navigator.pop(context, (title: title, emoji: _emoji));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _ctrl,
            autofocus: true,
            maxLength: 60,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(hintText: widget.hint),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final e in widget.emojis)
                GestureDetector(
                  onTap: () => setState(() => _emoji = e),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _emoji == e
                          ? AppTheme.primaryColor.withValues(alpha: 0.18)
                          : AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _emoji == e
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(e, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _ctrl.text.trim().isEmpty ? null : _submit,
              child: Text(
                widget.submitLabel,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
