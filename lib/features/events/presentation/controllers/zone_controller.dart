import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

import 'package:sagr/features/events/data/models/zone_coordinate_model.dart';

import '../services/location_check_result.dart';

// Zone point model
class ZonePoint {
  final String id;
  final String zoneId;
  final double latitude;
  final double longitude;
  final int order;

  ZonePoint({
    required this.id,
    required this.zoneId,
    required this.latitude,
    required this.longitude,
    required this.order,
  });

  factory ZonePoint.fromJson(Map<String, dynamic> json) {
    return ZonePoint(
      id: json['id'].toString(),
      zoneId: json['zone_id'].toString(),
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      order: int.parse(json['order'].toString()),
    );
  }
}



class ZoneLocationService {
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

// Controller class to manage zone data
class ZoneController {
  List<ZoneCoordinates> _zonePoints = [];
  
  // Getters
  List<ZoneCoordinates> get zonePoints => List.unmodifiable(_zonePoints);
  bool get hasZonePoints => _zonePoints.isNotEmpty;
  
  // Load zone points from JSON data
  void loadZonePointsFromJson(List<Map<String, dynamic>> jsonData) {
    _zonePoints = jsonData
        .map((data) => ZoneCoordinates.fromJson(data))
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }
  
  // Add single zone point
  void addZonePoint(ZoneCoordinates point) {
    _zonePoints.add(point);
    _zonePoints.sort((a, b) => a.order.compareTo(b.order));
  }
  
  // Clear zone points
  void clearZonePoints() {
    _zonePoints.clear();
  }
  
  // Update zone points
  void updateZonePoints(List<ZoneCoordinates> newPoints) {
    _zonePoints = List.from(newPoints)
      ..sort((a, b) => a.order.compareTo(b.order));
  }
  
  // Check current location using loaded zone points
  Future<LocationCheckResult?> checkCurrentLocation() async {
    if (_zonePoints.isEmpty) {
      throw Exception('No zone points loaded');
    }
    
    return await ZoneLocationService.checkCurrentLocationInZone(
      zonePoints: _zonePoints,
    );
  }
  
  // Check specific position
  bool isPositionInZone(double latitude, double longitude) {
    if (_zonePoints.isEmpty) {
      throw Exception('No zone points loaded');
    }
    
    return ZoneLocationService.isPositionInZone(
      latitude: latitude,
      longitude: longitude,
      zonePoints: _zonePoints,
    );
  }
  
  // Get distance from specific position to zone
  double getDistanceToZone(double latitude, double longitude, coordinates) {
    if (coordinates.isEmpty) {
      throw Exception('No zone points loaded');
    }
    
    return ZoneLocationService.calculateDistanceToZone(
      latitude: latitude,
      longitude: longitude,
      zonePoints: coordinates,
    );
  }
  
  // Get zone info
  Map<String, double> getZoneCenter() {
    if (_zonePoints.isEmpty) {
      throw Exception('No zone points loaded');
    }
    
    return ZoneLocationService.getZoneCenter(_zonePoints);
  }
  
  Map<String, double> getZoneBounds() {
    if (_zonePoints.isEmpty) {
      throw Exception('No zone points loaded');
    }
    
    return ZoneLocationService.getZoneBounds(_zonePoints);
  }
}

// Example usage screen with controller
class ZoneLocationChecker extends StatefulWidget {
  final List<Map<String, dynamic>>? initialZoneData;
  
  const ZoneLocationChecker({Key? key, this.initialZoneData}) : super(key: key);

  @override
  State<ZoneLocationChecker> createState() => _ZoneLocationCheckerState();
}

class _ZoneLocationCheckerState extends State<ZoneLocationChecker> {
  final ZoneController _zoneController = ZoneController();
  LocationCheckResult? _result;
  bool _isLoading = false;
  String _status = 'Ready to check location';

  @override
  void initState() {
    super.initState();
    _loadZoneData();
  }

  void _loadZoneData() {
    // Load from initial data or default data
    List<Map<String, dynamic>> zoneData = widget.initialZoneData ?? [
      {"id":"1","zone_id":"2","latitude":"30.99837673","longitude":"31.36143810","order":"0"},
      {"id":"2","zone_id":"2","latitude":"30.99827556","longitude":"31.36119134","order":"1"},
      {"id":"3","zone_id":"2","latitude":"30.99807324","longitude":"31.36151320","order":"2"},
      {"id":"4","zone_id":"2","latitude":"30.99753064","longitude":"31.36053688","order":"3"},
      {"id":"5","zone_id":"2","latitude":"30.99764100","longitude":"31.36039740","order":"4"},
      {"id":"6","zone_id":"2","latitude":"30.99817440","longitude":"31.36112696","order":"5"},
      {"id":"7","zone_id":"2","latitude":"30.99840432","longitude":"31.36083728","order":"6"},
      {"id":"8","zone_id":"2","latitude":"30.99846869","longitude":"31.36078364","order":"7"},
      {"id":"9","zone_id":"2","latitude":"30.99874459","longitude":"31.36137373","order":"8"},
      {"id":"10","zone_id":"2","latitude":"30.99879977","longitude":"31.36148101","order":"9"},
      {"id":"11","zone_id":"2","latitude":"30.99856985","longitude":"31.36172778","order":"10"},
    ];
    
    _zoneController.loadZonePointsFromJson(zoneData);
  }

  Future<void> _checkLocation() async {
    if (!_zoneController.hasZonePoints) {
      setState(() {
        _status = 'No zone points loaded';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Checking location...';
    });

    try {
      LocationCheckResult? result = await _zoneController.checkCurrentLocation();
      
      if (result != null) {
        setState(() {
          _result = result;
          _status = result.isInside 
              ? 'You are INSIDE the zone!' 
              : 'You are OUTSIDE the zone';
        });
      } else {
        setState(() {
          _status = 'Failed to get location';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zone Location Checker'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Zone info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loaded Zone Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Zone Points: ${_zoneController.zonePoints.length}'),
                    if (_zoneController.hasZonePoints) ...[
                      Text('Zone ID: ${_zoneController.zonePoints.first}'),
                      Builder(
                        builder: (context) {
                          try {
                            Map<String, double> center = _zoneController.getZoneCenter();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Center: ${center['latitude']!.toStringAsFixed(6)}, ${center['longitude']!.toStringAsFixed(6)}'),
                              ],
                            );
                          } catch (e) {
                            return Text('Center: Unable to calculate');
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Status card
            Card(
              color: _result?.isInside == true ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _result?.isInside == true ? Icons.check_circle : Icons.location_off,
                      size: 60,
                      color: _result?.isInside == true ? Colors.green : Colors.red,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _status,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Location details
            if (_result != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Details',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Current Latitude: ${_result!.currentPosition.latitude.toStringAsFixed(8)}'),
                      Text('Current Longitude: ${_result!.currentPosition.longitude.toStringAsFixed(8)}'),
                      Text('Accuracy: ${_result!.currentPosition.accuracy.toStringAsFixed(2)} meters'),
                      SizedBox(height: 10),
                      Text(
                        _result!.isInside 
                            ? 'Status: Inside Zone'
                            : 'Distance to Zone: ${_result!.distanceToZone.toStringAsFixed(2)} meters',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _result!.isInside ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            Spacer(),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _checkLocation,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Check Location'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Example: Load new zone data
                      _loadZoneData();
                      setState(() {
                        _status = 'Zone data reloaded';
                      });
                    },
                    child: Text('Reload Zone'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Usage examples:

// 1. Controller with API data
class ApiZoneController {
  final ZoneController _zoneController = ZoneController();
  
  // Load from API
  Future<void> loadZoneFromApi(String zoneId) async {
    try {
      // Your API call here
      List<Map<String, dynamic>> apiData = await fetchZoneDataFromApi(zoneId);
      _zoneController.loadZonePointsFromJson(apiData);
    } catch (e) {
      print('Error loading zone from API: $e');
    }
  }
  
  // Mock API call
  Future<List<Map<String, dynamic>>> fetchZoneDataFromApi(String zoneId) async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 1));
    
    // Return your zone data
    return [
      {"id":"1","zone_id":zoneId,"latitude":"30.99837673","longitude":"31.36143810","order":"0"},
      // ... rest of your data
    ];
  }
  
  Future<LocationCheckResult?> checkLocation() async {
    return await _zoneController.checkCurrentLocation();
  }
}

// 2. Quick usage functions
class QuickZoneChecker {
  // Check with provided zone points
  static Future<bool> isCurrentLocationInZone(List<ZoneCoordinates> zonePoints) async {
    LocationCheckResult? result = await ZoneLocationService.checkCurrentLocationInZone(
      zonePoints: zonePoints,
    );
    return result?.isInside ?? false;
  }
  
  // Get distance with provided zone points
  static Future<double?> getDistanceToZone(List<ZoneCoordinates> zonePoints) async {
    LocationCheckResult? result = await ZoneLocationService.checkCurrentLocationInZone(
      zonePoints: zonePoints,
    );
    return result?.distanceToZone;
  }
}