import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/models/user_model.dart';

import '../services/auth_service.dart';

export 'package:kids_care/features/auth/services/guest_auth_service.dart'
    show guestAuthServiceProvider;

/// Provider lưu trạng thái loading khi đang xử lý Google Sign-In
final googleSignInLoadingProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

/// Provider để lấy dữ liệu người dùng hiện tại
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getCurrentUser();
});

/// Provider để theo dõi role của người dùng hiện tại
final userRoleProvider = FutureProvider<String?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.role;
});
