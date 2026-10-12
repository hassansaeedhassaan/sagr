import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/core/utils/app_log.dart';

/// Sends the user's position every 30 seconds while they are checked in to an
/// event, so supervisors can see them on the live map.
///
/// It used to start at launch for everyone (even on the login screen), sent
/// no auth header and never stopped. Now it runs only for a logged-in user who
/// checked in from this device, and stops on check-out or logout.
class SmartTaskManager {
  SmartTaskManager._();
  static final SmartTaskManager _instance = SmartTaskManager._();
  factory SmartTaskManager() => _instance;

  static const String send_current_location = '/receive/current_location';

  /// Storage key holding {event_id, at} while checked in.
  static const String checkInKey = 'checked_in_event';

  // A forgotten check-out shouldn't keep tracking the user forever.
  static const Duration _maxShift = Duration(hours: 18);

  Timer? _timer;
  bool _sending = false;

  /// Starts the heartbeat if the stored session and check-in allow it.
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
    stop();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  bool _shouldRun() {
    final storage = GetStorage();
    if (storage.read('access_token') == null) return false;
    final checkIn = storage.read(checkInKey);
    if (checkIn is! Map) return false;
    final at = DateTime.tryParse('${checkIn['at']}');
    if (at == null || DateTime.now().difference(at) > _maxShift) {
      storage.remove(checkInKey);
      return false;
    }
    return true;
  }

  void _start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _tick());
  }

  Future<void> _tick() async {
    if (!_shouldRun()) {
      stop();
      return;
    }
    if (_sending) return;
    _sending = true;
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
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
          .timeout(const Duration(seconds: 20));
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
