import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/features/location/location_providers.dart';

void main() {
  final now = DateTime(2026, 11, 5, 10, 0);

  ChildLocation loc({DateTime? until, DateTime? updated}) => ChildLocation(
    lat: 10.7,
    lng: 106.7,
    updatedAt: updated ?? now.subtract(const Duration(seconds: 30)),
    sharingUntil: until,
  );

  test('đang chia sẻ khi còn hạn và vừa cập nhật', () {
    expect(loc(until: now.add(const Duration(minutes: 30))).isLive(now), true);
  });

  test('hết hạn hoặc không chia sẻ → không trực tiếp', () {
    expect(loc().isLive(now), false);
    expect(
      loc(until: now.subtract(const Duration(minutes: 1))).isLive(now),
      false,
    );
  });

  test('còn hạn nhưng lâu không cập nhật (app bị tắt) → không trực tiếp', () {
    expect(
      loc(
        until: now.add(const Duration(minutes: 30)),
        updated: now.subtract(const Duration(minutes: 10)),
      ).isLive(now),
      false,
    );
  });

  test('fromData bỏ qua doc thiếu toạ độ', () {
    expect(ChildLocation.fromData(null), isNull);
    expect(ChildLocation.fromData({'lat': 1}), isNull);
    expect(ChildLocation.fromData({'lat': 1, 'lng': 2})?.lng, 2);
  });
}
