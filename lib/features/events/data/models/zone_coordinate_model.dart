import 'dart:math' as math;
class ZoneCoordinates {
  final double latitude;
  final double longitude;
  final int order;

  ZoneCoordinates({
    
    required this.latitude,
    required this.longitude,
    required this.order,
  });

  // Factory constructor for JSON deserialization
  factory ZoneCoordinates.fromJson(Map<String, dynamic> json) {
    return ZoneCoordinates(
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      order: int.parse(json['order'].toString()),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'order': order,
    };
  }

  // Copy with method for updating specific fields
  ZoneCoordinates copyWith({
    double? latitude,
    double? longitude,
    int? order,
  }) {
    return ZoneCoordinates(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      order: order ?? this.order,
    );
  }

  // Equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZoneCoordinates &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          order == other.order;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ order.hashCode;

  // String representation
  @override
  String toString() {
    return 'ZoneCoordinates(latitude: $latitude, longitude: $longitude, order: $order)';
  }

  // Formatted string for display
  String get displayString {
    return 'Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}, Order: $order';
  }

  // Get coordinates as LatLng-like object
  Map<String, double> get coordinates {
    return {
      'lat': latitude,
      'lng': longitude,
    };
  }

  // Distance to another coordinate
  double distanceTo(ZoneCoordinates other) {
    return _calculateDistance(
      latitude, longitude,
      other.latitude, other.longitude,
    );
  }

  // Distance calculation using Haversine formula
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth's radius in meters
    
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  // Validation methods
  bool get isValidLatitude => latitude >= -90 && latitude <= 90;
  bool get isValidLongitude => longitude >= -180 && longitude <= 180;
  bool get isValid => isValidLatitude && isValidLongitude;

  // Convert to different formats
  String get dmsLatitude => _toDMS(latitude, true);
  String get dmsLongitude => _toDMS(longitude, false);

  String _toDMS(double decimal, bool isLatitude) {
    String direction = '';
    if (isLatitude) {
      direction = decimal >= 0 ? 'N' : 'S';
    } else {
      direction = decimal >= 0 ? 'E' : 'W';
    }
    
    decimal = decimal.abs();
    int degrees = decimal.floor();
    double minutesDecimal = (decimal - degrees) * 60;
    int minutes = minutesDecimal.floor();
    double seconds = (minutesDecimal - minutes) * 60;
    
    return '$degrees°${minutes.toString().padLeft(2, '0')}\'${seconds.toStringAsFixed(2)}"$direction';
  }
}

// Extension for List<ZoneCoordinates>
extension ZoneCoordinatesList on List<ZoneCoordinates> {
  // Sort by order
  List<ZoneCoordinates> get sortedByOrder {
    List<ZoneCoordinates> sorted = List.from(this);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  // Get center point
  ZoneCoordinates get centerPoint {
    if (isEmpty) throw Exception('Cannot calculate center of empty list');
    
    double avgLat = map((coord) => coord.latitude).reduce((a, b) => a + b) / length;
    double avgLng = map((coord) => coord.longitude).reduce((a, b) => a + b) / length;
    
    return ZoneCoordinates(
      latitude: avgLat,
      longitude: avgLng,
      order: -1, // Special order for center point
    );
  }

  // Get bounding box
  Map<String, double> get boundingBox {
    if (isEmpty) throw Exception('Cannot calculate bounding box of empty list');
    
    double minLat = map((coord) => coord.latitude).reduce(math.min);
    double maxLat = map((coord) => coord.latitude).reduce(math.max);
    double minLng = map((coord) => coord.longitude).reduce(math.min);
    double maxLng = map((coord) => coord.longitude).reduce(math.max);
    
    return {
      'minLatitude': minLat,
      'maxLatitude': maxLat,
      'minLongitude': minLng,
      'maxLongitude': maxLng,
    };
  }

  // Convert from JSON list
  static List<ZoneCoordinates> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ZoneCoordinates.fromJson(json)).toList();
  }

  // Convert to JSON list
  List<Map<String, dynamic>> toJsonList() {
    return map((coord) => coord.toJson()).toList();
  }
}

// Usage examples and helper methods
class ZoneCoordinatesHelper {
  // Parse your specific data format
  static List<ZoneCoordinates> parseZoneData(List<Map<String, dynamic>> data) {
    return data.map((item) => ZoneCoordinates.fromJson(item)).toList().sortedByOrder;
  }

  // Create from lat/lng pairs
  static ZoneCoordinates create(double lat, double lng, int order) {
    return ZoneCoordinates(latitude: lat, longitude: lng, order: order);
  }

  // Validate coordinate
  static bool isValidCoordinate(ZoneCoordinates coord) {
    return coord.isValid;
  }

  // Get distance between two coordinates
  static double getDistance(ZoneCoordinates coord1, ZoneCoordinates coord2) {
    return coord1.distanceTo(coord2);
  }
}
