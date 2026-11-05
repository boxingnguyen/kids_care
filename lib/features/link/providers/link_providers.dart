import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/services/link_service.dart';
import 'package:kids_care/models/user_model.dart';

CollectionReference<Map<String, dynamic>> get _requests =>
    FirebaseFirestore.instance.collection(AppConstants.linkRequestsCollection);

/// Yêu cầu liên kết gửi tới mình, đang chờ trả lời — hiện ở màn home.
final incomingLinkRequestsProvider = StreamProvider<List<LinkRequest>>((ref) {
  final uid = ref.watch(authUidProvider).valueOrNull;
  if (uid == null) return Stream.value([]);
  return _requests
      .where('toUid', isEqualTo: uid)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((s) => s.docs.map(LinkRequest.fromDoc).toList());
});

/// Yêu cầu mình đã gửi, đang chờ bên kia chấp nhận.
final outgoingLinkRequestsProvider = StreamProvider<List<LinkRequest>>((ref) {
  final uid = ref.watch(authUidProvider).valueOrNull;
  if (uid == null) return Stream.value([]);
  return _requests
      .where('fromUid', isEqualTo: uid)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((s) => s.docs.map(LinkRequest.fromDoc).toList());
});

/// Các con đã liên kết với bố/mẹ hiện tại — realtime. Rules chỉ cho đọc doc
/// có mình trong linkedParentIds.
final linkedChildrenProvider = StreamProvider<List<UserModel>>((ref) {
  final uid = ref.watch(authUidProvider).valueOrNull;
  if (uid == null) return Stream.value([]);
  return FirebaseFirestore.instance
      .collection(AppConstants.usersCollection)
      .where('linkedParentIds', arrayContains: uid)
      .snapshots()
      .map((s) => s.docs.map((d) => UserModel.fromJson(d.data())).toList());
});

/// Khoá ổn định cho danh sách bố/mẹ của con (List so sánh theo identity nên
/// không dùng trực tiếp trong select/listen).
String guardianKey(UserModel? user) =>
    ([...?user?.linkedParentIds]..sort()).join(',');

/// Các bố/mẹ (người thân) đang liên kết với con hiện tại. Đọc từng doc theo id
/// trong linkedParentIds của chính mình; doc không đọc được thì bỏ qua.
final linkedParentsProvider = FutureProvider<List<UserModel>>((ref) async {
  final key = ref.watch(
    currentUserProvider.select((u) => guardianKey(u.valueOrNull)),
  );
  if (key.isEmpty) return [];
  final users = FirebaseFirestore.instance.collection(
    AppConstants.usersCollection,
  );
  final parents = <UserModel>[];
  for (final id in key.split(',')) {
    try {
      final snap = await users.doc(id).get();
      if (snap.exists) parents.add(UserModel.fromJson(snap.data()!));
    } on FirebaseException {
      // Bên kia đã gỡ liên kết một phía — bỏ qua.
    }
  }
  return parents;
});
