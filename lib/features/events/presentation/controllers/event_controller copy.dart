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

class EventController extends GetxController {
  final EventsUsecase eventsUsecase;

  EventController(this.eventsUsecase);

  /// Rx Filters  Setter

  EventModel? eventModel;

  /// Products Loading - Setter
  final RxBool _isLoading = false.obs;
  final RxBool _isCheckedIn = false.obs;

  /// List of products - Getter
  bool get isLoading => _isLoading.value;

  bool get isCheckedIn => _isCheckedIn.value;

  EventModel? get event => eventModel;

  @override
  void onInit() {
    super.onInit();

    // Get Product Info And set main image.
    getEventInfo().then((value) {
      // _productImage.value = product!.image!;
      _checkUserIsCheckedInOut();
    });

  }


  void _checkUserIsCheckedInOut() {
     _isCheckedIn.value = event!.isCheckedIn!;

  }
 
  Future<void> attendanceCheckInOut(check) async {

   
   
    await attendance(type:  check );
  
    update();
  }

  Future<void> getEventInfo() async {
    
    _isLoading.value = true;

    final failureOrProduct = await eventsUsecase.getEventDetails(Get.arguments);

    failureOrProduct.fold((failure) {
      _isLoading.value = false;
    }, (receivedProduct) async {
      // receivedProduct.images!
      //     .add({"id": 0, "file": receivedProduct.image, "type": "image"});

      eventModel = receivedProduct;

      // generateVideoThumb(receivedProduct);

      _isLoading.value = false;

      update();
    });
  }

  // Check current location using loaded zone points
  Future<LocationCheckResult?> checkCurrentLocation(
      List<ZoneCoordinates> zonePoints) async {
    if (zonePoints.isEmpty) {
      throw Exception('No zone points loaded');
    }

    return await SagrZoneLocationService.checkCurrentLocationInZone(
      zonePoints: zonePoints,
    );
  }

  // Check specific position
  bool isPositionInZone(
      double latitude, double longitude, List<ZoneCoordinates> zonePoints) {
    if (zonePoints.isEmpty) {
      throw Exception('No zone points loaded');
    }

    return SagrZoneLocationService.isPositionInZone(
      latitude: latitude,
      longitude: longitude,
      zonePoints: zonePoints,
    );
  }

  Future<void> attendance({required String type}) async {
    _isLoading.value = true;
    Position? position = await SagrLocationService.getCurrentLocation();

    // Get.to(() => ZoneLocationChecker());

    final Map<String, dynamic> body = {
      'event_id': event?.id,
      'zone_id': event?.zone_id,
      'user_id': event?.user_id,
      'type': type
    };

    if (position != null) {
      final currentLocation =
          await checkCurrentLocation(event!.zoneCoordinates!);

      if (currentLocation?.isInside == true) {
        MessageHelper.showErrorDialog(
          title: 'غير مصرح',
          message:
              'لا يمكنك تسجيل الدخول، انت خارج نطاق الفعاليه متبقي ${currentLocation?.distanceToZone.toStringAsFixed(2)} متر لتتمكن من تسجيل الدخول',
        );

        _isLoading.value = false;
        _isCheckedIn.value = false;
      
      } else {
        final failureOrAttendanceAndDeparture =
            await eventsUsecase.attendanceAndDeparture(body);

        failureOrAttendanceAndDeparture.fold((failure) {
          _isLoading.value = false;
        }, (receivedAttendanceAndDeparture) async {



          if (receivedAttendanceAndDeparture.data['success']) {



        if(receivedAttendanceAndDeparture.data['data']['type'] == 'departure')   _isCheckedIn.value = false;
            
            _isCheckedIn.value = true;
           
            MessageHelper.showSuccessDialog(
              title: 'نجاح',
              message: 'تم تسجيل الحضور بنجاح. 🎉',
            );
          }
          _isLoading.value = false;

          update();
        });
      }
    } else {
      MessageHelper.showErrorDialog(
        title: 'غير مصرح',
        message: 'حدث حطأ ما، ريما لم تعطي التطبيق صلاحيه للوصول للموقع.',
      );
    }

    _isLoading.value = false;

  
    update();
    //   });
  }

  Future<void> createEvocation (EvocationModel evocation) async{


    _isLoading.value = true;

    // Get.to(() => ZoneLocationChecker());

    final Map<String, dynamic> body = {
      'event_id': event?.id,
      'zone_id': event?.zone_id,
      'user_id': event?.user_id,
      'notes': evocation.notes,
      'duration': evocation.duration,
      'type': evocation.type == EvocationType.prayer ? 'prayer': 'food'
    };

    print(body);




  }
}
