import 'package:latlong2/latlong.dart';
import '../models/farming_location.dart';

final Distance _distance = Distance();

List<FarmingLocation> filterByRadius({
  required List<FarmingLocation> locations,
  required double userLat,
  required double userLng,
  required double radiusKm,
}) {
  return locations.where((location) {
    final km = _distance.as(
      LengthUnit.Kilometer,
      LatLng(userLat, userLng),
      LatLng(location.lat, location.lng),
    );
    return km <= radiusKm;
  }).toList();
}
