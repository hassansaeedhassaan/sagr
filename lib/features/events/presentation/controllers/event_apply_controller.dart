import 'package:flutter/material.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sagr/features/events/data/models/event_model.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/features/events/domain/usecases/get_events.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
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

  /// Set when the event failed to load; the form is unusable until it clears.
  final RxnString _loadError = RxnString();

  /// True between tapping submit and the request settling. Kept separate from
  /// [isLoading]: that one covers fetching the event, and sharing the two made
  /// the submit button announce "Submitting…" while the page was merely
  /// loading.
  final RxBool _submitting = false.obs;
  // Map get errors => _errors.toJson();
  Map<String, dynamic> get errors => _errors;

  String? get loadError => _loadError.value;

  bool get isSubmitting => _submitting.value;

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
    _loadError.value = null;

    final id = eventIdFromArguments(Get.arguments);
    if (id == null) {
      _loadError.value = 'Could not load this event. Please try again.';
      _isLoading.value = false;
      update();
      return;
    }

    final failureOrEvent = await eventsUsecase.getEventDetails(id);

    failureOrEvent.fold((failure) {
      // Surface it: a silently empty form looks like a broken screen.
      _loadError.value = failure.message;
      _isLoading.value = false;
      update();
    }, (receivedEvent) {
      eventModel = receivedEvent;
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
    // Clear the error as soon as the user satisfies it, like the job/period
    // fields do — otherwise a red line sits under a ticked checkbox.
    if (_terms.value) _errors.remove('terms');
    update();
  }

  void togglePromise() {
    _promise.value = !_promise.value;
    if (_promise.value) _errors.remove('promise');
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

if (!terms) {
      // handle empty job id.
      errors['terms'] = "Please read and agree terms and conditions".tr;
    } else {
      errors.remove('terms');
    }

if (!promise) {
      // handle empty job id.
      errors['promise'] = "Please Confirm your promise".tr;
    } else {
      errors.remove('promise');
    }

    // if (languages.isEmpty) {
    //   errors['language'] = "You Should Select Minium One Language".tr;
    // } else {
    //   errors.remove('language');
    // }
    update();
  }

  Future<void> apply() async {
    // Tapping submit twice before the response lands would file two applications.
    if (_submitting.value) return;

    __handleValidationErrors();
    if (errors.isNotEmpty) return;

    _submitting.value = true;

    final body = <String, dynamic>{
      'job_id': selectedJob.id,
      'event_id': eventIdFromArguments(Get.arguments),
      'notes': others ?? '',
      'period': periodId,
    };

    final failureOrEvent = await eventsUsecase.apply(body);

    failureOrEvent.fold((failure) {
      _submitting.value = false;

      // Map server-side field errors back onto the form; anything else is a
      // one-off the user can only react to as a message.
      if (failure is ValidationFailure && failure.errors.isNotEmpty) {
        for (final entry in failure.errors.entries) {
          final field = _formFieldFor(entry.key);
          if (field != null && entry.value.isNotEmpty) {
            errors[field] = entry.value.first;
          }
        }
        update();
        if (errors.isEmpty) {
          Get.snackbar('Error'.tr, failure.message.tr);
        }
        return;
      }

      Get.snackbar('Error'.tr, failure.message.tr);
    }, (_) {
      _submitting.value = false;
      // Replace the form rather than stacking on it — going "back" from the
      // success screen must not land on a submitted application.
      Get.off(() => JobApplicationSuccessPage());
    });
  }

  /// Maps an API validation key onto the form field that renders its error.
  String? _formFieldFor(String apiKey) {
    switch (apiKey) {
      case 'job_id':
        return 'job';
      case 'period':
        return 'period';
      case 'notes':
        return 'notes';
      default:
        return null;
    }
  }
}

class ErrorModel {
  String? job = "";
  ErrorModel({this.job});
}
