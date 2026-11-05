import 'package:flutter_test/flutter_test.dart';
import 'package:kids_care/features/parent/map/place_search_service.dart';

void main() {
  group('PlaceSearchService.parse', () {
    test('maps Search Box features to name, address and LatLng', () {
      const body = '''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {"type": "Point", "coordinates": [106.7009, 10.7769]},
      "properties": {
        "name": "Trường Tiểu học ABC",
        "full_address": "1 Lê Lợi, Quận 1, TP.HCM",
        "place_formatted": "Quận 1, TP.HCM"
      }
    },
    {
      "type": "Feature",
      "geometry": {"type": "Point", "coordinates": [105.85, 21.03]},
      "properties": {"name": "Hồ Gươm", "place_formatted": "Hà Nội"}
    }
  ]
}''';
      final results = PlaceSearchService.parse(body);

      expect(results, hasLength(2));
      expect(results[0].name, 'Trường Tiểu học ABC');
      expect(results[0].address, '1 Lê Lợi, Quận 1, TP.HCM');
      expect(results[0].point.latitude, 10.7769);
      expect(results[0].point.longitude, 106.7009);
      expect(results[1].address, 'Hà Nội');
    });

    test('returns empty list when there are no features', () {
      expect(PlaceSearchService.parse('{"features": []}'), isEmpty);
      expect(PlaceSearchService.parse('{}'), isEmpty);
    });
  });
}
