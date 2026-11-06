import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/name_prompt.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/child/child_events.dart';
import 'package:kids_care/features/link/widgets/link_requests_banner.dart';
import 'package:kids_care/features/location/live_location_service.dart';
import 'package:kids_care/features/location/location_consent.dart';
import 'package:kids_care/features/location/location_providers.dart';
import 'package:kids_care/models/child_status.dart';
import 'package:kids_care/models/geofence_event_model.dart';
import 'package:kids_care/providers/user_provider.dart';
import 'package:kids_care/l10n/l10n.dart';

class ChildHomeScreen extends ConsumerStatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  ConsumerState<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends ConsumerState<ChildHomeScreen> {
  // Theo dõi vùng an toàn / chia sẻ vị trí chạy ở SessionEffects (cả phiên).

  /// "Để sau" chỉ có hiệu lực tới lần mở app kế tiếp.
  bool _disclosureAsked = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(needsLocationDisclosureProvider, (_, needs) {
      if (needs) _askLocationDisclosure();
    }, fireImmediately: true);
  }

  void _askLocationDisclosure() {
    if (_disclosureAsked) return;
    _disclosureAsked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showLocationDisclosure(
        context,
        ref.read(locationConsentProvider.notifier),
      );
    });
  }

  Future<void> _updateStatus(ChildStatusType status) async {
    HapticFeedback.mediumImpact();
    ref.read(childStatusProvider.notifier).updateStatus(status);
    final user = await ref.read(currentUserProvider.future);
    if (!mounted) return;

    unawaited(
      ChildEvents.publishFor(
        user,
        type: ChildEventType.status,
        status: status.name,
        zoneName: _getZoneForStatus(status),
      ),
    );
    if (user != null &&
        user.linkedParentIds.isNotEmpty &&
        ref.read(locationConsentProvider) == true) {
      unawaited(_shareLastLocation(user.uid));
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            user?.linkedParentIds.isEmpty ?? true
                ? context.l10n.notLinkedYetHint
                : context.l10n.toldParents(
                    '${status.localizedLabel(context.l10n)} ${status.emoji}',
                  ),
            style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  /// Kèm vị trí hiện tại (nếu đã có quyền — không hỏi quyền ở đây) để bố/mẹ
  /// thấy "vị trí gần nhất".
  Future<void> _shareLastLocation(String uid) async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          timeLimit: Duration(seconds: 15),
        ),
      );
      await LiveShareNotifier.writeLastLocation(
        uid,
        lat: p.latitude,
        lng: p.longitude,
        accuracy: p.accuracy,
      );
    } catch (e) {
      debugPrint('status location failed: $e');
    }
  }

  String _getZoneForStatus(ChildStatusType s) {
    switch (s) {
      case ChildStatusType.school:
        return context.l10n.zoneSchool;
      case ChildStatusType.playing:
        return context.l10n.zonePlayground;
      case ChildStatusType.home:
      case ChildStatusType.arrived:
        return context.l10n.zoneHome;
      default:
        return context.l10n.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final childName = ref.watch(childNameProvider);
    final currentStatus = ref.watch(childStatusProvider);
    final sendsLocation =
        ref.watch(locationConsentProvider) == true &&
        ref.watch(
          currentUserProvider.select(
            (u) => u.valueOrNull?.linkedParentIds.isNotEmpty ?? false,
          ),
        );

    return NamePrompt(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundGrey,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(childName),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    children: [
                      const LinkRequestsBanner(),
                      const _LocationRequestsBanner(),
                      Text(
                        context.l10n.howAreYouToday,
                        style: GoogleFonts.nunito(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        context.l10n.pickButtonToTell,
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (sendsLocation) ...[
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.checkInLocationHint,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 32),

                      // 2×2 Status grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.95,
                        children: [
                          _StatusCard(
                            icon: Icons.school_rounded,
                            label: context.l10n.statusGoSchool,
                            sublabel: 'SCHOOL',
                            color: const Color(0xFFFFCA28), // Amber
                            isSelected: currentStatus == ChildStatusType.school,
                            onTap: () => _updateStatus(ChildStatusType.school),
                          ),
                          _StatusCard(
                            icon: Icons.sports_esports_rounded,
                            label: context.l10n.statusGoPlay,
                            sublabel: 'PLAY',
                            color: const Color(0xFF4ADE80), // Green
                            isSelected:
                                currentStatus == ChildStatusType.playing,
                            onTap: () => _updateStatus(ChildStatusType.playing),
                          ),
                          _StatusCard(
                            icon: Icons.location_on_rounded,
                            label: context.l10n.statusArrived,
                            sublabel: 'ARRIVED',
                            color: const Color(0xFFC084FC), // Purple
                            isSelected:
                                currentStatus == ChildStatusType.arrived,
                            onTap: () => _updateStatus(ChildStatusType.arrived),
                          ),
                          _StatusCard(
                            icon: Icons.home_rounded,
                            label: context.l10n.statusBackHome,
                            sublabel: 'BACK HOME',
                            color: const Color(0xFFFF8C00), // Orange
                            isSelected: currentStatus == ChildStatusType.home,
                            onTap: () => _updateStatus(ChildStatusType.home),
                          ),
                        ],
                      ),

                      // Emergency call section — disabled until calling feature ships
                    ],
                  ),
                ),
              ),
              const _LiveShareBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String childName) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    childName.isEmpty
                        ? '👧'
                        : childName.characters.first.toUpperCase(),
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.helloCaps,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: AppTheme.textHint,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      context.l10n.childGreeting(childName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: AppTheme.surfaceVariant,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  tooltip: context.l10n.settings,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  onPressed: () => context.push('/settings'),
                  icon: const Icon(Icons.settings_rounded, size: 24),
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: isSelected ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.12) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: 0.45)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: isSelected ? 16 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(icon, color: color, size: 36),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      // Nhãn phụ tiếng Anh giúp bé làm quen từ vựng — ẩn khi
                      // app đang ở tiếng Anh để khỏi lặp chữ.
                      if (Localizations.localeOf(context).languageCode !=
                          'en') ...[
                        const SizedBox(height: 2),
                        Text(
                          sublabel,
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textHint,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bố/mẹ nhờ chia sẻ vị trí ─────────────────────────────────────────────
class _LocationRequestsBanner extends ConsumerWidget {
  const _LocationRequestsBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests =
        ref.watch(incomingLocationRequestsProvider).valueOrNull ?? const [];
    final sharing = ref.watch(liveShareProvider) != null;
    if (requests.isEmpty || sharing) return const SizedBox.shrink();

    return Column(
      children: [
        for (final r in requests)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                const Text('📍', style: TextStyle(fontSize: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.locationRequestBody(r.fromName),
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.locationRequestHint,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.dismiss,
                  icon: const Icon(Icons.close_rounded),
                  color: AppTheme.textSecondary,
                  onPressed: () async {
                    final uid = ref.read(authUidProvider).valueOrNull;
                    if (uid == null) return;
                    await ref
                        .read(locationRequestServiceProvider)
                        .dismiss(childId: uid, parentId: r.fromUid);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Nút chia sẻ vị trí trực tiếp (giống Messenger) ───────────────────────
class _LiveShareBar extends ConsumerStatefulWidget {
  const _LiveShareBar();

  @override
  ConsumerState<_LiveShareBar> createState() => _LiveShareBarState();
}

class _LiveShareBarState extends ConsumerState<_LiveShareBar> {
  Timer? _ticker;
  bool _busy = false;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Đếm ngược "còn X phút" — chỉ chạy khi đang chia sẻ.
  void _syncTicker(bool sharing) {
    if (sharing && _ticker == null) {
      _ticker = Timer.periodic(
        const Duration(seconds: 5),
        (_) => mounted ? setState(() {}) : null,
      );
    } else if (!sharing && _ticker != null) {
      _ticker!.cancel();
      _ticker = null;
    }
  }

  Future<void> _toggle() async {
    final share = ref.read(liveShareProvider.notifier);
    final user = await ref.read(currentUserProvider.future);
    if (user == null || !mounted) return;
    HapticFeedback.heavyImpact();
    // Chưa đồng ý → hỏi trước. Đồng ý xong SessionEffects sẽ xin quyền, nên dừng
    // ở đây: hai hộp thoại xin quyền cùng lúc thì geolocator báo lỗi. Bé bấm lại.
    if (!share.isSharing && ref.read(locationConsentProvider) != true) {
      await showLocationDisclosure(
        context,
        ref.read(locationConsentProvider.notifier),
      );
      return;
    }
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      if (share.isSharing) {
        await share.stop(child: user);
      } else {
        await share.start(user);
      }
    } on LiveShareException catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(switch (e.error) {
            LiveShareError.serviceDisabled => l10n.locationServiceOff,
            LiveShareError.permissionDenied => l10n.locationPermissionNeeded,
            LiveShareError.permissionForever => l10n.locationPermissionSettings,
            LiveShareError.noFix => l10n.locationNoFix,
          }),
          action: e.error == LiveShareError.permissionForever
              ? SnackBarAction(
                  label: l10n.openSettings,
                  onPressed: Geolocator.openAppSettings,
                )
              : null,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorWithMessage('$e'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final until = ref.watch(liveShareProvider);
    final linked = ref.watch(
      currentUserProvider.select(
        (u) => u.valueOrNull?.linkedParentIds.isNotEmpty ?? false,
      ),
    );
    final sharing = until != null;
    _syncTicker(sharing);
    final l10n = context.l10n;
    final color = sharing ? AppTheme.dangerColor : AppTheme.playColor;

    final String caption;
    if (sharing) {
      final secs = until.difference(DateTime.now()).inSeconds;
      caption = l10n.minutesRemaining('${(secs / 60).ceil().clamp(0, 60)}');
    } else {
      caption = linked ? l10n.liveShareHint : l10n.notLinkedYetHint;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppTheme.surfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: _busy || (!sharing && !linked) ? null : _toggle,
              icon: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      sharing
                          ? Icons.location_off_rounded
                          : Icons.share_location_rounded,
                      size: 26,
                    ),
              label: Text(sharing ? l10n.stopLiveShare : l10n.startLiveShare),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: sharing ? AppTheme.dangerColor : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
