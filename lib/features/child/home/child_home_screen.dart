import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/models/child_status.dart';
import 'package:kids_care/models/location_event_model.dart';
import 'package:kids_care/providers/notifications_provider.dart';
import 'package:kids_care/providers/user_provider.dart';
import 'package:kids_care/providers/zego_service.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

final childBottomNavProvider = StateProvider.autoDispose<int>((ref) => 0);

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
    });
  }

  @override
  void dispose() {
    ZegoService.instance.uninit();
    super.dispose();
  }

  void _updateStatus(ChildStatusType status) {
    ref.read(childStatusProvider.notifier).updateStatus(status);

    final event = LocationEventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      childId: 'child-001',
      childName: ref.read(childNameProvider),
      eventType: LocationEventType.statusUpdate,
      zoneName: _getZoneForStatus(status),
      timestamp: DateTime.now(),
      statusLabel: status.label,
    );
    ref.read(notificationsProvider.notifier).addEvent(event);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã báo bố mẹ: ${status.label} ${status.emoji}',
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
        return 'Trường học';
      case ChildStatusType.playing:
        return 'Sân chơi';
      case ChildStatusType.home:
      case ChildStatusType.arrived:
        return 'Nhà';
      default:
        return 'Không rõ';
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Column(
                  children: [
                    Text(
                      'Hôm nay con thế nào?',
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Chọn một nút để báo cho bố mẹ biết nhé!',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
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
                          label: 'Con đi học',
                          sublabel: 'SCHOOL',
                          color: const Color(0xFFFFCA28), // Amber
                          isSelected: currentStatus == ChildStatusType.school,
                          onTap: () => _updateStatus(ChildStatusType.school),
                        ),
                        _StatusCard(
                          icon: Icons.sports_esports_rounded,
                          label: 'Con đi chơi',
                          sublabel: 'PLAY',
                          color: const Color(0xFF4ADE80), // Green
                          isSelected: currentStatus == ChildStatusType.playing,
                          onTap: () => _updateStatus(ChildStatusType.playing),
                        ),
                        _StatusCard(
                          icon: Icons.location_on_rounded,
                          label: 'Con đã tới',
                          sublabel: 'ARRIVED',
                          color: const Color(0xFFC084FC), // Purple
                          isSelected: currentStatus == ChildStatusType.arrived,
                          onTap: () => _updateStatus(ChildStatusType.arrived),
                        ),
                        _StatusCard(
                          icon: Icons.home_rounded,
                          label: 'Con đã về',
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
                            color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                          ),
                        ),
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF22C55E).withValues(alpha: 0.2),
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
                            )
                          ],
                          icon: ButtonIcon(
                            icon: const Icon(Icons.phone_rounded, color: Colors.white, size: 40),
                            backgroundColor: const Color(0xFF22C55E),
                          ),
                          iconSize: const Size(86, 86),
                          buttonSize: const Size(86, 86),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'BỐ MẸ ƠI',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF22C55E),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nhấn vào đây nếu con cần trợ giúp ngay!',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
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
      bottomNavigationBar: _buildBottomNav(),
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
                    errorBuilder: (context, error, stackTrace) => const Text('👧', style: TextStyle(fontSize: 22)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHÀO',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        color: AppTheme.textHint,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      '$childName của Bố Mẹ nha! 👋',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final selectedIndex = ref.watch(childBottomNavProvider);
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (i) {
        ref.read(childBottomNavProvider.notifier).state = i;
        if (i == 1) context.go('/map');
      },
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.textHint,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 12),
      unselectedLabelStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 12),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'Bản đồ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: 'Thông báo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          label: 'Tin nhắn',
        ),
      ],
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? Border.all(color: color, width: 2) : Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withValues(alpha: 0.6)
                  : color.withValues(alpha: 0.2),
              blurRadius: isSelected ? 16 : 0,
              offset: const Offset(0, 4),
            ),
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: color, size: 28),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppTheme.textHint,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
