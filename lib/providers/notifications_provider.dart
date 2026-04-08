import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/location_event_model.dart';

// In a real app this would stream from Firestore.
// For the demo we use a local in-memory list seeded with sample data.
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<LocationEventModel>>(
        (ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<List<LocationEventModel>> {
  NotificationsNotifier() : super(_seedEvents());

  void addEvent(LocationEventModel event) {
    state = [event, ...state];
  }

  static List<LocationEventModel> _seedEvents() {
    final now = DateTime.now();
    return [
      LocationEventModel(
        id: '1',
        childId: 'child-001',
        childName: 'Bon',
        eventType: LocationEventType.arrived,
        zoneName: 'Trường học',
        timestamp: now.subtract(const Duration(minutes: 30)),
        statusLabel: 'Đi học',
      ),
      LocationEventModel(
        id: '2',
        childId: 'child-001',
        childName: 'Bon',
        eventType: LocationEventType.left,
        zoneName: 'Nhà',
        timestamp: now.subtract(const Duration(hours: 1)),
        statusLabel: 'Rời khỏi',
      ),
      LocationEventModel(
        id: '3',
        childId: 'child-001',
        childName: 'Bon',
        eventType: LocationEventType.arrived,
        zoneName: 'Nhà',
        timestamp: now.subtract(const Duration(hours: 5)),
        statusLabel: 'Đã về nhà',
      ),
    ];
  }
}
