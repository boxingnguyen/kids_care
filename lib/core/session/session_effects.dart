import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_care/core/notifications/local_notifications.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/geofence/geofence_service.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/location/live_location_service.dart';
import 'package:kids_care/features/location/location_consent.dart';
import 'package:kids_care/features/location/location_providers.dart';
import 'package:kids_care/features/notes/notes_provider.dart';
import 'package:kids_care/l10n/locale_provider.dart';
import 'package:kids_care/models/user_model.dart';
import 'package:kids_care/providers/geofence_provider.dart';
import 'package:kids_care/providers/notifications_provider.dart';
import 'package:kids_care/providers/user_provider.dart';

/// Việc chạy suốt phiên đăng nhập, không phụ thuộc màn/tab đang mở:
///  - bố/mẹ: nghe cập nhật của các bé và bắn thông báo có âm thanh;
///  - bé: theo dõi vùng an toàn, tiếp tục chia sẻ vị trí còn hạn, báo khi
///    bố/mẹ nhờ chia sẻ vị trí.
class SessionEffects extends ConsumerStatefulWidget {
  final Widget child;

  const SessionEffects({super.key, required this.child});

  @override
  ConsumerState<SessionEffects> createState() => _SessionEffectsState();
}

class _SessionEffectsState extends ConsumerState<SessionEffects> {
  /// Các lần khởi động chạy nối tiếp — Geofencing.start() lần 2 song song sẽ throw.
  Future<void> _geofencingQueue = Future.value();
  final DateTime _startedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Khoá chuỗi (không dùng List) để không chạy lại ở mỗi snapshot hồ sơ:
    // chạy khi đăng nhập, khi bố/mẹ chấp nhận / gỡ liên kết, khi đổi tên.
    ref.listenManual(
      currentUserProvider.select((u) {
        final user = u.valueOrNull;
        if (user == null || user.role != 'child') return '';
        return '${user.uid}|${guardianKey(user)}|${user.name}';
      }),
      (prev, next) => _onChildSessionChanged(prev ?? '', next),
      fireImmediately: true,
    );
    // Bé vừa đồng ý dùng vị trí (hoặc vừa đọc xong lựa chọn đã lưu).
    ref.listenManual(locationConsentProvider, (prev, next) {
      if (next == true && prev != true) _startGeofencing();
    });
  }

  void _onChildSessionChanged(String prev, String next) {
    if (prev == next) return;
    final hasParents = next.isNotEmpty && next.split('|')[1].isNotEmpty;
    final prevUid = prev.isEmpty ? null : prev.split('|')[0];
    final nextUid = next.isEmpty ? null : next.split('|')[0];
    final share = ref.read(liveShareProvider.notifier);

    if (!hasParents) {
      // Gỡ hết liên kết / đăng xuất → không gửi vùng, vị trí cho ai nữa.
      if (prev.isNotEmpty) {
        GeofenceService.instance.stop();
        if (share.isSharing) share.stop(notify: false);
      }
      return;
    }
    _startGeofencing();
    if (prevUid != nextUid && nextUid != null) share.resumeIfNeeded(nextUid);
  }

  Future<void> _startGeofencing() {
    return _geofencingQueue = _geofencingQueue
        .then((_) => _doStartGeofencing())
        .catchError((Object e) => debugPrint('start geofencing failed: $e'));
  }

  Future<void> _doStartGeofencing() async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null || user.role != 'child' || !mounted) return;
    if (user.nameSet) ref.read(childNameProvider.notifier).setName(user.name);
    // Chưa đồng ý thì chưa xin quyền, chưa theo dõi vị trí.
    if (ref.read(locationConsentProvider) != true) return;
    await GeofenceService.instance.start(
      parentIds: user.linkedParentIds,
      childUid: user.uid,
      childName: user.name,
      zonesNotifier: ref.read(geofenceZonesProvider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(
      currentUserProvider.select((u) => u.valueOrNull?.role),
    );
    if (role == 'parent') {
      // Giữ stream cập nhật của bé chạy (bắn thông báo), không rebuild.
      ref.listen(notificationsProvider, (_, _) {});
    } else if (role == 'child') {
      ref.listen(incomingLocationRequestsProvider, (prev, next) {
        // Hỏi lại = ghi đè cùng doc với createdAt mới → khoá theo cả hai.
        final before = {...?prev?.valueOrNull?.map(_requestKey)};
        for (final r in next.valueOrNull ?? const <LocationRequest>[]) {
          if (before.contains(_requestKey(r)) ||
              !r.createdAt.isAfter(_startedAt)) {
            continue;
          }
          final l10n = l10nWithoutContext(ref.read(localeProvider));
          showAlertNotification(
            id: 'locreq_${r.fromUid}'.hashCode,
            title: '📍 ${l10n.locationRequestTitle}',
            body: l10n.locationRequestBody(r.fromName),
            l10n: l10n,
          );
        }
      });
      // Bố/mẹ vừa làm xong lời nhắn của bé → báo cho bé.
      ref.listen(childNotesProvider, (prev, next) {
        final wasDone = {
          for (final n in prev?.valueOrNull ?? const <ParentNote>[])
            if (n.isCompleted) n.id,
        };
        for (final n in next.valueOrNull ?? const <ParentNote>[]) {
          final at = n.completedAt;
          if (!n.isCompleted || wasDone.contains(n.id)) continue;
          if (prev?.valueOrNull == null || at == null) continue;
          if (!at.isAfter(_startedAt)) continue;
          final l10n = l10nWithoutContext(ref.read(localeProvider));
          showAlertNotification(
            id: 'note_${n.id}'.hashCode,
            title: '✅ ${n.title}',
            body: l10n.noteDoneNotif(n.completedByName ?? '', n.title),
            l10n: l10n,
          );
        }
      });
    }
    return widget.child;
  }
}

String _requestKey(LocationRequest r) =>
    '${r.fromUid}@${r.createdAt.millisecondsSinceEpoch}';

/// Dừng mọi việc chạy nền của bé trước khi đăng xuất (còn quyền ghi).
Future<void> stopSessionBeforeSignOut(WidgetRef ref) async {
  await ref.read(liveShareProvider.notifier).stop(notify: false);
  await GeofenceService.instance.stop();
  ref.read(geofenceZonesProvider.notifier).stopWatching();
}

/// Xoá tài khoản thất bại → bật lại theo dõi vùng an toàn đã dừng ở trên.
Future<void> resumeSessionAfterFailedDelete(
  WidgetRef ref,
  UserModel user,
) async {
  if (user.role != 'child' || ref.read(locationConsentProvider) != true) return;
  await GeofenceService.instance.start(
    parentIds: user.linkedParentIds,
    childUid: user.uid,
    childName: user.name,
    zonesNotifier: ref.read(geofenceZonesProvider.notifier),
  );
}
