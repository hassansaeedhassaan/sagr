import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/core/utils/app_log.dart';

/// Sends the signed-in user's position every 15 seconds while the app is
/// open, so the admin and company dashboards can track them live.
///
/// It runs for any logged-in user (not only between check-in and check-out),
/// starts at launch or login, and stops on logout or a rejected token. The
/// check-in record is still kept for the attendance screens.
class SmartTaskManager {
  SmartTaskManager._();
  static final SmartTaskManager _instance = SmartTaskManager._();
  factory SmartTaskManager() => _instance;

  static const String send_current_location = '/receive/current_location';

  /// Storage key holding {event_id, at} while checked in.
  static const String checkInKey = 'checked_in_event';

  static const Duration interval = Duration(seconds: 15);

  Timer? _timer;
  bool _sending = false;
  bool _askedPermission = false;

  /// Starts the heartbeat if someone is logged in.
  void initialize() {
    if (_shouldRun()) _start();
  }

  void markCheckedIn(int? eventId) {
    GetStorage().write(checkInKey, {
      'event_id': eventId,
      'at': DateTime.now().toIso8601String(),
    });
    _start();
  }

  void markCheckedOut() {
    GetStorage().remove(checkInKey);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  bool _shouldRun() => GetStorage().read('access_token') != null;

  void _start() {
    if (_timer != null) return;
    _timer = Timer.periodic(interval, (_) => _tick());
    // Send one fix straight away rather than waiting a full interval.
    _tick();
  }

  Future<void> _tick() async {
    if (!_shouldRun()) {
      stop();
      return;
    }
    if (_sending) return;
    _sending = true;
    try {
      var permission = await Geolocator.checkPermission();
      // Ask once per launch; a refusal is respected until the next launch.
      if (permission == LocationPermission.denied && !_askedPermission) {
        _askedPermission = true;
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 12),
      );
      final heading = position.heading;
      final response = await http
          .post(
            Uri.parse(BASEURL + send_current_location),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${GetStorage().read('access_token')}',
            },
            body: json.encode({
              'latitude': position.latitude,
              'longitude': position.longitude,
              'accuracy': position.accuracy,
              'altitude': position.altitude,
              if (heading >= 0 && heading < 360) 'heading': heading,
              if (position.speed >= 0) 'speed': position.speed,
            }),
          )
          .timeout(const Duration(seconds: 12));
      if (response.statusCode == 401) {
        stop();
      } else if (response.statusCode != 200) {
        appLog('Location heartbeat failed: ${response.statusCode}');
      }
    } catch (e) {
      appLog('Location heartbeat error: $e');
    } finally {
      _sending = false;
    }
  }
}
