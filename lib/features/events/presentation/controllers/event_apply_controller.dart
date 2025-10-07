import 'package:flutter/material.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sagr/features/events/data/models/event_model.dart';
import 'package:sagr/features/events/domain/usecases/get_events.dart';
import 'package:get/get.dart';

import '../../../jobs/data/models/job_model.dart';
import '../../../language/data/models/language_model.dart';
import '../screens/event_apply_success_screen.dart';

class EventApplyController extends GetxController {
  final EventsUsecase eventsUsecase;

  EventApplyController(this.eventsUsecase);

  final AuthController authController = Get.put(AuthController());

  /// Rx Filters  Setter

  EventModel? eventModel;

  /// Products Loading
  /// @Setter
  final RxBool _isLoading = false.obs;

  final _selectedJob = JobModel(id: 0).obs;

  final RxInt _periodId = 0.obs;

  // Map<String, dynamic> errors = {};

  final RxBool _terms = false.obs;

  final RxBool _promise = false.obs;

  // final RxList<LanguageModel> _languages;

  final _languages = <LanguageModel>[].obs;

  String? others = "";
//  List<LanguageModel>? languages;

  /// List of products
  /// @ Getter
  bool get isLoading => _isLoading.value;

  bool get terms => _terms.value;

  bool get promise => _promise.value;

  JobModel get selectedJob => _selectedJob.value;

  int get periodId => _periodId.value;
  final RxMap<String, dynamic> _errors = <String, dynamic>{}.obs;
  // Map get errors => _errors.toJson();
  Map<String, dynamic> get errors => _errors;

  List<LanguageModel> get languages => _languages.toList();

  EventModel? get event => eventModel;

  @override
  void onInit() {
    super.onInit();

    // Get Product Info And set main image.
    getEventInfo().then((value) {
      // _productImage.value = product!.image!;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<AuthController>() &&
          authController.authenticatedUser != null &&
          authController.authenticatedUser!['is_completed'] == false) {
        Get.offNamed('/complete_account');
      }
    });
  }

  Future<void> getEventInfo() async {
    _isLoading.value = true;

    final failureOrEvent = await eventsUsecase.getEventDetails(Get.arguments);

    failureOrEvent.fold((failure) {
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

  void setSelectedJob(job) {
    _selectedJob.value = job;

    if (_errors.containsKey('job')) {
      _errors.remove('job');
    }

    update();
  }

  void setSelectEventPeriod(id) {
    _periodId.value = id;

    if (_errors.containsKey('period')) {
      _errors.remove('period');
    }

    update();
  }

  void setSelectedLanguages(languages) {
    _languages.value = languages;

    if (_errors.containsKey('language')) {
      _errors.remove('language');
    }
    // update();
  }

  void toggleTerms() {
    _terms.value = !_terms.value;
    update();
  }

  void togglePromise() {
    _promise.value = !_promise.value;
    update();
  }

  void __handleValidationErrors() {
    if (selectedJob.id == 0) {
      // handle empty job id.
      errors['job'] = "Job Select Error".tr;
    } else {
      errors.remove('job');
    }

    if (periodId == 0) {
      // handle empty job id.
      errors['period'] = "Period Select Error".tr;
    } else {
      errors.remove('period');
    }

    if (languages.isEmpty) {
      errors['language'] = "You Should Select Minium One Language".tr;
    } else {
      errors.remove('language');
    }
    update();
  }

  Future<void> apply() async {
    _isLoading.value = true;

    __handleValidationErrors();

    if (errors.isNotEmpty) {
      // print(errors);

      return;
    }

    final Map<String, dynamic> body = {
      'job_id': selectedJob.id,
      'event_id': Get.arguments,
      'notes': others ?? "",
      'period': periodId,
      'languages': languages
    };

    final failureOrEvent = await eventsUsecase.apply(body);

    failureOrEvent.fold((failure) {
      _isLoading.value = false;
    }, (receivedProduct) async {
      _isLoading.value = false;

      Future.delayed(Duration(seconds: 2));

      Get.to(() => JobApplicationSuccessPage());


     
    });
  }
}

class ErrorModel {
  String? job = "";
  ErrorModel({this.job});
}
