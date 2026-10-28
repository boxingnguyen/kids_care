import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Đảm bảo mọi file ngôn ngữ có đủ key và đúng placeholder như file gốc
/// tiếng Việt — tránh trường hợp thêm chữ mới mà quên dịch.
void main() {
  final dir = Directory('lib/l10n');
  final template = _read(File('${dir.path}/app_vi.arb'));
  final templateKeys = _messageKeys(template);

  final others = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb') && !f.path.endsWith('app_vi.arb'))
      .toList();

  test('có đủ 6 ngôn ngữ', () {
    final locales = {
      for (final f in [File('${dir.path}/app_vi.arb'), ...others])
        _read(f)['@@locale'],
    };
    expect(locales, containsAll(['vi', 'en', 'pt', 'ja', 'zh', 'id']));
  });

  for (final file in others) {
    final arb = _read(file);
    final locale = arb['@@locale'];

    test('$locale có đúng bộ key như app_vi.arb', () {
      expect(_messageKeys(arb), equals(templateKeys));
    });

    test('$locale giữ nguyên placeholder', () {
      for (final key in templateKeys) {
        expect(
          _placeholders(arb[key] as String),
          equals(_placeholders(template[key] as String)),
          reason: '$locale/$key',
        );
      }
    });

    test('$locale không có bản dịch rỗng', () {
      for (final key in templateKeys) {
        expect((arb[key] as String).trim(), isNotEmpty, reason: key);
      }
    });
  }
}

Map<String, dynamic> _read(File f) =>
    jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((k) => !k.startsWith('@')).toSet();

Set<String> _placeholders(String message) =>
    RegExp(r'\{(\w+)\}').allMatches(message).map((m) => m.group(1)!).toSet();
