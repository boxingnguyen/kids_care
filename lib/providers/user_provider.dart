import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_status.dart';
import '../core/constants/app_constants.dart';

// User mode provider: 'child' or 'parent'
final userModeProvider = StateNotifierProvider<UserModeNotifier, String>((ref) {
  return UserModeNotifier();
});

class UserModeNotifier extends StateNotifier<String> {
  UserModeNotifier() : super('child') {
    _loadMode();
  }

  Future<void> _loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(AppConstants.prefUserMode) ?? 'child';
    state = savedMode;
  }

  Future<void> setMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefUserMode, mode);
    state = mode;
  }
}

// Child name
final childNameProvider = StateNotifierProvider<ChildNameNotifier, String>((ref) {
  return ChildNameNotifier();
});

class ChildNameNotifier extends StateNotifier<String> {
  ChildNameNotifier() : super('Bon') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(AppConstants.prefChildName) ?? 'Bon';
  }

  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefChildName, name);
    state = name;
  }
}

// Current child status provider
final childStatusProvider =
    StateNotifierProvider<ChildStatusNotifier, ChildStatusType>((ref) {
  return ChildStatusNotifier();
});

class ChildStatusNotifier extends StateNotifier<ChildStatusType> {
  ChildStatusNotifier() : super(ChildStatusType.unknown);

  void updateStatus(ChildStatusType newStatus) {
    state = newStatus;
  }
}
