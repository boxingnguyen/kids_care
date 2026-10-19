import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/features/auth/services/guest_auth_service.dart';

void main() {
  group('GuestAuthService.validateLinkRoles', () {
    test('parent linking to child succeeds (no throw)', () {
      expect(
        () => GuestAuthService.validateLinkRoles('parent', 'child'),
        returnsNormally,
      );
    });

    test('child linking to parent succeeds (no throw)', () {
      expect(
        () => GuestAuthService.validateLinkRoles('child', 'parent'),
        returnsNormally,
      );
    });

    test('parent linking to parent throws ArgumentError', () {
      expect(
        () => GuestAuthService.validateLinkRoles('parent', 'parent'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('bố/mẹ khác'),
        )),
      );
    });

    test('child linking to child throws ArgumentError with correct message', () {
      expect(
        () => GuestAuthService.validateLinkRoles('child', 'child'),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('không thuộc về tài khoản bố/mẹ'),
        )),
      );
    });
  });
}
