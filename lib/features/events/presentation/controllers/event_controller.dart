import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sagr/features/events/data/models/event_model.dart';
import 'package:sagr/features/events/data/models/zone_coordinate_model.dart';
import 'package:sagr/features/events/domain/usecases/get_events.dart';
import 'package:get/get.dart';
import 'package:sagr/features/events/presentation/controllers/zone_controller.dart';
import 'package:sagr/features/events/presentation/services/sagr_zone_location_service.dart';
import 'package:sagr/features/evocations/data/models/evocation_model.dart';

import '../../../../widgets/messages.dart';
import '../screens/attendance_departure_screen.dart';
import '../services/location_check_result.dart';

enum AttendanceStatus { notCheckedIn, checkedIn, loading, error }

class EventController extends GetxController {
  final EventsUsecase eventsUsecase;

  EventController(this.eventsUsecase);

  // Event Model
  EventModel? eventModel;

  // Reactive Variables
  final RxBool _isLoading = false.obs;
  final RxBool _isCheckedIn = false.obs;
  final Rx<AttendanceStatus> _attendanceStatus = AttendanceStatus.notCheckedIn.obs;
  final RxString _statusMessage = ''.obs;
  final RxDouble _distanceToZone = 0.0.obs;
  final RxBool _isLocationLoading = false.obs;
  final RxString _lastUpdateTime = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isCheckedIn => _isCheckedIn.value;
  bool get isLocationLoading => _isLocationLoading.value;
  AttendanceStatus get attendanceStatus => _attendanceStatus.value;
  String get statusMessage => _statusMessage.value;
  double get distanceToZone => _distanceToZone.value;
  String get lastUpdateTime => _lastUpdateTime.value;
  EventModel? get event => eventModel;

  @override
  void onInit() {
    super.onInit();
    _initializeEventData();
  }

  // Initialize event data
  Future<void> _initializeEventData() async {
    try {
      await getEventInfo();
      _checkUserIsCheckedInOut();
      _updateLastUpdateTime();
    } catch (e) {
      _handleError('Failed to initialize event data: $e');
    }
  }

  // Check user check-in status
  void _checkUserIsCheckedInOut() {
    if (event?.isCheckedIn != null) {
      _isCheckedIn.value = event!.isCheckedIn!;
      _attendanceStatus.value = event!.isCheckedIn! 
          ? AttendanceStatus.checkedIn 
          : AttendanceStatus.notCheckedIn;
      _updateStatusMessage();
    }
  }

  // Update status message based on current state
  void _updateStatusMessage() {
    switch (_attendanceStatus.value) {
      case AttendanceStatus.notCheckedIn:
        _statusMessage.value = 'Ready to check in';
        break;
      case AttendanceStatus.checkedIn:
        _statusMessage.value = 'Currently checked in';
        break;
      case AttendanceStatus.loading:
        _statusMessage.value = 'Processing...';
        break;
      case AttendanceStatus.error:
        _statusMessage.value = 'Error occurred';
        break;
    }
  }

  // Update last update time
  void _updateLastUpdateTime() {
    _lastUpdateTime.value = DateTime.now().toIso8601String();
  }

  // Enhanced attendance check in/out
  Future<void> attendanceCheckInOut(String type) async {
    if (_isLoading.value) return; // Prevent multiple calls

    _setLoadingState(true);
    
    try {
      await _performAttendanceAction(type);
    } catch (e) {
      _handleError('Attendance action failed: $e');
    } finally {
      _setLoadingState(false);
    }
  }

  // Set loading state with UI updates
  void _setLoadingState(bool loading) {
    _isLoading.value = loading;
    if (loading) {
      _attendanceStatus.value = AttendanceStatus.loading;
    }
    _updateStatusMessage();
    update();
  }

  // Handle errors consistently
  void _handleError(String error) {
    _attendanceStatus.value = AttendanceStatus.error;
    _updateStatusMessage();
    if (kDebugMode) {
      print('EventController Error: $error');
    }
  }

  // Get event information
  Future<void> getEventInfo() async {
    _isLoading.value = true;

    try {
      final failureOrProduct = await eventsUsecase.getEventDetails(Get.arguments);

      await failureOrProduct.fold(
        (failure) async {
          _handleError('Failed to get event info: ${failure.toString()}');
        }, 
        (receivedEvent) async {
          eventModel = receivedEvent;
          _updateLastUpdateTime();
        }
      );
    } catch (e) {
      _handleError('Exception in getEventInfo: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Enhanced location checking with better feedback
  Future<LocationCheckResult?> checkCurrentLocation(
      List<ZoneCoordinates> zonePoints) async {
    if (zonePoints.isEmpty) {
      throw Exception('No zone points available');
    }

    _isLocationLoading.value = true;
    
    try {
      final result = await SagrZoneLocationService.checkCurrentLocationInZone(
        zonePoints: zonePoints,
      );
      
      if (result != null) {
        _distanceToZone.value = result.distanceToZone;
      }
      
      return result;
    } finally {
      _isLocationLoading.value = false;
    }
  }

  // Check if position is in zone
  bool isPositionInZone(
      double latitude, double longitude, List<ZoneCoordinates> zonePoints) {
    if (zonePoints.isEmpty) {
      throw Exception('No zone points available');
    }

    return SagrZoneLocationService.isPositionInZone(
      latitude: latitude,
      longitude: longitude,
      zonePoints: zonePoints,
    );
  }

  // Enhanced attendance method with better error handling
  Future<void> _performAttendanceAction(String type) async {
    // Get current position
    Position? position = await SagrLocationService.getCurrentLocation();

    if (position == null) {
      MessageHelper.showErrorDialog(
        title: 'Location Error'.tr,
        message: 'Unable to get your current location. Please check your GPS settings and permissions.'.tr,
      );
      return;
    }

    // Prepare request body
    final Map<String, dynamic> body = {
      'event_id': event?.id,
      'zone_id': event?.zone_id,
      'user_id': event?.user_id,
      'type': type,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      // Check location if zone coordinates are available
      if (event?.zoneCoordinates != null && event!.zoneCoordinates!.isNotEmpty) {
        final locationResult = await checkCurrentLocation(event!.zoneCoordinates!);
        
        if (locationResult?.isInside == true) {
          final distance = locationResult?.distanceToZone ?? 0;
          MessageHelper.showErrorDialog(
            title: 'Location Restricted'.tr,
            message: 'You are outside the event zone. You need to be ${distance.toStringAsFixed(0)}m closer to check in.'.tr,
          );
          return;
        }
      }

      // Perform attendance API call
      final failureOrResponse = await eventsUsecase.attendanceAndDeparture(body);

      await failureOrResponse.fold(
        (failure) async {
          _handleAttendanceFailure(failure);
        }, 
        (response) async {
          _handleAttendanceSuccess(response, type);
        }
      );

    } catch (e) {
      _handleError('Attendance processing error: $e');
      MessageHelper.showErrorDialog(
        title: 'Error'.tr,
        message: 'An unexpected error occurred. Please try again.'.tr,
      );
    }
  }

  // Handle attendance failure
  void _handleAttendanceFailure(dynamic failure) {
    _attendanceStatus.value = AttendanceStatus.error;
    MessageHelper.showErrorDialog(
      title: 'Request Failed'.tr,
      message: 'Unable to process your attendance request. Please try again.'.tr,
    );
  }

  // Handle attendance success
  void _handleAttendanceSuccess(dynamic response, String type) {
    if (response.data?['success'] == true) {
      // Update check-in status
      final wasCheckingIn = type == 'attendance';
      _isCheckedIn.value = wasCheckingIn;
      _attendanceStatus.value = wasCheckingIn 
          ? AttendanceStatus.checkedIn 
          : AttendanceStatus.notCheckedIn;
      
      _updateLastUpdateTime();
      _updateStatusMessage();

      // Show success message
      MessageHelper.showSuccessDialog(
        title: 'Success'.tr,
        message: wasCheckingIn 
            ? 'Successfully checked in! 🎉'.tr 
            : 'Successfully checked out! 👋'.tr,
      );

      // Update event model
      if (eventModel != null) {
        // eventModel!.isCheckedIn = wasCheckingIn;
      }
    } else {
      _handleAttendanceFailure('Server returned unsuccessful response');
    }
  }

  // Create evocation with enhanced error handling
  Future<void> createEvocation(EvocationModel evocation) async {
    _isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        'event_id': event?.id,
        'zone_id': event?.zone_id,
        'user_id': event?.user_id,
        'notes': evocation.notes,
        'duration': evocation.duration,
        'type': evocation.type == EvocationType.prayer ? 'prayer' : 'food',
        'timestamp': DateTime.now().toIso8601String(),
      };

      if (kDebugMode) {
        print('Creating evocation with body: $body');
      }

      // Add your evocation creation logic here
      // final result = await evocationsUsecase.createEvocation(body);
      
    } catch (e) {
      _handleError('Failed to create evocation: $e');
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  // Refresh event data
  Future<void> refreshEventData() async {
    await getEventInfo();
    _checkUserIsCheckedInOut();
  }

  // Get formatted event start time
  String getFormattedEventTime() {
    // if (event?.startDateTime != null) {
    //   try {
    //     final DateTime startTime = DateTime.parse(event!.startDateTime!);
    //     final String formattedTime = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    //     return formattedTime;
    //   } catch (e) {
    //     if (kDebugMode) {
    //       print('Error formatting time: $e');
    //     }
    //   }
    // }
    return DateTime.now().toString().substring(11, 16); // Current time as fallback
  }

  // Check if user can perform attendance action
  bool canPerformAttendanceAction() {
    return !_isLoading.value && event != null;
  }

  // Get attendance button text
  String getAttendanceButtonText() {
    if (_isLoading.value) return 'Processing...'.tr;
    return _isCheckedIn.value ? 'Check Out'.tr : 'Check In'.tr;
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}