import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/child_bottom_nav.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/geofence/geofence_service.dart';
import 'package:kids_care/models/child_status.dart';
import 'package:kids_care/models/location_event_model.dart';
import 'package:kids_care/providers/geofence_provider.dart';
import 'package:kids_care/providers/notifications_provider.dart';
import 'package:kids_care/providers/user_provider.dart';
import 'package:kids_care/providers/zego_service.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:kids_care/l10n/l10n.dart';

class ChildHomeScreen extends ConsumerStatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  ConsumerState<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends ConsumerState<ChildHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ZegoService.instance.init(
        userId: AppConstants.zegoChildUserId,
        userName: AppConstants.zegoChildUserName,
      );
      _startGeofencing();
    });
  }

  Future<void> _startGeofencing() async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null || !mounted) return;
    await GeofenceService.instance.start(
      parentId: user.linkedParentId,
      childUid: user.uid,
      childName: user.name,
      zonesNotifier: ref.read(geofenceZonesProvider.notifier),
    );
  }

  @override
  void dispose() {
    ZegoService.instance.uninit();
    super.dispose();
  }

  void _updateStatus(ChildStatusType status) {
    HapticFeedback.mediumImpact();
    ref.read(childStatusProvider.notifier).updateStatus(status);

    final event = LocationEventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: 'child-001',
      childName: ref.read(childNameProvider),
      eventType: LocationEventType.statusUpdate,
      zoneName: _getZoneForStatus(status),
      timestamp: DateTime.now(),
      statusLabel: status.name,
    );
    ref.read(notificationsProvider.notifier).addEvent(event);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.toldParents(
            '${status.localizedLabel(context.l10n)} ${status.emoji}',
          ),
          style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
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

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(childName),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                child: Column(
                  children: [
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
                          isSelected: currentStatus == ChildStatusType.playing,
                          onTap: () => _updateStatus(ChildStatusType.playing),
                        ),
                        _StatusCard(
                          icon: Icons.location_on_rounded,
                          label: context.l10n.statusArrived,
                          sublabel: 'ARRIVED',
                          color: const Color(0xFFC084FC), // Purple
                          isSelected: currentStatus == ChildStatusType.arrived,
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

                    const SizedBox(height: 40),

                    // Emergency call section
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow rings
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF22C55E,
                            ).withValues(alpha: 0.1),
                          ),
                        ),
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF22C55E,
                            ).withValues(alpha: 0.2),
                          ),
                        ),
                        // Actual button
                        ZegoSendCallInvitationButton(
                          isVideoCall: false,
                          resourceID: 'zegouikit_call',
                          invitees: [
                            ZegoUIKitUser(
                              id: AppConstants.zegoParentUserId,
                              name: AppConstants.zegoParentUserName,
                            ),
                          ],
                          icon: ButtonIcon(
                            icon: const Icon(
                              Icons.phone_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                            backgroundColor: const Color(0xFF22C55E),
                          ),
                          iconSize: const Size(86, 86),
                          buttonSize: const Size(86, 86),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.callParents,
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF22C55E),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.callParentsHint,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ChildBottomNav(current: ChildTab.home),
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
                  child: Image.network(
                    'https://api.dicebear.com/7.x/notionists/png?seed=$childName',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text('👧', style: TextStyle(fontSize: 22)),
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
