import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/bundled_fonts.dart';

const _bundled = {
  'w400': FontWeight.w400,
  'w500': FontWeight.w500,
  'w600': FontWeight.w600,
  'w700': FontWeight.w700,
  'w800': FontWeight.w800,
  'w900': FontWeight.w900,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(configureBundledFonts);

  test('every bundled weight loads with runtime fetching off', () async {
    for (final weight in _bundled.values) {
      GoogleFonts.nunito(fontWeight: weight);
    }
    await GoogleFonts.pendingFonts();
  });

  test('lib only uses weights and styles that are bundled', () {
    final sources = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .map((f) => f.readAsStringSync())
        .join('\n');

    final used = RegExp(r'FontWeight\.(\w+)')
        .allMatches(sources)
        .map((m) => m.group(1)!)
        .toSet();
    const aliases = {'normal': 'w400', 'bold': 'w700'};
    final missing = used.where(
      (w) => !_bundled.containsKey(aliases[w] ?? w),
    );

    expect(missing, isEmpty);
    expect(sources.contains('FontStyle.italic'), isFalse);
  });
}
