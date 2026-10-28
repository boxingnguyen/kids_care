import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ngôn ngữ mặc định khi thiết bị dùng ngôn ngữ app chưa hỗ trợ.
const Locale kFallbackLocale = Locale('vi');

/// Tên các ngôn ngữ, viết bằng chính ngôn ngữ đó (không dịch) để ai cũng
/// nhận ra ngôn ngữ của mình trong danh sách.
const Map<String, ({String name, String flag})> kLanguageNames = {
  'vi': (name: 'Tiếng Việt', flag: '🇻🇳'),
  'en': (name: 'English', flag: '🇬🇧'),
  'pt': (name: 'Português', flag: '🇧🇷'),
  'ja': (name: '日本語', flag: '🇯🇵'),
  'zh': (name: '中文', flag: '🇨🇳'),
  'id': (name: 'Bahasa Indonesia', flag: '🇮🇩'),
};

const _prefKey = 'app_locale';

/// Ngôn ngữ người dùng chọn trong Cài đặt. `null` = theo ngôn ngữ thiết bị.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null && isSupportedLanguage(code)) state = Locale(code);
  }

  /// Truyền `null` để quay về theo ngôn ngữ thiết bị.
  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_prefKey);
    } else {
      await prefs.setString(_prefKey, locale.languageCode);
    }
    state = locale;
  }
}

bool isSupportedLanguage(String languageCode) => AppLocalizations
    .supportedLocales
    .any((l) => l.languageCode == languageCode);

/// Chọn locale được hỗ trợ gần nhất với danh sách ngôn ngữ của thiết bị,
/// nếu không có thì dùng tiếng Việt.
Locale resolveLocale(Iterable<Locale>? deviceLocales) {
  for (final l in deviceLocales ?? const <Locale>[]) {
    if (isSupportedLanguage(l.languageCode)) return Locale(l.languageCode);
  }
  return kFallbackLocale;
}

/// Lấy bản dịch khi không có BuildContext (vd. thông báo đẩy nền).
AppLocalizations l10nWithoutContext(Locale? chosen) {
  final locale =
      chosen ?? resolveLocale(PlatformDispatcher.instance.locales);
  return lookupAppLocalizations(locale);
}
