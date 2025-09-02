import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import '../../data/models/zone_coordinate_model.dart';
import 'location_check_result.dart';

class SagrZoneLocationService {
  // Modified to accept zonePoints as parameter
  static Future<LocationCheckResult?> checkCurrentLocationInZone({
    required List<ZoneCoordinates> zonePoints,
  }) async {
    try {
      // Get current location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions denied');
        }
      }

      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Sort points by order to ensure correct polygon shape
      List<ZoneCoordinates> sortedPoints = List.from(zonePoints)
        ..sort((a, b) => a.order.compareTo(b.order));
      
      // Check if inside polygon
      bool isInside = _isPointInPolygon(
        currentPosition.latitude,
        currentPosition.longitude,
        sortedPoints,
      );

      // Calculate distance to zone
      double distance = isInside ? 0.0 : _calculateDistanceToPolygon(
        currentPosition.latitude,
        currentPosition.longitude,
        sortedPoints,
      );

      return LocationCheckResult(
        isInside: isInside,
        distanceToZone: distance,
        currentPosition: currentPosition,
        zonePoints: sortedPoints,
      );

    } catch (e) {
      print('Error checking location: $e');
      return null;
    }
  }

  // Check if specific position is inside zone
  static bool isPositionInZone({
    required double latitude,
    required double longitude,
    required List<ZoneCoordinates> zonePoints,
  }) {
    List<ZoneCoordinates> sortedPoints = List.from(zonePoints)
      ..sort((a, b) => a.order.compareTo(b.order));
    
    return _isPointInPolygon(latitude, longitude, sortedPoints);
  }

  // Calculate distance from specific position to zone
  static double calculateDistanceToZone({
    required double latitude,
    required double longitude,
    required List<ZoneCoordinates> zonePoints,
  }) {
    List<ZoneCoordinates> sortedPoints = List.from(zonePoints)
      ..sort((a, b) => a.order.compareTo(b.order));
    
    bool isInside = _isPointInPolygon(latitude, longitude, sortedPoints);
    
    return isInside ? 0.0 : _calculateDistanceToPolygon(
      latitude,
      longitude,
      sortedPoints,
    );
  }

  // Get zone center point
  static Map<String, double> getZoneCenter(List<ZoneCoordinates> zonePoints) {
    if (zonePoints.isEmpty) {
      throw ArgumentError('Zone points list cannot be empty');
    }
    
    double avgLat = zonePoints.map((p) => p.latitude).reduce((a, b) => a + b) / zonePoints.length;
    double avgLng = zonePoints.map((p) => p.longitude).reduce((a, b) => a + b) / zonePoints.length;
    
    return {'latitude': avgLat, 'longitude': avgLng};
  }

  // Get zone bounding box
  static Map<String, double> getZoneBounds(List<ZoneCoordinates> zonePoints) {
    if (zonePoints.isEmpty) {
      throw ArgumentError('Zone points list cannot be empty');
    }

    double minLat = zonePoints.map((p) => p.latitude).reduce(math.min);
    double maxLat = zonePoints.map((p) => p.latitude).reduce(math.max);
    double minLng = zonePoints.map((p) => p.longitude).reduce(math.min);
    double maxLng = zonePoints.map((p) => p.longitude).reduce(math.max);
    
    return {
      'minLatitude': minLat,
      'maxLatitude': maxLat,
      'minLongitude': minLng,
      'maxLongitude': maxLng,
    };
  }

  // Point-in-polygon algorithm (Ray casting)
  static bool _isPointInPolygon(double lat, double lng, List<ZoneCoordinates> polygon) {
    int intersections = 0;
    
    for (int i = 0; i < polygon.length; i++) {
      int j = (i + 1) % polygon.length;
      
      if (_rayIntersectsSegment(
        lat, lng,
        polygon[i].latitude, polygon[i].longitude,
        polygon[j].latitude, polygon[j].longitude,
      )) {
        intersections++;
      }
    }
    
    return intersections % 2 == 1;
  }

  // Ray casting helper
  static bool _rayIntersectsSegment(
    double px, double py,
    double ax, double ay,
    double bx, double by,
  ) {
    if (ay > py == by > py) return false;
    
    double intersectionX = (bx - ax) * (py - ay) / (by - ay) + ax;
    return px < intersectionX;
  }

  // Calculate distance to polygon (minimum distance to any edge)
  static double _calculateDistanceToPolygon(
    double lat, double lng, List<ZoneCoordinates> polygon,
  ) {
    double minDistance = double.infinity;

    for (int i = 0; i < polygon.length; i++) {
      int j = (i + 1) % polygon.length;
      
      double distance = _distanceToLineSegment(
        lat, lng,
        polygon[i].latitude, polygon[i].longitude,
        polygon[j].latitude, polygon[j].longitude,
      );
      
      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

  // Distance from point to line segment
  static double _distanceToLineSegment(
    double px, double py,
    double ax, double ay,
    double bx, double by,
  ) {
    double A = px - ax;
    double B = py - ay;
    double C = bx - ax;
    double D = by - ay;

    double dot = A * C + B * D;
    double lenSq = C * C + D * D;
    
    if (lenSq == 0) {
      // Line segment is actually a point
      return Geolocator.distanceBetween(px, py, ax, ay);
    }

    double param = dot / lenSq;

    double xx, yy;

    if (param < 0) {
      xx = ax;
      yy = ay;
    } else if (param > 1) {
      xx = bx;
      yy = by;
    } else {
      xx = ax + param * C;
      yy = ay + param * D;
    }

    return Geolocator.distanceBetween(px, py, xx, yy);
  }
}
