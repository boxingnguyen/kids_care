import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// Dùng Mapbox khi build có `MAPBOX_ACCESS_TOKEN` (config/env.json),
/// nếu không thì rơi về tile OSM (chỉ dành cho dev, không dùng khi phát hành).
bool get _useMapbox => AppConstants.mapboxAccessToken.isNotEmpty;

const _userAgentPackageName = 'com.crosstechedu.kidscare';

/// Lớp tile nền của bản đồ.
class AppTileLayer extends StatelessWidget {
  const AppTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    if (!_useMapbox) {
      return TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: _userAgentPackageName,
      );
    }
    // Tile 512px phủ diện tích bằng 4 tile 256px → ít request tính phí hơn.
    // `{r}` = `@2x` trên màn hình mật độ cao, vẫn tính 1 request/tile.
    return TileLayer(
      urlTemplate:
          'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}{r}?access_token={accessToken}',
      additionalOptions: const {'accessToken': AppConstants.mapboxAccessToken},
      tileSize: 512,
      zoomOffset: -1,
      retinaMode: RetinaMode.isHighDensity(context),
      userAgentPackageName: _userAgentPackageName,
    );
  }
}

/// Logo Mapbox (góc trái) + ghi nguồn (góc phải), bắt buộc theo điều khoản
/// Mapbox/OSM.
/// Đặt làm phần tử cuối trong `FlutterMap.children`.
class AppMapAttribution extends StatelessWidget {
  const AppMapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_useMapbox)
          Positioned(
            left: 8,
            bottom: 8,
            child: SvgPicture.asset(
              'assets/images/mapbox_logo.svg',
              width: 88,
              semanticsLabel: 'Mapbox',
            ),
          ),
        _attributions(),
      ],
    );
  }

  Widget _attributions() {
    return RichAttributionWidget(
      attributions: [
        if (_useMapbox)
          TextSourceAttribution(
            'Mapbox',
            onTap: () => _open('https://www.mapbox.com/about/maps/'),
          ),
        TextSourceAttribution(
          'OpenStreetMap contributors',
          onTap: () => _open('https://www.openstreetmap.org/copyright'),
        ),
        if (_useMapbox)
          TextSourceAttribution(
            'Improve this map',
            prependCopyright: false,
            onTap: () => _open('https://www.mapbox.com/map-feedback/'),
          ),
      ],
    );
  }

  static void _open(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
