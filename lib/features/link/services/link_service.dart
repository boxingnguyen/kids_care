import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/features/auth/services/guest_auth_service.dart';
import 'package:kids_care/models/user_model.dart';

/// Yêu cầu liên kết: [fromUid] nhập mã của [toUid], chờ [toUid] chấp nhận.
class LinkRequest {
  final String id;
  final String fromUid;
  final String fromRole;
  final String fromName;
  final String toUid;
  final String toRole;
  final String code;
  final String status;

  const LinkRequest({
    required this.id,
    required this.fromUid,
    required this.fromRole,
    required this.fromName,
    required this.toUid,
    required this.toRole,
    required this.code,
    required this.status,
  });

  factory LinkRequest.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return LinkRequest(
      id: doc.id,
      fromUid: d['fromUid'] as String,
      fromRole: d['fromRole'] as String,
      fromName: (d['fromName'] as String?) ?? '',
      toUid: d['toUid'] as String,
      toRole: d['toRole'] as String,
      code: (d['code'] as String?) ?? '',
      status: d['status'] as String,
    );
  }
}

/// Liên kết bố/mẹ ↔ con theo cơ chế yêu cầu → chấp nhận, và gỡ liên kết.
/// Một bé liên kết tối đa [maxGuardians] người (bố, mẹ, ông bà…).
/// Rules tương ứng: firestore.rules (link_requests, users).
class LinkService {
  static const int maxGuardians = 3;

  final FirebaseFirestore _db;

  LinkService([FirebaseFirestore? db]) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _db.collection(AppConstants.linkRequestsCollection);

  DocumentReference<Map<String, dynamic>> _userRef(String uid) =>
      _db.collection(AppConstants.usersCollection).doc(uid);

  /// Gửi yêu cầu liên kết tới chủ của [code].
  /// Throws [ArgumentError] nếu sai vai trò / mã của chính mình,
  /// [StateError] nếu không thấy mã, đã liên kết hoặc đã có yêu cầu đang chờ.
  Future<void> sendRequest(UserModel me, String code) async {
    final codeSnap = await _db
        .collection(AppConstants.linkCodesCollection)
        .doc(code)
        .get();
    final codeData = codeSnap.data();
    if (codeData == null) throw StateError('Không tìm thấy mã liên kết');

    final toUid = codeData['uid'] as String;
    final toRole = codeData['role'] as String;
    if (toUid == me.uid) throw ArgumentError('Đây là mã của chính bạn');
    GuestAuthService.validateLinkRoles(me.role, toRole);

    if (_isLinked(me, toUid)) throw StateError('Hai tài khoản đã liên kết');
    _checkGuardianLimit(me);

    final pending = await _requests
        .where('fromUid', isEqualTo: me.uid)
        .where('toUid', isEqualTo: toUid)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .get();
    if (pending.docs.isNotEmpty) {
      throw StateError('Đã gửi yêu cầu, đang chờ chấp nhận');
    }

    await _requests.add({
      'fromUid': me.uid,
      'fromRole': me.role,
      'fromName': me.name,
      'toUid': toUid,
      'toRole': toRole,
      'code': code,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Chấp nhận: trong một batch, đánh dấu yêu cầu đã chấp nhận và ghi liên kết
  /// vào cả hai hồ sơ (người gửi không cần online). Đồng thời xoá yêu cầu mình
  /// đã gửi người kia (nếu có) để không còn yêu cầu ngược chiều treo lại.
  Future<void> accept(UserModel me, LinkRequest req) async {
    final alreadyLinked = _isLinked(me, req.fromUid);
    if (!alreadyLinked) _checkGuardianLimit(me);

    final reverse = await _requests
        .where('fromUid', isEqualTo: me.uid)
        .where('toUid', isEqualTo: req.fromUid)
        .where('status', isEqualTo: 'pending')
        .get();

    final batch = _db.batch();
    batch.update(_requests.doc(req.id), {
      'status': 'accepted',
      'respondedAt': FieldValue.serverTimestamp(),
    });
    for (final d in reverse.docs) {
      batch.delete(d.reference);
    }
    if (alreadyLinked) {
      // Đã liên kết (vd. hai bên cùng gửi yêu cầu) — chỉ đóng yêu cầu.
    } else if (me.role == 'child') {
      batch.update(_userRef(me.uid), {
        'linkedParentIds': FieldValue.arrayUnion([req.fromUid]),
        'linkedVia': req.id,
      });
      batch.update(_userRef(req.fromUid), {
        'linkedChildIds': FieldValue.arrayUnion([me.uid]),
      });
    } else {
      batch.update(_userRef(me.uid), {
        'linkedChildIds': FieldValue.arrayUnion([req.fromUid]),
        'linkedVia': req.id,
      });
      batch.update(_userRef(req.fromUid), {
        'linkedParentIds': FieldValue.arrayUnion([me.uid]),
      });
    }
    try {
      await batch.commit();
    } on FirebaseException catch (e) {
      // Yêu cầu đã bị huỷ / trả lời, tài khoản bên kia không còn, hoặc bé đã
      // đủ người liên kết (bố/mẹ không đọc được hồ sơ bé để kiểm tra trước).
      if (e.code == 'permission-denied' || e.code == 'not-found') {
        throw StateError('Yêu cầu không còn hiệu lực');
      }
      rethrow;
    }
  }

  Future<void> reject(LinkRequest req) {
    return _requests.doc(req.id).update({
      'status': 'rejected',
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Người gửi huỷ yêu cầu đang chờ.
  Future<void> cancel(LinkRequest req) => _requests.doc(req.id).delete();

  /// Gỡ liên kết giữa [me] và [otherUid]. Mỗi bên chỉ gỡ chính mình khỏi hồ sơ
  /// bên kia; nếu bên kia đã tự gỡ trước thì chỉ dọn hồ sơ của mình.
  Future<void> unlink(UserModel me, String otherUid) async {
    final batch = _db.batch();
    if (me.role == 'parent') {
      batch.update(_userRef(me.uid), {
        'linkedChildIds': FieldValue.arrayRemove([otherUid]),
      });
      if (await _isStillMyChild(me.uid, otherUid)) {
        batch.update(_userRef(otherUid), {
          'linkedParentIds': FieldValue.arrayRemove([me.uid]),
        });
      }
    } else {
      batch.update(_userRef(me.uid), {
        'linkedParentIds': FieldValue.arrayRemove([otherUid]),
      });
      batch.update(_userRef(otherUid), {
        'linkedChildIds': FieldValue.arrayRemove([me.uid]),
      });
    }
    await batch.commit();
  }

  static bool _isLinked(UserModel me, String otherUid) => me.role == 'parent'
      ? me.linkedChildIds.contains(otherUid)
      : me.linkedParentIds.contains(otherUid);

  static void _checkGuardianLimit(UserModel me) {
    if (me.role == 'child' && me.linkedParentIds.length >= maxGuardians) {
      throw StateError('Đã đủ 3 người liên kết');
    }
  }

  /// Con có còn liên kết với mình không — chỉ đọc được hồ sơ con khi còn liên kết.
  Future<bool> _isStillMyChild(String parentUid, String childUid) async {
    try {
      final snap = await _userRef(childUid).get();
      final ids = (snap.data()?['linkedParentIds'] as List?) ?? const [];
      return ids.contains(parentUid);
    } on FirebaseException {
      return false;
    }
  }
}

final linkServiceProvider = Provider<LinkService>((ref) => LinkService());
