import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/providers/geofence_provider.dart';

void main() {
  group('3-zone limit guard', () {
    test('allows adding up to 3 zones', () {
      expect(() => GeofenceZonesNotifier.checkZoneLimit(0), returnsNormally);
      expect(() => GeofenceZonesNotifier.checkZoneLimit(2), returnsNormally);
    });

    test('throws StateError when adding a 4th zone', () {
      expect(
        () => GeofenceZonesNotifier.checkZoneLimit(3),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          'Tối đa 3 vùng an toàn',
        )),
      );
    });
  });
}
