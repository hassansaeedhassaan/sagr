import 'dart:async';
import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:sagr/helper/base_url.dart';
import 'dart:convert';

import 'package:workmanager/workmanager.dart';

class SmartTaskManager {
  Timer? _foregroundTimer;
  bool _isAppActive = true;
  // Your server endpoint
  static const String serverEndpoint = BASEURL;

  static const String send_current_location = '/receive/current_location';
  static const String get_current_users = '/current/users/live/events';

  void initialize() {
    // مهام متكررة عندما يكون التطبيق نشطاً
    _startForegroundTasks();

    // مهمة واحدة بـ WorkManager عند إغلاق التطبيق
    // _scheduleBackgroundSync();
  }

  void _startForegroundTasks() {
    _foregroundTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_isAppActive) {
        performFrequentTask();
      }
    });
  }

  void _scheduleBackgroundSync() {
    Workmanager().registerOneOffTask(
      "background_sync",
      "sync_data",
      initialDelay: Duration(minutes: 1),
    );
  }

  void onAppStateChanged(AppLifecycleState state) {
    _isAppActive = state == AppLifecycleState.resumed;

    if (!_isAppActive) {
      _foregroundTimer?.cancel();
      // جدولة مهمة خلفية عند إغلاق التطبيق
      _scheduleBackgroundSync();
    } else {
      _startForegroundTasks();
    }
  }

  void performFrequentTask() async {
   

    await _getCurrentUsersFromServer();

    print("🔥🔥🔥🔥🔥🔥");

    print("تنفيذ مهمة كل 30 ثانية" + DateTime.now().toString());
    // منطق المهمة هنا
    print("🔥🔥🔥🔥🔥🔥");
  }

  static Future<void> _sendToServer(Map<String, dynamic> locationData) async {
   
  
   try {
      final response = await http.post(
        Uri.parse(serverEndpoint + send_current_location),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Add authentication headers if needed
          // 'Authorization': 'Bearer your_token_here',
        },
        body: json.encode(locationData),
      );
      // ).timeout(const Duration(seconds: 30));


      if (response.statusCode == 200) {
        print('Location sent successfully');
      } else {
        print('Failed to send location _sendToServer: ${response.body}');
      }
    } catch (e) {
      print('Error sending location to server: $e');
    }
  }

  static Future<void> _getCurrentUsersFromServer() async {
    try {
      final AuthController authController = Get.put(AuthController());

      final response = await http.get(
        Uri.parse(serverEndpoint + get_current_users),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers if needed
          // 'Authorization': 'Bearer your_token_here',
        },
      );


      if (response.statusCode == 200) {
        print('User Fetch Success fully successfully');
        final Map<String, dynamic> response2 = jsonDecode(response.body);
        final List<dynamic> users = response2['data'];

        for (var user in users) {
          if (user['user_id'] == authController.authenticatedUser!['id']) {
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
              // 'heading': position.heading,
              'heading': 1,
              'speed': position.speed,
              'user_id': authController.authenticatedUser!['id']
            };
            await _sendToServer(locationData);
          }
        }
      } else {
        print('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location to server: $e');
    }
  }
}
