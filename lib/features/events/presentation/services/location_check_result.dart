import 'package:geolocator/geolocator.dart';

import '../../data/models/zone_coordinate_model.dart';

class LocationCheckResult {
  final bool isInside;
  final double distanceToZone;
  final Position currentPosition;
  final List<ZoneCoordinates> zonePoints;

  LocationCheckResult({
    required this.isInside,
    required this.distanceToZone,
    required this.currentPosition,
    required this.zonePoints,
  });
}