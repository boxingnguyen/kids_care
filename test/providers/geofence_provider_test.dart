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
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Tối đa 3 vùng an toàn',
          ),
        ),
      );
    });
  });

  group('freeSlot', () {
    test('lấy ô trống đầu tiên', () {
      expect(GeofenceZonesNotifier.freeSlot([]), 'z1');
      expect(GeofenceZonesNotifier.freeSlot(['z1', 'z3']), 'z2');
    });

    test('đủ 3 ô thì trả về null', () {
      expect(GeofenceZonesNotifier.freeSlot(['z1', 'z2', 'z3']), isNull);
    });
  });
}
