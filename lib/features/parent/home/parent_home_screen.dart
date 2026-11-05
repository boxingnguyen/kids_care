import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_map_tiles.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/core/widgets/name_prompt.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/link/widgets/link_requests_banner.dart';
import 'package:kids_care/features/location/location_providers.dart';
import 'package:kids_care/l10n/l10n.dart';
import 'package:kids_care/models/geofence_event_model.dart';
import 'package:kids_care/models/user_model.dart';
import 'package:kids_care/providers/notifications_provider.dart';

/// Trang chủ của bố/mẹ = thông báo: trên cùng là vị trí gần nhất của từng bé
/// (kèm nút nhờ bé chia sẻ vị trí), dưới là các cập nhật gần đây của bé.
class ParentHomeScreen extends ConsumerWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mới nhất lên đầu.
    final events = [...ref.watch(notificationsProvider)]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final kidsAsync = ref.watch(linkedChildrenProvider);
    final kids = kidsAsync.valueOrNull ?? const <UserModel>[];

    return NamePrompt(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundGrey,
        appBar: AppTopBar(
          title: context.l10n.notifications,
          showBack: false,
          actions: const [SettingsAction()],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const LinkRequestsBanner(),
            if (kidsAsync.hasValue && kids.isEmpty)
              const _NoChildCard()
            else
              for (final kid in kids) ...[
                _ChildLocationCard(kid: kid),
                const SizedBox(height: 14),
              ],
            const SizedBox(height: 8),
            Text(
              context.l10n.recent,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            if (events.isEmpty)
              const _EmptyState()
            else
              ...events.map((e) => _EventTile(event: e)),
          ],
        ),
      ),
    );
  }
}

String _formatWhen(BuildContext context, DateTime t) {
  final now = DateTime.now();
  final sameDay =
      t.year == now.year && t.month == now.month && t.day == now.day;
  return DateFormat(sameDay ? 'HH:mm' : 'dd/MM HH:mm').format(t);
}

// ── Vị trí gần nhất của một bé ──────────────────────────────────────────────
class _ChildLocationCard extends ConsumerStatefulWidget {
  final UserModel kid;

  const _ChildLocationCard({required this.kid});

  @override
  ConsumerState<_ChildLocationCard> createState() => _ChildLocationCardState();
}

class _ChildLocationCardState extends ConsumerState<_ChildLocationCard> {
  /// Cập nhật "còn X phút" / "X phút trước".
  late final Timer _ticker;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(seconds: 20),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  Future<void> _ask() async {
    final me = await ref.read(currentUserProvider.future);
    if (me == null || !mounted) return;
    HapticFeedback.mediumImpact();
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      await ref
          .read(locationRequestServiceProvider)
          .request(
            childId: widget.kid.uid,
            parentId: me.uid,
            parentName: me.name,
          );
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.locationRequestSent(widget.kid.name))),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorWithMessage('$e'))),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final kid = widget.kid;
    final loc = ref.watch(childLocationProvider(kid.uid)).valueOrNull;
    final pending = ref.watch(myLocationRequestProvider(kid.uid)).valueOrNull;
    final now = DateTime.now();
    final live = loc?.isLive(now) ?? false;

    final String status;
    if (loc == null) {
      status = l10n.noLocationYet;
    } else if (live) {
      final mins = (loc.sharingUntil!.difference(now).inSeconds / 60).ceil();
      status = l10n.liveSharingRemaining('$mins');
    } else {
      status = l10n.lastSeenAt(_formatWhen(context, loc.updatedAt ?? now));
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Chỉ hiện bản đồ khi bé đang chia sẻ vị trí.
          if (live)
            SizedBox(
              height: 170,
              child: _MiniMap(
                point: LatLng(loc!.lat, loc.lng),
                live: live,
                name: kid.name,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.childLocationTitle(kid.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (live) const _LiveBadge(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: live ? AppTheme.playColor : AppTheme.textSecondary,
                  ),
                ),
                if (!live) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _sending ? null : _ask,
                      icon: const Icon(Icons.share_location_rounded),
                      label: Text(
                        pending == null
                            ? l10n.askChildLocation(kid.name)
                            : l10n.askAgain,
                      ),
                    ),
                  ),
                  if (pending != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      l10n.locationRequestPending(
                        _formatWhen(context, pending.createdAt),
                      ),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMap extends StatefulWidget {
  final LatLng point;
  final bool live;
  final String name;

  const _MiniMap({required this.point, required this.live, required this.name});

  @override
  State<_MiniMap> createState() => _MiniMapState();
}

/// Bé di chuyển → dời tâm bản đồ (không dựng lại bản đồ, đỡ tải lại tile).
class _MiniMapState extends State<_MiniMap> {
  final _controller = MapController();

  LatLng get point => widget.point;
  bool get live => widget.live;
  String get name => widget.name;

  @override
  void didUpdateWidget(covariant _MiniMap old) {
    super.didUpdateWidget(old);
    if (old.point != widget.point) {
      _controller.move(widget.point, _controller.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = live ? AppTheme.playColor : AppTheme.primaryColor;
    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: point,
        initialZoom: 15.5,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        const AppTileLayer(),
        MarkerLayer(
          markers: [
            Marker(
              point: point,
              width: 44,
              height: 44,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    name.isEmpty ? '👧' : name.characters.first.toUpperCase(),
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const AppMapAttribution(),
      ],
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.playColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.playColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            context.l10n.liveBadge,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppTheme.playColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoChildCard extends StatelessWidget {
  const _NoChildCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Text('👨‍👩‍👧', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 8),
          Text(
            context.l10n.noChildLinkedTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.push('/link'),
            icon: const Icon(Icons.link_rounded),
            label: Text(context.l10n.linkWithChild),
          ),
        ],
      ),
    );
  }
}

// ── Cập nhật gần đây ──────────────────────────────────────────────────────
class _EventTile extends StatelessWidget {
  final GeofenceEventModel event;

  const _EventTile({required this.event});

  Color get _iconColor => switch (event.type) {
    ChildEventType.geofence when event.status == 'exit' => AppTheme.dangerColor,
    ChildEventType.geofence || ChildEventType.todoDone => AppTheme.playColor,
    ChildEventType.noteCreated => AppTheme.dangerColor,
    _ => AppTheme.primaryColor,
  };

  @override
  Widget build(BuildContext context) {
    final text = describeChildEvent(context.l10n, event);
    final emoji = text.title.characters.first;
    final time = event.timestamp.toLocal();
    final now = DateTime.now();
    final isToday =
        time.year == now.year && time.month == now.month && time.day == now.day;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.childName,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text.body,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('HH:mm').format(time),
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: AppTheme.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Hôm nay thì chỉ cần giờ.
              if (!isToday) ...[
                const SizedBox(height: 2),
                Text(
                  DateFormat(
                    time.year == now.year ? 'dd/MM' : 'dd/MM/yyyy',
                  ).format(time),
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: AppTheme.textHint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('🌟', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            context.l10n.noNotifications,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.childNoStatusYet,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
