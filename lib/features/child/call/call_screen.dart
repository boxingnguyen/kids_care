import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/l10n/l10n.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _seconds = 0;
  bool _isMuted = false;
  bool _isSpeaker = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Timer
    Future.microtask(() {
      if (mounted) _startTimer();
    });
  }

  void _startTimer() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _seconds++);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _timerText {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: AppBackButton(),
              ),
            ),

            const Spacer(),

            // Avatar with pulse
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryLight,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('👨', style: TextStyle(fontSize: 64)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              context.l10n.callDad,
              style: GoogleFonts.nunito(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.connecting,
              style: GoogleFonts.nunito(
                fontSize: 15,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _timerText,
              style: GoogleFonts.nunito(
                fontSize: 20,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _CallControl(
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: _isMuted ? context.l10n.micOn : context.l10n.micOff,
                    color: _isMuted ? Colors.red : Colors.grey.shade600,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _CallControl(
                    icon: _isSpeaker
                        ? Icons.volume_up_rounded
                        : Icons.volume_down_rounded,
                    label: context.l10n.speaker,
                    color: _isSpeaker
                        ? AppTheme.primaryColor
                        : Colors.grey.shade600,
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),
                  _CallControl(
                    icon: Icons.videocam_rounded,
                    label: context.l10n.video,
                    color: Colors.grey.shade600,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // End call button
            GestureDetector(
              onTap: () => goBack(context, ref),
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.dangerColor,
                ),
                child: const Icon(
                  Icons.call_end_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.endCall,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CallControl extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CallControl({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
