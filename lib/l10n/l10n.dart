import 'package:flutter/widgets.dart';
import 'package:kids_care/l10n/app_localizations.dart';
import 'package:kids_care/models/child_status.dart';

export 'package:kids_care/l10n/app_localizations.dart';

/// `context.l10n.someKey` — viết tắt cho `AppLocalizations.of(context)`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension ChildStatusL10n on ChildStatusType {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
    ChildStatusType.school => l10n.statusLabelSchool,
    ChildStatusType.playing => l10n.statusLabelPlaying,
    ChildStatusType.home => l10n.statusLabelHome,
    ChildStatusType.arrived => l10n.statusLabelArrived,
    ChildStatusType.unknown => l10n.unknown,
  };
}

/// Mã trạng thái lưu trong `LocationEventModel.statusLabel`:
/// tên enum [ChildStatusType] (school, playing, home, arrived) hoặc
/// `left` cho sự kiện rời vùng an toàn. Dữ liệu cũ (chữ tiếng Việt) được
/// hiển thị nguyên văn.
String localizedStatusCode(AppLocalizations l10n, String? code) =>
    switch (code) {
      'school' => l10n.statusLabelSchool,
      'playing' => l10n.statusLabelPlaying,
      'home' => l10n.statusLabelHome,
      'arrived' => l10n.statusLabelArrived,
      'left' => l10n.statusLabelLeft,
      null => l10n.unknown,
      _ => code,
    };

String statusCodeEmoji(String? code) => switch (code) {
  'school' => '🏫',
  'playing' => '⚽',
  'home' => '🏠',
  'arrived' => '📍',
  'left' => '🚶',
  _ => '📢',
};

/// Các service (guest_auth_service, geofence_provider) ném lỗi bằng chuỗi
/// tiếng Việt cố định (test đang kiểm tra các chuỗi này). Ánh xạ sang bản
/// dịch ở tầng UI; chuỗi lạ thì giữ nguyên.
String localizeServiceError(AppLocalizations l10n, Object? message) {
  final text = message?.toString() ?? '';
  return switch (text) {
    'Mã này thuộc về tài khoản bố/mẹ khác, không thể liên kết' =>
      l10n.errLinkOtherParent,
    'Mã này không thuộc về tài khoản bố/mẹ' => l10n.errLinkNotParent,
    'Không tìm thấy tài khoản của bạn' => l10n.errOwnAccountNotFound,
    'Không tìm thấy mã liên kết' => l10n.errLinkCodeNotFound,
    'Đây là mã của chính bạn' => l10n.errOwnCode,
    'Tối đa 3 vùng an toàn' => l10n.errMaxZones,
    'Chưa đăng nhập' => l10n.notSignedIn,
    _ => text,
  };
}
