import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_back_button.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/core/widgets/child_bottom_nav.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/models/geofence_zone_model.dart';
import 'package:kids_care/providers/geofence_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:kids_care/l10n/l10n.dart';

class MapSetupScreen extends ConsumerStatefulWidget {
  const MapSetupScreen({super.key});

  @override
  ConsumerState<MapSetupScreen> createState() => _MapSetupScreenState();
}

class _MapSetupScreenState extends ConsumerState<MapSetupScreen> {
  final MapController _mapController = MapController();
  static const LatLng _defaultCenter = LatLng(10.7769, 106.7009);

  /// Chỉ bố/mẹ được thêm/xoá vùng; con xem vùng của bố/mẹ ở chế độ chỉ đọc.
  bool _canEdit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await ref.read(currentUserProvider.future);
      if (user == null || !mounted) return;
      final isParent = user.role == 'parent';
      final parentId = isParent ? user.uid : user.linkedParentId;
      setState(() => _canEdit = isParent);
      if (parentId == null) return;
      await ref.read(geofenceZonesProvider.notifier).loadZonesForParent(parentId);
    });
  }

  List<CircleMarker> _buildCircles(List<GeofenceZoneModel> zones) {
    return zones
        .map(
          (z) => CircleMarker(
            point: LatLng(z.lat, z.lng),
            radius: z.radiusMeters,
            useRadiusInMeter: true,
            color: AppTheme.primaryColor.withValues(alpha: 0.15),
            borderColor: AppTheme.primaryColor,
            borderStrokeWidth: 2,
          ),
        )
        .toList();
  }

  List<Marker> _buildMarkers(List<GeofenceZoneModel> zones) {
    return zones
        .map(
          (z) => Marker(
            point: LatLng(z.lat, z.lng),
            width: 100,
            height: 80,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(z.emoji, style: const TextStyle(fontSize: 28)),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    z.name,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Future<void> _addZoneDialog(LatLng tapped) async {
    final nameCtrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          context.l10n.addSafeZone,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        content: TextField(
          controller: nameCtrl,
          style: GoogleFonts.nunito(
            fontSize: 15,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: context.l10n.zoneNameHint,
            hintStyle: GoogleFonts.nunito(color: AppTheme.textHint),
            filled: true,
            fillColor: AppTheme.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppTheme.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: AppTheme.textHint),
            child: Text(
              context.l10n.cancel,
              style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, nameCtrl.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              context.l10n.add,
              style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        await ref
            .read(geofenceZonesProvider.notifier)
            .addZone(
              GeofenceZoneModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: result,
                lat: tapped.latitude,
                lng: tapped.longitude,
                emoji: '📍',
              ),
            );
      } on StateError catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeServiceError(context.l10n, e.message)),
            ),
          );
        }
      }
    }
  }

  void _onLongPress(LatLng point, bool atLimit) {
    if (!_canEdit) return;
    if (atLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.zoneLimitReached)),
      );
      return;
    }
    _addZoneDialog(point);
  }

  @override
  Widget build(BuildContext context) {
    final zones = ref.watch(geofenceZonesProvider);
    final atLimit = zones.length >= GeofenceZonesNotifier.maxZones;
    final currentUser = ref.watch(currentUserProvider).value;
    final linkCode = currentUser?.linkCode;
    final isChild = currentUser != null && currentUser.role != 'parent';

    return AppBackScope(
      child: Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppTopBar(
        title: isChild ? context.l10n.childMapTitle : context.l10n.menuMapTitle,
      ),
      bottomNavigationBar:
          isChild ? const ChildBottomNav(current: ChildTab.map) : null,
      body: Column(
        children: [
          // Map
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _defaultCenter,
                    initialZoom: 15,
                    onLongPress: (tapPosition, point) =>
                        _onLongPress(point, atLimit),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.kidscare',
                    ),
                    CircleLayer(circles: _buildCircles(zones)),
                    MarkerLayer(markers: _buildMarkers(zones)),
                  ],
                ),

                // Overlay tooltip
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.touch_app_rounded,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _canEdit
                                ? context.l10n.mapHintParent
                                : context.l10n.mapHintChild,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Link code banner — để con nhập mã liên kết
                if (_canEdit && linkCode != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.l10n.linkCodeLabel,
                            style: GoogleFonts.nunito(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            linkCode,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Zone list container
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              // Khi có bottom nav thì nav đã lo phần safe area.
              isChild ? 16 : 16 + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.safeZonesCount(
                    '${zones.length}',
                    '${GeofenceZonesNotifier.maxZones}',
                  ),
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                if (zones.isEmpty)
                  Text(
                    context.l10n.noSafeZones,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  )
                else
                  SizedBox(
                    height: 96,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: zones.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final zone = zones[i];
                        final card = GestureDetector(
                          onTap: () {
                            _mapController.move(LatLng(zone.lat, zone.lng), 16);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  zone.emoji,
                                  style: const TextStyle(fontSize: 26),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  zone.name,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (!_canEdit) return card;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            card,
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Semantics(
                                button: true,
                                label: context.l10n.deleteZoneSemantic(zone.name),
                                child: GestureDetector(
                                  onTap: () => _confirmRemoveZone(zone),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: AppTheme.dangerColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                if (_canEdit && atLimit)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      context.l10n.zoneLimitHint,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.dangerColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Future<void> _confirmRemoveZone(GeofenceZoneModel zone) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteZoneTitle),
        content: Text(context.l10n.deleteZoneMessage(zone.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(geofenceZonesProvider.notifier).removeZone(zone.id);
    }
  }
}
