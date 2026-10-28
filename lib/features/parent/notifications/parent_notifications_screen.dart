import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/models/location_event_model.dart';
import 'package:kids_care/providers/notifications_provider.dart';
import 'package:kids_care/providers/zego_service.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:kids_care/l10n/l10n.dart';

class ParentNotificationsScreen extends ConsumerStatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  ConsumerState<ParentNotificationsScreen> createState() =>
      _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState
    extends ConsumerState<ParentNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ZegoService.instance.init(
        userId: AppConstants.zegoParentUserId,
        userName: AppConstants.zegoParentUserName,
      );
    });
  }

  @override
  void dispose() {
    ZegoService.instance.uninit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(notificationsProvider);

    return AppBackScope(
      fallbackLocation: '/parent-home',
      child: Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusCard(),
                    const SizedBox(height: 20),

                    // Emergency call button
                    _EmergencyCallButton(),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Text(
                          context.l10n.recent,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          context.l10n.updatedAtToday(
                            DateFormat('HH:mm').format(DateTime.now()),
                          ),
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (events.isEmpty)
                      _EmptyState()
                    else
                      ...events.map((e) => _EventTile(event: e)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          const AppBackButton(fallbackLocation: '/parent-home'),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.notifications,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          IconButton(
            tooltip: context.l10n.map,
            onPressed: () => context.push('/map'),
            icon: const Icon(Icons.map_rounded),
            color: AppTheme.primaryColor,
          ),
          IconButton(
            tooltip: context.l10n.settings,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_rounded),
            color: AppTheme.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFAA00), Color(0xFFFF8C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.childIsNear('Gấc'),
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Khu dân cư Him Lam 🏡',
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    context.l10n.statusSafe,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Text('🗺️', style: TextStyle(fontSize: 52)),
        ],
      ),
    );
  }
}

class _EmergencyCallButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEEE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('📞', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.emergencyCallChild,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  context.l10n.voiceCallVia,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ZegoSendCallInvitationButton(
            isVideoCall: false,
            resourceID: 'zegouikit_call',
            invitees: [
              ZegoUIKitUser(
                id: AppConstants.zegoChildUserId,
                name: AppConstants.zegoChildUserName,
              ),
            ],
            icon: ButtonIcon(
              icon: const Icon(
                Icons.phone_rounded,
                color: Colors.white,
                size: 20,
              ),
              backgroundColor: AppTheme.dangerColor,
            ),
            iconSize: const Size(46, 46),
            buttonSize: const Size(54, 54),
          ),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final LocationEventModel event;

  const _EventTile({required this.event});

  Color get _iconColor {
    switch (event.eventType) {
      case LocationEventType.arrived:
        return AppTheme.playColor;
      case LocationEventType.left:
        return AppTheme.dangerColor;
      default:
        return AppTheme.primaryColor;
    }
  }


  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(event.timestamp);

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
              child: Text(
                statusCodeEmoji(event.statusLabel),
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.statusLabel == null
                      ? '${event.childName} · ${event.zoneName}'
                      : '${event.childName} · '
                            '${localizedStatusCode(context.l10n, event.statusLabel)}',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.zoneName,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeStr,
            style: GoogleFonts.nunito(
              fontSize: 12,
              color: AppTheme.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
