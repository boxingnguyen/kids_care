import 'package:flutter_test/flutter_test.dart';
import 'package:geofencing_api/geofencing_api.dart';
import 'package:kids_care/features/geofence/geofence_service.dart';
import 'package:kids_care/providers/geofence_provider.dart';

void main() {
  group('GeofenceService start guard', () {
    test('does nothing when parentId is null', () async {
      final notifier = GeofenceZonesNotifier();
      final started = await GeofenceService.instance.start(
        parentId: null,
        childUid: 'child-uid',
        childName: 'Bon',
        zonesNotifier: notifier,
      );
      expect(started, false);
      expect(notifier.state, isEmpty);
    });
  });

  group('GeofenceService.eventStatusFor', () {
    test('maps enter/exit and ignores dwell', () {
      expect(GeofenceService.eventStatusFor(GeofenceStatus.enter), 'enter');
      expect(GeofenceService.eventStatusFor(GeofenceStatus.exit), 'exit');
      expect(GeofenceService.eventStatusFor(GeofenceStatus.dwell), isNull);
    });
  });
}
