import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String _trackingKey = 'location_tracking_enabled';
  static const String _taskName = 'locationUpdateTask';

  // Your server endpoint
  static const String serverEndpoint = 'https://sagr.libraryrajab.com/api/v1';

  static const String send_current_location = '/receive/current_location';
  static const String get_current_users = '/current/users/live/events';

  Future<bool> requestPermissions() async {
    // Request location permission
    var locationPermission = await Permission.location.request();

    // Request background location permission (Android)
    var backgroundLocationPermission =
        await Permission.locationAlways.request();

    return locationPermission.isGranted &&
        backgroundLocationPermission.isGranted;
  }

  Future<bool> startLocationTracking() async {
    // Check and request permissions
    if (!await requestPermissions()) {
      return false;
    }

    // Enable location services check
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Save tracking state
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_trackingKey, true);

    // Register periodic task
    await Workmanager().registerOneOffTask(
      "chained-task-${DateTime.now().millisecondsSinceEpoch}",
      "chained-task-${DateTime.now().millisecondsSinceEpoch}",
      // frequency: const Duration(seconds: 20),
      initialDelay: Duration(seconds: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    return true;
  }

  Future<void> stopLocationTracking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_trackingKey, false);

    await Workmanager().cancelByUniqueName(_taskName);
  }

  Future<bool> isTrackingEnabled() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getBool(_trackingKey) ?? false;
    return true;
  }

  static Future<void> sendLocationUpdate() async {
    print("🔥🔥🔥🔥🔥🔥🔥");
    print("00990099SSSS");
    print("🔥🔥🔥🔥🔥🔥🔥");
    try {
      // Check if tracking is still enabled
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool trackingEnabled = prefs.getBool(_trackingKey) ?? false;

      print("🔥🔥🔥🔥🔥🔥🔥");
      print("00990099");
      print("🔥🔥🔥🔥🔥🔥🔥");
      if (!trackingEnabled) return;

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      // Prepare location data
      Map<String, dynamic> locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'timestamp': DateTime.now().toIso8601String(),
        'altitude': position.altitude,
        'heading': position.heading,
        'speed': position.speed,
      };

      print("🔥🔥🔥🔥🔥🔥🔥");
      print(locationData);
      print("🔥🔥🔥🔥🔥🔥🔥");

      await _getCurrentUsersFromServer();
      // Send to server
      await _sendToServer(locationData);

      // Save last update time
      await prefs.setString(
          'last_location_update', DateTime.now().toIso8601String());
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  static Future<void> _sendToServer(Map<String, dynamic> locationData) async {
    try {
      final response = await http.post(
        Uri.parse(serverEndpoint + send_current_location),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers if needed
          // 'Authorization': 'Bearer your_token_here',
        },
        body: json.encode(locationData),
      );
      // ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        print('Location sent successfully');
      } else {
        print('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location to server: $e');
    }
  }

  static Future<void> _getCurrentUsersFromServer() async {
    try {
      final response = await http.get(
        Uri.parse(serverEndpoint + get_current_users),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers if needed
          // 'Authorization': 'Bearer your_token_here',
        },
      );
      // ).timeout(const Duration(seconds: 30));

      print("🔥🛑🔥");
      print(response.toString());
      print("🔥🛑🔥");

      if (response.statusCode == 200) {
        print('User Fetch Success fully successfully');
      } else {
        print('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location to server: $e');
    }
  }
}
