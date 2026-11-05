import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_care/core/theme/app_theme.dart';
import 'package:kids_care/core/widgets/app_map_tiles.dart';
import 'package:kids_care/core/widgets/app_top_bar.dart';
import 'package:kids_care/features/location/location_providers.dart';
import 'package:kids_care/features/auth/providers/auth_providers.dart';
import 'package:kids_care/features/link/providers/link_providers.dart';
import 'package:kids_care/features/parent/map/place_search_service.dart';
import 'package:kids_care/models/geofence_zone_model.dart';
import 'package:kids_care/models/user_model.dart';
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

  /// Vùng an toàn thuộc về bé. Bố/mẹ chọn bé (nếu có nhiều) rồi thêm/xoá;
  /// bé xem vùng của mình ở chế độ chỉ đọc.
  bool _isParent = false;
  String? _selectedChildId;
  bool get _canEdit => _isParent && _selectedChildId != null;

  LatLng? _userLocation;

  final _searchService = PlaceSearchService();
  final _searchCtrl = TextEditingController();
  Timer? _searchDebounce;
  int _searchSeq = 0;
  bool _searching = false;
  bool _searchFailed = false;
  List<PlaceResult>? _results;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goToUserLocation());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await ref.read(currentUserProvider.future);
      if (user == null || !mounted || user.role != 'parent') return;
      // Bé: vùng của mình đã được GeofenceService theo dõi realtime.
      setState(() => _isParent = true);
      ref.listenManual(
        linkedChildrenProvider,
        (_, next) => _onChildrenChanged(next.valueOrNull ?? const []),
        fireImmediately: true,
      );
    });
  }

  /// Danh sách con đổi (vừa liên kết / gỡ) → giữ bé đang chọn nếu còn.
  void _onChildrenChanged(List<UserModel> kids) {
    if (!mounted) return;
    if (kids.isEmpty) {
      setState(() => _selectedChildId = null);
      ref.read(geofenceZonesProvider.notifier).stopWatching();
    } else if (!kids.any((k) => k.uid == _selectedChildId)) {
      _selectChild(kids.first.uid);
    }
  }

  void _selectChild(String childId) {
    setState(() => _selectedChildId = childId);
    ref.read(geofenceZonesProvider.notifier).watchZones(childId);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Xin quyền vị trí rồi đưa bản đồ về chỗ người dùng đang đứng.
  Future<void> _goToUserLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (!mounted) return;
      _showLocationError(
        context.l10n.locationServiceDisabled,
        Geolocator.openLocationSettings,
      );
      return;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      _showLocationError(
        context.l10n.locationPermissionDenied,
        Geolocator.openAppSettings,
      );
      return;
    }
    // Vị trí cũ hiện ngay cho nhanh, rồi cập nhật bằng vị trí chính xác.
    final last = await Geolocator.getLastKnownPosition();
    if (last != null) _setUserLocation(last);
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _setUserLocation(pos);
    } on TimeoutException {
      // Giữ vị trí cũ (nếu có).
    }
  }

  void _setUserLocation(Position pos) {
    if (!mounted) return;
    final point = LatLng(pos.latitude, pos.longitude);
    setState(() => _userLocation = point);
    _mapController.move(point, 16);
  }

  void _showLocationError(
    String message,
    Future<bool> Function() openSettings,
  ) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: context.l10n.openSettings,
          onPressed: openSettings,
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    final q = query.trim();
    if (q.length < 3) {
      setState(() {
        _results = null;
        _searching = false;
        _searchFailed = false;
      });
      return;
    }
    // Debounce để giảm số request tính phí.
    _searchDebounce = Timer(
      const Duration(milliseconds: 500),
      () => _runSearch(q),
    );
  }

  Future<void> _runSearch(String query) async {
    final seq = ++_searchSeq;
    setState(() {
      _searching = true;
      _searchFailed = false;
    });
    try {
      final results = await _searchService.search(
        query,
        proximity: _mapController.camera.center,
        language: Localizations.localeOf(context).languageCode,
      );
      if (!mounted || seq != _searchSeq) return;
      setState(() {
        _results = results;
        _searching = false;
      });
    } catch (_) {
      if (!mounted || seq != _searchSeq) return;
      setState(() {
        _results = const [];
        _searching = false;
        _searchFailed = true;
      });
    }
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _searchSeq++;
    _searchCtrl.clear();
    setState(() {
      _results = null;
      _searching = false;
      _searchFailed = false;
    });
  }

  void _onPlaceSelected(PlaceResult place, bool atLimit) {
    FocusScope.of(context).unfocus();
    _clearSearch();
    _mapController.move(place.point, 16);
    _onLongPress(place.point, atLimit, initialName: place.name);
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

  /// Chấm vị trí gần nhất của bé (xanh lá khi đang chia sẻ trực tiếp).
  Widget _buildChildMarker(ChildLocation loc) {
    final live = loc.isLive(DateTime.now());
    final color = live ? AppTheme.playColor : AppTheme.primaryColor;
    final kids = ref.read(linkedChildrenProvider).valueOrNull ?? const [];
    final name =
        kids.where((k) => k.uid == _selectedChildId).firstOrNull?.name ?? '';
    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(loc.lat, loc.lng),
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10),
              ],
            ),
            child: Center(
              child: Text(
                name.isEmpty ? '👧' : name.characters.first.toUpperCase(),
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
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

  Future<void> _addZoneDialog(LatLng tapped, {String initialName = ''}) async {
    final nameCtrl = TextEditingController(text: initialName);
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

  void _onLongPress(LatLng point, bool atLimit, {String initialName = ''}) {
    if (!_canEdit) return;
    if (atLimit) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.zoneLimitReached)));
      return;
    }
    _addZoneDialog(point, initialName: initialName);
  }

  Widget _buildHintCard() {
    return Container(
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
          const Icon(Icons.touch_app_rounded, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _canEdit
                  ? context.l10n.mapHintParent
                  : _isParent
                  ? context.l10n.zonesNeedChild
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
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: context.l10n.searchPlaceHint,
          hintStyle: GoogleFonts.nunito(color: AppTheme.textHint),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppTheme.primaryColor,
          ),
          suffixIcon: _searchCtrl.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: AppTheme.textSecondary,
                  onPressed: _clearSearch,
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSearchResults(bool atLimit) {
    final results = _results ?? const <PlaceResult>[];
    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _searching
          ? const LinearProgressIndicator(color: AppTheme.primaryColor)
          : results.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _searchFailed
                    ? context.l10n.searchFailed
                    : context.l10n.searchNoResults,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: results.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final place = results[i];
                return ListTile(
                  leading: const Icon(
                    Icons.place_rounded,
                    color: AppTheme.primaryColor,
                  ),
                  title: Text(
                    place.name,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  subtitle: place.address.isEmpty
                      ? null
                      : Text(
                          place.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                  onTap: () => _onPlaceSelected(place, atLimit),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final zones = ref.watch(geofenceZonesProvider);
    final atLimit = zones.length >= GeofenceZonesNotifier.maxZones;
    final currentUser = ref.watch(currentUserProvider).value;
    final linkCode = currentUser?.linkCode;
    final isChild = currentUser != null && currentUser.role != 'parent';
    final kids = _isParent
        ? ref.watch(linkedChildrenProvider).valueOrNull ?? const <UserModel>[]
        : const <UserModel>[];

    // Vị trí gần nhất của bé đang chọn (bố/mẹ).
    final childLoc = _selectedChildId == null
        ? null
        : ref.watch(childLocationProvider(_selectedChildId!)).valueOrNull;

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppTopBar(
        title: isChild ? context.l10n.childMapTitle : context.l10n.menuMapTitle,
        showBack: false,
        actions: const [SettingsAction()],
      ),
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
                    const AppTileLayer(),
                    CircleLayer(circles: _buildCircles(zones)),
                    MarkerLayer(markers: _buildMarkers(zones)),
                    if (childLoc != null) _buildChildMarker(childLoc),
                    if (_userLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _userLocation!,
                            width: 22,
                            height: 22,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    // Nâng lên khi có banner mã liên kết để không bị che.
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: _isParent && linkCode != null ? 72 : 0,
                      ),
                      child: const AppMapAttribution(),
                    ),
                  ],
                ),

                // Ô tìm kiếm (bố/mẹ) + kết quả, hoặc gợi ý
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_canEdit && PlaceSearchService.isAvailable) ...[
                        _buildSearchBox(),
                        const SizedBox(height: 8),
                      ],
                      if (_results != null || _searching)
                        _buildSearchResults(atLimit)
                      else
                        _buildHintCard(),
                    ],
                  ),
                ),

                // Nút về vị trí của tôi
                Positioned(
                  right: 16,
                  bottom: (_isParent && linkCode != null ? 72 : 0) + 40,
                  child: FloatingActionButton.small(
                    heroTag: null,
                    tooltip: context.l10n.myLocation,
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryColor,
                    onPressed: _goToUserLocation,
                    child: const Icon(Icons.my_location_rounded),
                  ),
                ),

                // Link code banner — để con nhập mã liên kết
                if (_isParent && linkCode != null)
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
                if (_isParent && kids.length > 1) ...[
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final kid in kids)
                        ChoiceChip(
                          label: Text(
                            kid.name,
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          selected: kid.uid == _selectedChildId,
                          selectedColor: AppTheme.primaryColor.withValues(
                            alpha: 0.2,
                          ),
                          onSelected: (_) => _selectChild(kid.uid),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
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
                                label: context.l10n.deleteZoneSemantic(
                                  zone.name,
                                ),
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
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
            ),
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
