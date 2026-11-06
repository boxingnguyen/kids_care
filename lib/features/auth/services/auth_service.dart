import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/core/notifications/push_notifications.dart';
import 'package:kids_care/models/user_model.dart';

import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Tài khoản email thật chưa xác thực → phải qua màn xác thực trước khi vào
  /// app. Khách (anonymous) và username của con (email giả) được miễn.
  static bool needsEmailVerification(User? user) {
    final email = user?.email;
    if (user == null || user.isAnonymous || email == null) return false;
    if (email.endsWith('@${AppConstants.childUsernameDomain}')) return false;
    return !user.emailVerified;
  }

  /// Gắn email + mật khẩu vào tài khoản khách (giữ nguyên UID và dữ liệu),
  /// rồi gửi link xác thực.
  Future<void> linkGuestWithEmail(
    String email,
    String password, {
    String? languageCode,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await _auth.currentUser!.linkWithCredential(credential);
    await sendVerificationEmail(languageCode: languageCode);
  }

  Future<void> sendVerificationEmail({String? languageCode}) async {
    if (languageCode != null) await _auth.setLanguageCode(languageCode);
    await _auth.currentUser!.sendEmailVerification();
  }

  /// Tải lại user từ server (emailVerified chỉ cập nhật sau reload).
  Future<bool> reloadAndCheckVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  /// Huỷ gắn email (khách đổi ý trước khi xác thực) → trở lại anonymous.
  Future<void> cancelEmailLink() async {
    await _auth.currentUser?.unlink(EmailAuthProvider.PROVIDER_ID);
  }

  /// Email đã xác thực → cập nhật hồ sơ (không còn là khách).
  Future<void> markEmailVerified() async {
    final user = _auth.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'isGuest': false,
      'email': user.email,
    });
  }

  Future<void> signOut() async {
    // Gỡ token FCM khi còn đăng nhập — máy này thôi nhận thông báo của tài khoản.
    await PushNotifications.instance.unregister();
    await _auth.signOut();
  }

  /// Xoá vĩnh viễn tài khoản và dữ liệu (Cloud Function `deleteAccount`), rồi
  /// đăng xuất khỏi máy này. Lỗi thì ném ra và vẫn còn đăng nhập để thử lại.
  Future<void> deleteAccount() async {
    await FirebaseFunctions.instanceFor(
      region: AppConstants.functionsRegion,
    ).httpsCallable('deleteAccount').call<void>();
    await PushNotifications.instance.unregister(removeFromProfile: false);
    await _auth.signOut();
  }

  /// Lấy thông tin user hiện tại từ Firestore
  Future<UserModel?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }

    final userService = UserService();
    return await userService.getUserData(currentUser.uid);
  }
}

// Cung cấp AuthService qua Riverpod
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
