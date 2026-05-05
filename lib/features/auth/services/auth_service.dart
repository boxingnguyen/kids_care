import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kids_care/models/user_model.dart';

import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Đăng nhập bằng Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Gọi popup / màn hình đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng ấn huỷ
        return null;
      }

      // Lấy authentication data (tokens)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo Firebase credential từ Google tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase bằng credential vừa tạo
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // Xử lý lỗi (tuỳ chọn: ném ra ngoài để UI hiển thị dialog / snackbar)
      rethrow;
    }
  }

  /// Đăng xuất khỏi Google và Firebase
  Future<void> signOut() async {
    await _googleSignIn.signOut();
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
