import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/models/user_model.dart';

class GuestAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  DocumentReference<Map<String, dynamic>> _userRef(String uid) =>
      _firestore.collection(AppConstants.usersCollection).doc(uid);

  DocumentReference<Map<String, dynamic>> _codeRef(String code) =>
      _firestore.collection(AppConstants.linkCodesCollection).doc(code);

  /// Signs in anonymously and creates the profile with a unique linkCode.
  Future<UserModel> signInAsGuest(String role) async {
    final cred = await _auth.signInAnonymously();
    return createProfile(
      uid: cred.user!.uid,
      name: role == 'parent' ? 'Bố/Mẹ' : 'Con',
      role: role,
      isGuest: true,
    );
  }

  /// Tạo hồ sơ users/{uid} + link_codes/{code} trong một batch.
  /// Dùng cho mọi đường tạo tài khoản (khách, email, username của con).
  Future<UserModel> createProfile({
    required String uid,
    required String name,
    required String role,
    bool isGuest = false,
    bool nameSet = false,
    String? email,
  }) async {
    final code = await _generateUniqueLinkCode();
    final user = UserModel(
      uid: uid,
      name: name,
      nameSet: nameSet,
      email: email,
      role: role,
      isGuest: isGuest,
      linkCode: code,
    );
    final batch = _firestore.batch();
    batch.set(_userRef(uid), {
      ...user.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.set(_codeRef(code), {'uid': uid, 'role': role});
    await batch.commit();
    return user;
  }

  /// Sinh mã chưa có trong link_codes (tra bằng get — rules không cho list).
  Future<String> _generateUniqueLinkCode() async {
    while (true) {
      final code = generateLinkCode();
      if (!(await _codeRef(code).get()).exists) return code;
    }
  }

  /// Tài khoản cũ (trước khi có link_codes) hoặc tạo qua email chưa có mã:
  /// bổ sung link_codes cho mã hiện tại, hoặc cấp mã mới. Trả về user đã cập nhật.
  Future<UserModel> ensureLinkCode(UserModel user) async {
    final current = user.linkCode;
    if (current != null) {
      final snap = await _codeRef(current).get();
      if (snap.exists && snap.data()?['uid'] == user.uid) return user;
      if (!snap.exists) {
        await _codeRef(current).set({'uid': user.uid, 'role': user.role});
        return user;
      }
    }
    return regenerateLinkCode(user);
  }

  /// Cấp mã mới và huỷ mã cũ — người cầm mã cũ không liên kết được nữa.
  Future<UserModel> regenerateLinkCode(UserModel user) async {
    final code = await _generateUniqueLinkCode();
    final old = user.linkCode;
    final oldSnap = old == null ? null : await _codeRef(old).get();
    final batch = _firestore.batch();
    batch.set(_codeRef(code), {'uid': user.uid, 'role': user.role});
    if (oldSnap != null && oldSnap.data()?['uid'] == user.uid) {
      batch.delete(_codeRef(old!));
    }
    batch.update(_userRef(user.uid), {'linkCode': code});
    await batch.commit();
    return user.copyWith(linkCode: code);
  }

  /// Dữ liệu cũ: bé chỉ có một `linkedParentId` → chuyển sang danh sách
  /// `linkedParentIds` (rules chỉ cho chuyển đúng giá trị cũ).
  /// Trả về true nếu đã ghi (snapshot sẽ phát lại hồ sơ mới).
  Future<bool> migrateLegacyParentLink(
    String uid,
    Map<String, dynamic> data,
  ) async {
    final old = data['linkedParentId'];
    final ids = data['linkedParentIds'] as List?;
    if (data['role'] != 'child' ||
        old is! String ||
        (ids?.isNotEmpty ?? false)) {
      return false;
    }
    await _userRef(uid).update({
      'linkedParentId': FieldValue.delete(),
      'linkedParentIds': [old],
    });
    return true;
  }

  /// Đặt tên hiển thị (hỏi một lần ở màn home).
  Future<void> updateName(String uid, String name) {
    return _userRef(uid).update({'name': name, 'nameSet': true});
  }
}

final guestAuthServiceProvider = Provider<GuestAuthService>((ref) {
  return GuestAuthService();
});
