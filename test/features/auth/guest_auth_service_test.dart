import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/features/auth/services/guest_auth_service.dart';

void main() {
  group('GuestAuthService.generateLinkCode', () {
    test('matches format XXX-YYY with unambiguous chars', () {
      final regex = RegExp(r'^[A-HJ-NP-Z2-9]{3}-[A-HJ-NP-Z2-9]{3}$');
      final rand = Random(42);
      for (var i = 0; i < 200; i++) {
        final code = GuestAuthService.generateLinkCode(rand);
        expect(regex.hasMatch(code), true, reason: 'Code $code invalid');
      }
    });
  });

  group('GuestAuthService.normalizeLinkCode', () {
    test('accepts input with or without dash, any case', () {
      expect(GuestAuthService.normalizeLinkCode('abc123'), 'ABC-123');
      expect(GuestAuthService.normalizeLinkCode(' ABC-123 '), 'ABC-123');
    });

    test('rejects wrong length or symbols', () {
      expect(GuestAuthService.normalizeLinkCode('ABC12'), isNull);
      expect(GuestAuthService.normalizeLinkCode('ABC-12!'), isNull);
      expect(GuestAuthService.normalizeLinkCode(''), isNull);
    });
  });
}
