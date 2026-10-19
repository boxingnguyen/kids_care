import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/providers/notifications_provider.dart';

void main() {
  test('_startedAt guard: old events are not notified', () {
    final startedAt = DateTime(2026, 10, 15, 9, 0, 0);
    final oldEvent = DateTime(2026, 10, 15, 8, 0, 0); // before startedAt
    final newEvent = DateTime(2026, 10, 15, 10, 0, 0); // after startedAt

    expect(NotificationsNotifier.shouldNotify(oldEvent, startedAt), false);
    expect(NotificationsNotifier.shouldNotify(newEvent, startedAt), true);
  });

  test('guard compares instants across time zones', () {
    final startedAt = DateTime.utc(2026, 10, 15, 2, 0); // 09:00 ICT
    final eventUtc = DateTime.utc(2026, 10, 15, 2, 30);
    expect(NotificationsNotifier.shouldNotify(eventUtc, startedAt), true);
  });
}
