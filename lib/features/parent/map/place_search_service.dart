import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kids_care/core/constants/app_constants.dart';
import 'package:latlong2/latlong.dart';

class PlaceResult {
  final String name;
  final String address;
  final LatLng point;

  const PlaceResult({
    required this.name,
    required this.address,
    required this.point,
  });
}

/// Tìm địa điểm qua Mapbox Search Box API `/forward` (có cả POI như
/// trường học, công viên). Tính phí theo request — gọi có debounce.
class PlaceSearchService {
  final http.Client _client;

  PlaceSearchService({http.Client? client}) : _client = client ?? http.Client();

  static bool get isAvailable => AppConstants.mapboxAccessToken.isNotEmpty;

  Future<List<PlaceResult>> search(
    String query, {
    LatLng? proximity,
    String? language,
  }) async {
    final uri = Uri.https('api.mapbox.com', '/search/searchbox/v1/forward', {
      'q': query,
      'access_token': AppConstants.mapboxAccessToken,
      'limit': '6',
      'language': ?language,
      if (proximity != null)
        'proximity': '${proximity.longitude},${proximity.latitude}',
    });
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw http.ClientException('Search failed (${res.statusCode})', uri);
    }
    return parse(res.body);
  }

  static List<PlaceResult> parse(String body) {
    final features =
        (jsonDecode(body) as Map<String, dynamic>)['features'] as List? ?? [];
    return features.map((f) {
      final props = f['properties'] as Map<String, dynamic>? ?? {};
      final coords = f['geometry']['coordinates'] as List;
      return PlaceResult(
        name: props['name'] as String? ?? '',
        address:
            (props['full_address'] ?? props['place_formatted']) as String? ??
            '',
        point: LatLng(
          (coords[1] as num).toDouble(),
          (coords[0] as num).toDouble(),
        ),
      );
    }).toList();
  }
}
