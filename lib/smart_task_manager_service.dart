import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sagr/core/services/precise_location.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/core/utils/app_log.dart';
import 'package:sagr/widgets/messages.dart';

/// Sends the signed-in user's position every 15 seconds while the app is
/// open, so the admin and company dashboards can track them live.
///
/// It runs for any logged-in user (not only between check-in and check-out),
/// starts at launch or login, and stops on logout or a rejected token. The
/// check-in record is still kept for the attendance screens.
///
/// While checked in, the server checks each fix against the user's zone and
/// answers with its state: leaving starts a one-minute grace period (warned
/// here and by push), and staying out checks them out automatically.
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

  /// Last zone state shown to the user: 'inside', 'outside' or
  /// 'checked_out'. The heartbeat and the push both report the same
  /// change; this keeps it to one warning.
  String _zoneState = 'inside';

  /// Starts the heartbeat if someone is logged in.
  void initialize() {
    if (_shouldRun()) _start();
  }

  void markCheckedIn(int? eventId) {
    GetStorage().write(checkInKey, {
      'event_id': eventId,
      'at': DateTime.now().toIso8601String(),
    });
    _zoneState = 'inside';
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
      final position = await PreciseLocation.current();
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
              'recorded_at': position.timestamp.toUtc().toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 12));
      if (response.statusCode == 401) {
        stop();
      } else if (response.statusCode != 200) {
        appLog('Location heartbeat failed: ${response.statusCode}');
      } else {
        final zone = json.decode(response.body)['zone'];
        if (zone is Map) _applyZoneState(zone);
      }
    } catch (e) {
      appLog('Location heartbeat error: $e');
    } finally {
      _sending = false;
    }
  }

  void _applyZoneState(Map zone) {
    switch (zone['state']) {
      case 'outside':
        onZoneEvent('zone_exit', secondsLeft: zone['seconds_left'] as int?);
        break;
      case 'checked_out':
        onZoneEvent('auto_checkout');
        break;
      default:
        _zoneState = 'inside';
    }
  }

  /// A zone change from the heartbeat or from a push ('zone_exit' or
  /// 'auto_checkout'); each is shown once.
  void onZoneEvent(String type, {int? secondsLeft}) {
    if (type == 'zone_exit') {
      if (_zoneState != 'inside') return;
      _zoneState = 'outside';
      AppNotice.warning('You left your zone'.tr, 'Go back to your event zone within @seconds seconds, or you will be checked out automatically.'
            .trParams({'seconds': '${secondsLeft ?? 60}'}));
    } else if (type == 'auto_checkout') {
      if (_zoneState == 'checked_out') return;
      _zoneState = 'checked_out';
      markCheckedOut();
      if (Get.isRegistered<EventController>()) {
        Get.find<EventController>().onAutoCheckedOut();
      }
      MessageHelper.showErrorDialog(
        title: 'Checked out automatically'.tr,
        message:
            'You stayed outside your event zone, so you were checked out. The time outside is not counted. Check in again when you are back.'
                .tr,
      );
    }
  }
}
