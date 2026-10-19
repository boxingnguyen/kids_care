import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/models/geofence_event_model.dart';

void main() {
  test('GeofenceEventModel serializes to/from JSON', () {
    final ts = DateTime(2026, 10, 15, 8, 30);
    final model = GeofenceEventModel(
      id: 'evt-1',
      zoneId: 'zone-school',
      zoneName: 'Trường học',
      childUid: 'child-uid',
      childName: 'Bon',
      status: 'exit',
      timestamp: ts,
    );
    final json = model.toJson();
    expect(json['status'], 'exit');
    expect(json['zoneName'], 'Trường học');
    final restored = GeofenceEventModel.fromJson(json);
    expect(restored, model);
  });
}
