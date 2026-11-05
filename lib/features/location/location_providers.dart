import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';

/// Vị trí gần nhất của bé (users/{bé}/location/current).
class ChildLocation {
  final double lat;
  final double lng;
  final double? accuracy;
  final DateTime? updatedAt;
  final DateTime? sharingUntil;

  const ChildLocation({
    required this.lat,
    required this.lng,
    this.accuracy,
    this.updatedAt,
    this.sharingUntil,
  });

  /// Đang chia sẻ trực tiếp: còn hạn và vừa có cập nhật gần đây (iOS dừng
  /// gửi khi bé vuốt tắt app — khi đó coi như đã ngừng dù chưa hết hạn).
  bool isLive(DateTime now) =>
      sharingUntil != null &&
      sharingUntil!.isAfter(now) &&
      updatedAt != null &&
      now.difference(updatedAt!) < const Duration(minutes: 3);

  static ChildLocation? fromData(Map<String, dynamic>? data) {
    final lat = (data?['lat'] as num?)?.toDouble();
    final lng = (data?['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;
    return ChildLocation(
      lat: lat,
      lng: lng,
      accuracy: (data!['accuracy'] as num?)?.toDouble(),
      // Ghi bằng serverTimestamp → có thể null trong snapshot local đầu tiên.
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      sharingUntil: (data['sharingUntil'] as Timestamp?)?.toDate(),
    );
  }
}

DocumentReference<Map<String, dynamic>> _childDoc(String childId) =>
    FirebaseFirestore.instance
        .collection(AppConstants.usersCollection)
        .doc(childId);

/// Vị trí gần nhất của bé [childId] — realtime (bố/mẹ đang liên kết).
final childLocationProvider = StreamProvider.family<ChildLocation?, String>(
  (ref, childId) => _childDoc(childId)
      .collection(AppConstants.locationSubcollection)
      .doc('current')
      .snapshots()
      .map((s) => ChildLocation.fromData(s.data())),
);

/// Yêu cầu chia sẻ vị trí của bố/mẹ gửi tới bé.
class LocationRequest {
  final String fromUid;
  final String fromName;
  final DateTime createdAt;

  const LocationRequest({
    required this.fromUid,
    required this.fromName,
    required this.createdAt,
  });

  factory LocationRequest.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data() ?? const {};
    return LocationRequest(
      fromUid: d.id,
      fromName: (data['fromName'] as String?) ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

/// Bé: các yêu cầu chia sẻ vị trí đang chờ — realtime.
final incomingLocationRequestsProvider = StreamProvider<List<LocationRequest>>((
  ref,
) {
  final uid = ref.watch(authUidProvider).valueOrNull;
  if (uid == null) return Stream.value([]);
  return _childDoc(uid)
      .collection(AppConstants.locationRequestsSubcollection)
      .snapshots()
      .map(
        (s) =>
            s.docs.map(LocationRequest.fromDoc).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );
});

/// Bố/mẹ: yêu cầu mình đã gửi cho bé [childId] (null = chưa gửi / bé đã xử lý).
final myLocationRequestProvider =
    StreamProvider.family<LocationRequest?, String>((ref, childId) {
      final uid = ref.watch(authUidProvider).valueOrNull;
      if (uid == null) return Stream.value(null);
      return _childDoc(childId)
          .collection(AppConstants.locationRequestsSubcollection)
          .doc(uid)
          .snapshots()
          .map((s) => s.exists ? LocationRequest.fromDoc(s) : null);
    });

class LocationRequestService {
  /// Bố/mẹ nhờ bé chia sẻ vị trí (hỏi lại thì ghi đè).
  Future<void> request({
    required String childId,
    required String parentId,
    required String parentName,
  }) {
    return _childDoc(
      childId,
    ).collection(AppConstants.locationRequestsSubcollection).doc(parentId).set({
      'fromUid': parentId,
      'fromName': parentName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Bé bỏ qua yêu cầu, hoặc bố/mẹ huỷ yêu cầu của mình.
  Future<void> dismiss({required String childId, required String parentId}) {
    return _childDoc(childId)
        .collection(AppConstants.locationRequestsSubcollection)
        .doc(parentId)
        .delete();
  }
}

final locationRequestServiceProvider = Provider(
  (_) => LocationRequestService(),
);
