import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lấy thông tin user từ Firestore dựa trên UID
  Future<UserModel?> getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      // Xử lý lỗi - có thể user chưa có dữ liệu trong Firestore
      return null;
    }
  }

  /// Lấy thông tin user hiện tại
  Future<UserModel?> getCurrentUserData() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    return await getUserData(currentUser.uid);
  }

  /// Tạo hoặc cập nhật thông tin user trong Firestore
  Future<void> saveUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Kiểm tra xem user hiện tại có phải là parent không
  Future<bool> isParent() async {
    final userData = await getCurrentUserData();
    return userData?.role == 'parent';
  }

  /// Kiểm tra xem user hiện tại có phải là child không
  Future<bool> isChild() async {
    final userData = await getCurrentUserData();
    return userData?.role == 'child';
  }
}

// Cung cấp UserService qua Riverpod
final userServiceProvider = Provider<UserService>((ref) => UserService());
