import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/features/auth/services/guest_auth_service.dart';
import 'package:kids_care/models/user_model.dart';

export 'package:kids_care/features/auth/services/guest_auth_service.dart'
    show guestAuthServiceProvider;

/// Provider lưu trạng thái loading khi đang xử lý Google Sign-In
final googleSignInLoadingProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

/// UID đang đăng nhập — đổi khi đăng nhập/đăng xuất.
final authUidProvider = StreamProvider<String?>((ref) {
  return FirebaseAuth.instance.authStateChanges().map((u) => u?.uid);
});

/// Hồ sơ người dùng hiện tại, realtime: thấy ngay khi bên kia chấp nhận
/// yêu cầu liên kết hoặc gỡ liên kết.
final currentUserProvider = StreamProvider<UserModel?>((ref) async* {
  final uid = await ref.watch(authUidProvider.future);
  if (uid == null) {
    yield null;
    return;
  }
  final docRef = FirebaseFirestore.instance
      .collection(AppConstants.usersCollection)
      .doc(uid);
  var migrationChecked = false;
  var backfilled = false;
  await for (final snap in docRef.snapshots()) {
    final data = snap.data();
    if (data == null) {
      yield null;
      continue;
    }
    final user = UserModel.fromJson(data);
    final guest = ref.read(guestAuthServiceProvider);
    if (!migrationChecked) {
      migrationChecked = true;
      try {
        // Đã ghi → snapshot kế tiếp mang hồ sơ mới (rồi mới bổ sung mã bên dưới).
        if (await guest.migrateLegacyParentLink(uid, data)) continue;
      } catch (e) {
        log('migrateLegacyParentLink failed: $e', name: 'currentUserProvider');
      }
    }
    if (!backfilled) {
      backfilled = true;
      // Tài khoản cũ chưa có link_codes → bổ sung, để còn liên kết được.
      try {
        yield await guest.ensureLinkCode(user);
        continue;
      } catch (e) {
        log('ensureLinkCode failed: $e', name: 'currentUserProvider');
      }
    }
    yield user;
  }
});

/// Provider để theo dõi role của người dùng hiện tại
final userRoleProvider = FutureProvider<String?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user?.role;
});
