import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/child_status.dart';

// Current child status provider

class ChildStatusNotifier extends StateNotifier<ChildStatus?> {
  ChildStatusNotifier() : super(null);

  void updateStatus(ChildStatusType status) {
    // For now, just update with a dummy childId
    // In real app, this would come from auth
    state = ChildStatus(
      childId: 'current_child',
      type: status,
      updatedAt: DateTime.now(),
    );
  }
}
