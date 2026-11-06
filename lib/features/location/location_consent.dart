import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/privacy_policy.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefKey = 'location_disclosure_accepted';

/// Bé đã đọc thông báo về việc dùng vị trí và đồng ý chưa (lưu theo máy).
/// `null` = đang đọc. Chưa đồng ý thì app không xin quyền, không gửi vị trí.
class LocationConsentNotifier extends StateNotifier<bool?> {
  LocationConsentNotifier() : super(null) {
    loaded = _load();
  }

  late final Future<void> loaded;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) state = prefs.getBool(_prefKey) ?? false;
  }

  Future<void> accept() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
    if (mounted) state = true;
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
    if (mounted) state = false;
  }
}

final locationConsentProvider =
    StateNotifierProvider<LocationConsentNotifier, bool?>(
      (ref) => LocationConsentNotifier(),
    );

/// Cần hỏi bé ngay: đã liên kết (mới có người nhận vị trí) mà chưa đồng ý.
final needsLocationDisclosureProvider = Provider<bool>((ref) {
  final consent = ref.watch(locationConsentProvider);
  final user = ref.watch(currentUserProvider).valueOrNull;
  return consent == false &&
      user?.role == 'child' &&
      (user?.linkedParentIds.isNotEmpty ?? false);
});

/// Thông báo trước khi hệ điều hành hỏi quyền vị trí (Apple 5.1.5, Google Play
/// yêu cầu nêu rõ việc dùng vị trí ở nền). Trả về true nếu bé đồng ý.
Future<bool> showLocationDisclosure(
  BuildContext context,
  LocationConsentNotifier consent,
) async {
  final accepted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.location_on_rounded, size: 40),
      title: Text(ctx.l10n.locationDisclosureTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ctx.l10n.locationDisclosureBody),
            const SizedBox(height: 8),
            TextButton(
              onPressed: openPrivacyPolicy,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(ctx.l10n.privacyPolicy),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(ctx.l10n.locationDisclosureNotNow),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(ctx.l10n.locationDisclosureContinue),
        ),
      ],
    ),
  );
  if (accepted != true) return false;
  await consent.accept();
  return true;
}
