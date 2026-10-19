import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/models/user_model.dart';
import 'user_service.dart';

class GuestAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService;

  GuestAuthService(this._userService);

  /// Ký tự dùng cho mã liên kết — bỏ 0/O/1/I để tránh nhầm lẫn.
  static const linkCodeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Sinh mã 6 ký tự, định dạng 'XXX-YYY'.
  static String generateLinkCode([Random? random]) {
    final rand = random ?? Random.secure();
    final raw = List.generate(
      6,
      (_) => linkCodeChars[rand.nextInt(linkCodeChars.length)],
    ).join();
    return '${raw.substring(0, 3)}-${raw.substring(3)}';
  }

  /// Chuẩn hoá mã người dùng nhập ('abc123', 'ABC-123') → 'ABC-123'.
  /// Trả về null nếu không hợp lệ.
  static String? normalizeLinkCode(String input) {
    final raw = input.trim().toUpperCase().replaceAll('-', '');
    if (!RegExp(r'^[A-Z0-9]{6}$').hasMatch(raw)) return null;
    return '${raw.substring(0, 3)}-${raw.substring(3)}';
  }

  /// Chỉ cho phép liên kết bố/mẹ ↔ con.
  /// Throws [ArgumentError] nếu hai tài khoản cùng vai trò.
  static void validateLinkRoles(String myRole, String theirRole) {
    if (myRole == theirRole) {
      throw ArgumentError(
        myRole == 'parent'
            ? 'Mã này thuộc về tài khoản bố/mẹ khác, không thể liên kết'
            : 'Mã này không thuộc về tài khoản bố/mẹ',
      );
    }
  }

  /// Signs in anonymously and creates a Firestore doc with a unique linkCode.
  Future<UserModel> signInAsGuest(String role) async {
    final cred = await _auth.signInAnonymously();
    final uid = cred.user!.uid;
    final code = await _generateUniqueLinkCode();
    final user = UserModel(
      uid: uid,
      name: role == 'parent' ? 'Bố/Mẹ' : 'Con',
      role: role,
      isGuest: true,
      linkCode: code,
    );
    await _userService.saveUserData(user);
    return user;
  }

  /// Generates a unique link code checked against Firestore.
  Future<String> _generateUniqueLinkCode() async {
    String code;
    bool exists;
    do {
      code = generateLinkCode();
      final query = await _firestore
          .collection(AppConstants.usersCollection)
          .where('linkCode', isEqualTo: code)
          .limit(1)
          .get();
      exists = query.docs.isNotEmpty;
    } while (exists);
    return code;
  }

  /// Links current user to another user by their linkCode.
  /// Throws [ArgumentError] if roles are incompatible (e.g. parent↔parent).
  /// Throws [StateError] if code is not found.
  Future<void> linkToUser(String myUid, String theirLinkCode) async {
    final me = await _userService.getUserData(myUid);
    if (me == null) throw StateError('Không tìm thấy tài khoản của bạn');

    final query = await _firestore
        .collection(AppConstants.usersCollection)
        .where('linkCode', isEqualTo: theirLinkCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw StateError('Không tìm thấy mã liên kết');
    }

    final them = UserModel.fromJson(query.docs.first.data());
    if (them.uid == myUid) {
      throw ArgumentError('Đây là mã của chính bạn');
    }

    validateLinkRoles(me.role, them.role);

    final parentUid = me.role == 'parent' ? myUid : them.uid;
    final childUid = me.role == 'child' ? myUid : them.uid;

    final batch = _firestore.batch();
    batch.update(
      _firestore.collection(AppConstants.usersCollection).doc(childUid),
      {'linkedParentId': parentUid},
    );
    batch.update(
      _firestore.collection(AppConstants.usersCollection).doc(parentUid),
      {
        'linkedChildIds': FieldValue.arrayUnion([childUid]),
      },
    );
    await batch.commit();
  }
}

final guestAuthServiceProvider = Provider<GuestAuthService>((ref) {
  return GuestAuthService(ref.read(userServiceProvider));
});
