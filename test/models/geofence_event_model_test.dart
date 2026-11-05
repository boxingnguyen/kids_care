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

  test('doc cũ (không có type) đọc được, mặc định là sự kiện vùng an toàn', () {
    final restored = GeofenceEventModel.fromJson({
      'id': 'old',
      'zoneId': 'z1',
      'zoneName': 'Nhà',
      'childUid': 'c',
      'childName': 'Bon',
      'status': 'enter',
      'timestamp': '2026-10-15T08:30:00.000Z',
    });
    expect(restored.type, ChildEventType.geofence);
  });

  test('cập nhật mới không cần zone/status', () {
    final restored = GeofenceEventModel.fromJson({
      'id': 'n',
      'type': ChildEventType.shareStarted,
      'childUid': 'c',
      'childName': 'Bon',
      'timestamp': '2026-10-15T08:30:00.000Z',
    });
    expect(restored.zoneName, '');
    expect(restored.status, '');
  });
}
