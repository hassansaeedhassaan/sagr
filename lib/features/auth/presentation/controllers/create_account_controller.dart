import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:sagr/features/auth/domain/usecases/auth.dart';
import 'package:get/get.dart';
import 'package:sagr/features/education/data/models/education_model.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import 'package:sagr/features/language/data/models/language_model.dart';
import 'package:sagr/features/marital_status/data/models/marital_status_model.dart';
import 'package:sagr/features/nationalities/data/models/nationality_model.dart';
import 'package:sagr/features/regions/presentation/controllers/regions_controller.dart';

import '../../../regions/data/models/region_model.dart';
import '../screens/registration_success_page.dart';
import 'auth_controller.dart';

import 'dart:developer' as developer;
import 'package:sagr/widgets/messages.dart' show AppNotice;

/// Controller for handling user account creation, profile completion, and updates
class CreateAccountController extends GetxController {
  final AuthUsecase authUsecase;
  final AuthController authController = Get.put(AuthController());

  CreateAccountController(this.authUsecase);

  // ========== Profile Fields ==========
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? phone;
  String? password;
  String? confirmationPassword;
  String? nationalNo;
  String? ibanNumber;
  String? bankAccountName;
  String? experts;
  String? previousEvents;
  String? chronicDiseases;
  
  DateTime? birthdate;


  // ========== Observable States ==========
  final RxString _gender = 'male'.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _agree = true.obs;
  final RxBool _agreeErrorMessage = false.obs;
  final RxBool _imagePathRequired = false.obs;
  final RxString _countryCode = 'sa'.obs;
  final RxString _cvEmpPath = "".obs;
  final RxString _ibanFilePath = "".obs;
  final RxString _imagePath = "".obs;
  final Rx<XFile> _imageFile = XFile("").obs;
  final RxBool obscureText = true.obs;
  final RxBool obscureTextConfirm = true.obs;

  // ========== Observable Models ==========
  final Rx<MaritalStatusModel> _selectedMaritalStatus =
      MaritalStatusModel().obs;
  final Rx<JobModel> _selectedJobs = JobModel().obs;
  final Rx<EducationModel> _selectedEducation = EducationModel().obs;
  final Rx<NationalityModel> _selectedNationality = NationalityModel().obs;
  final Rx<RegionModel> _selectedRegion = RegionModel().obs;
  final RxList<LanguageModel> _languages = <LanguageModel>[].obs;



  // ========== Getters ==========
  bool get isLoading => _isLoading.value;
  bool get agree => _agree.value;
  bool get agreeErrorMessage => _agreeErrorMessage.value;
  bool get profileImageRequired => _imagePathRequired.value;
  String get gender => _gender.value;
  String get countryCode => _countryCode.value;
  String get cvEmpPath => _cvEmpPath.value;
  String get ibanFilePath => _ibanFilePath.value;
  String get imagePath => _imagePath.value;
  XFile get imageFile => _imageFile.value;
  MaritalStatusModel get selectedMaritalStatus => _selectedMaritalStatus.value;
  JobModel get selectedJob => _selectedJobs.value;
  EducationModel get selectedEducation => _selectedEducation.value;
  RegionModel get selectedRegion => _selectedRegion.value;
  List<LanguageModel> get languages => _languages.toList();
  NationalityModel get selectedNationality => _selectedNationality.value;

  // ========== Image Picker ==========
  final ImagePicker _picker = ImagePicker();

  // ========== Lifecycle Methods ==========
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _loadAuthenticatedUserData();
  }

  @override
  void onClose() {
    super.onClose();
  }


  changeObscureText() {
    obscureText.value = !obscureText.value;
    update();
  }


  changeObscureTextConfirm() {
    obscureTextConfirm.value = !obscureTextConfirm.value;
    update();
  }

  // ========== Data Loading ==========
  /// Loads authenticated user data into the controller
  void _loadAuthenticatedUserData() {
    final user = authController.authenticatedUser;
    if (user == null) return;

    T? model<T>(String key, T Function(Map<String, dynamic>) fromJson) {
      final v = user[key];
      // Missing relations come back as {id: null, name: null}.
      return v is Map && v['id'] != null
          ? fromJson(Map<String, dynamic>.from(v))
          : null;
    }

    final job = model('job', JobModel.fromJson);
    if (job != null) _selectedJobs.value = job;

    final marital = model('maritalStatus', MaritalStatusModel.fromJson);
    if (marital != null) _selectedMaritalStatus.value = marital;

    final education = model('education', EducationModel.fromJson);
    if (education != null) _selectedEducation.value = education;

    final region = model('region', RegionModel.fromJson);
    if (region != null) _selectedRegion.value = region;

    final nationality = model('nationality', NationalityModel.fromJson);
    if (nationality != null) _selectedNationality.value = nationality;

    if (user['gender'] is String && (user['gender'] as String).isNotEmpty) {
      _gender.value = user['gender'];
    }

    if (user['birthdate'] is String) {
      birthdate = DateTime.tryParse(user['birthdate']);
    }

    if (user['languages'] != null && user['languages'] is List) {
      _languages.value = (user['languages'] as List)
          .map((lang) => LanguageModel.fromJson(lang))
          .toList();
    }
  }

  /// Seeds the selections from the saved profile and forgets files picked
  /// on an earlier visit, so the edit screen starts from what is saved.
  void loadSavedProfile() {
    _imagePath.value = '';
    _imageFile.value = XFile('');
    _cvEmpPath.value = '';
    _ibanFilePath.value = '';
    _imagePathRequired.value = false;
    _loadAuthenticatedUserData();
    update();
  }

  // ========== Setters ==========
  void setGender(String gender) {
    _gender.value = gender;
    update();
  }

  void setSelectedMaritalStatus(MaritalStatusModel maritalStatus) {
    _selectedMaritalStatus.value = maritalStatus;
    update();
  }

  void setSelectedJob(JobModel job) {
    _selectedJobs.value = job;
    update();
  }

  void setSelectedRegion(RegionModel region) {
    _selectedRegion.value = region;
    update();
  }

  void setSelectedEducation(EducationModel education) {
    _selectedEducation.value = education;
    update();
  }




  void setSelectedNationality(NationalityModel nationality) {
    _selectedNationality.value = nationality;
    update();
  }


  void setBirthdate(DateTime date) {
    birthdate = date;
    update();
  }

  void setLanguages(List<LanguageModel> languages) {
    _languages.assignAll(languages);
    update();
  }

  void setSelectedLanguages(LanguageModel language) {
    if (!_languages.contains(language)) {
      _languages.add(language);
      update();
    }
  }

  void setSelectedUpdatedLanguages(langs) {
    _languages.value = langs;
    // update();
  }

  void removeLanguage(LanguageModel language) {
    _languages.remove(language);
    update();
  }

  void clearLanguages() {
    _languages.clear();
    update();
  }

  Future<void> selectedCountryCode(String code) async {
    final regionsController = Get.put(RegionsController(Get.find()));
    _countryCode.value = code;
    regionsController.getAllRegions(code);
    _selectedRegion.value = RegionModel();
    update();
  }

  void acceptAgree() {
    _agree.value = !_agree.value;
    _agreeErrorMessage.value = false;
    update();
  }

  // ========== File Handling ==========
  /// Picks a CV/resume - a photo or a PDF/Word file
  Future<void> handleFileSelection() async {
    try {
      final path = await _pickDocument(['pdf', 'doc', 'docx'], 'ملف PDF / Word');
      if (path != null) {
        _cvEmpPath.value = path;
        update();
      }
    } catch (e) {
      _handleError('Failed to pick file: ${e.toString()}');
    }
  }

  /// Picks an IBAN document - a photo or a PDF file
  Future<void> handleFileSelectionForIban() async {
    try {
      final path = await _pickDocument(['pdf'], 'ملف PDF');
      if (path != null) {
        _ibanFilePath.value = path;
        update();
      }
    } catch (e) {
      _handleError('Failed to pick IBAN file: ${e.toString()}');
    }
  }

  /// Lets the user choose between a photo (gallery or camera) and a document
  /// file, and returns the picked path, or null if they backed out.
  Future<String?> _pickDocument(
      List<String> fileExtensions, String fileLabel) async {
    final source = await Get.bottomSheet<String>(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('صورة من المعرض'),
              onTap: () => Get.back(result: 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('التقاط صورة'),
              onTap: () => Get.back(result: 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: Text(fileLabel),
              onTap: () => Get.back(result: 'file'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );

    switch (source) {
      case 'gallery':
      case 'camera':
        final image = await _picker.pickImage(
          source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxWidth: 2000,
          maxHeight: 2000,
          imageQuality: 85,
        );
        return image?.path;
      case 'file':
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: fileExtensions,
        );
        return result?.files.single.path;
    }
    return null;
  }

  /// Picks a profile image from gallery
  Future<void> pickImage() => _pickProfileImage(ImageSource.gallery);

  /// Takes a profile image with the camera
  Future<void> takePhoto() => _pickProfileImage(ImageSource.camera);

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
        // EXIF/location isn't needed, and asking for it adds a photo-library
        // permission prompt on iOS.
        requestFullMetadata: false,
      );
      if (image != null) _setProfileImage(image);
    } on PlatformException catch (e) {
      _logError('Profile photo picker failed', e);
      _handleError(_pickerErrorMessage(e, source));
    } catch (e) {
      _logError('Profile photo picker failed', e);
      _handleError(source == ImageSource.camera
          ? "Couldn't take the photo, please try again".tr
          : "Couldn't open the photo, please try again".tr);
    }
  }

  /// Android may kill the app while the camera app is in front (low-memory
  /// phones do this often). The picker then has no one to return to and the
  /// photo is lost unless it is fetched here once the screen is back.
  Future<void> recoverLostPhoto() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final response = await _picker.retrieveLostData();
      if (response.isEmpty) return;
      final file = response.file;
      if (file != null) {
        _setProfileImage(file);
      } else if (response.exception != null) {
        _handleError(
            _pickerErrorMessage(response.exception!, ImageSource.camera));
      }
    } catch (e) {
      _logError('Recovering lost photo failed', e);
    }
  }

  void _setProfileImage(XFile image) {
    _imagePath.value = image.path;
    _imageFile.value = image;
    _imagePathRequired.value = false;
    update();
  }

  String _pickerErrorMessage(PlatformException e, ImageSource source) {
    switch (e.code) {
      case 'camera_access_denied':
      case 'camera_access_denied_without_prompt':
      case 'camera_access_restricted':
        return 'Camera access is off. Allow it for Sagr in your phone settings.'
            .tr;
      case 'photo_access_denied':
      case 'photo_access_restricted':
        return 'Photo access is off. Allow it for Sagr in your phone settings.'
            .tr;
      case 'no_available_camera':
        return 'No camera app was found on this phone'.tr;
    }
    return source == ImageSource.camera
        ? "Couldn't take the photo, please try again".tr
        : "Couldn't open the photo, please try again".tr;
  }

  Future<void> takenPhoto(image) async {
    try {
      if (image != null) {
        _imagePath.value = image.path;
        _imageFile.value = image;
        _imagePathRequired.value = false;
        update();
      }
    } catch (e) {
      _handleError('Failed to take photo: ${e.toString()}');
    }
  }

  /// Clears the selected image
  void clearImage() {
    _imagePath.value = "";
    _imageFile.value = XFile("");
    update();
  }

  // ========== Validation ==========
  void _setValidationState() {
    _imagePathRequired.value = _imagePath.value.isEmpty;
    update();
  }

  bool _validateRegistration() {
    if (!agree) {
      _agreeErrorMessage.value = true;
      return false;
    }
    _agreeErrorMessage.value = false;
    return true;
  }

  // ========== Account Operations ==========
  /// Registers a new user account
  Future<void> register() async {
    if (!_validateRegistration()) {
      return;
    }

    _setLoadingState(true);

    // Generate temporary email - replace with actual email in production
    // final randomNumber = Random().nextInt(100000000);

    final Map<String, dynamic> body = {
      'name': firstName,
      'email': email, // TODO: Use actual email
      'phone': phone,
      'countryCode': countryCode,
      'gender': gender,
      'password': password,
      'password_confirmation': confirmationPassword,
    };

    try {
      final failureOrCustomer = await authUsecase.createAccount(body);

      failureOrCustomer.fold(
        (failure) {
          _setLoadingState(false);
          // The server says exactly what's wrong (phone or email already
          // used, invalid email, ...) in the app's language; this used to
          // be replaced by a bare "Registration failed".
          _handleError(failure is ValidationFailure
              ? (failure.firstError ?? failure.message)
              : "Couldn't create your account. Please try again.".tr);
        },
        (receivedData) {
          _navigateToSuccessPage();
          _setLoadingState(false);
        },
      );
    } on ValidationException catch (e) {
      _logError('Validation error during registration', e);
      _handleError(_firstServerError(e.data) ??
          "Couldn't create your account. Please try again.".tr);
    } catch (e) {
      _logError('Unexpected error during registration', e);
      _handleError('wrong'.tr);
    } finally {
      _setLoadingState(false);
    }
  }

  /// Completes the user profile. Returns true once saved so the screen can
  /// close itself; failures are surfaced here as a snackbar.
  Future<bool> completeAccount() async {
    _setValidationState();

    if (profileImageRequired) {
      _handleError('Please add a profile photo'.tr);
      return false;
    }

    _setLoadingState(true);

    final Map<String, dynamic> body = {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'nationalID': nationalNo,
      'bankAccountName': bankAccountName,
      'experts': experts,
      'previous_events_past': previousEvents,
      'chronic_diseases': chronicDiseases,
      'countryCode': countryCode,
      'iban': ibanNumber,
      'gender': gender,
      'job_id': selectedJob.id,
      'marital_status_id': selectedMaritalStatus.id,
      'education_id': selectedEducation.id,
      'image': imagePath,
      'emp_cv': cvEmpPath,
      'iban_file': ibanFilePath,
      'nationality_id': selectedNationality.id,
      'region_id': selectedRegion.id,
      'langs': _languages.map((lang) => lang.id).toList(),
      if (birthdate != null) 'birthdate': _isoDate(birthdate!),
    };

    try {
      final failureOrCustomer = await authUsecase.completeAccount(body);

      return failureOrCustomer.fold(
        (failure) {
          _handleError(failure is ValidationFailure
              ? (failure.firstError ?? failure.message)
              : "Couldn't complete your profile".tr);
          return false;
        },
        (receivedData) {
          _markProfileCompleted();
          // The data source has stored the returned profile; reload it.
          authController.getProfile();
          return true;
        },
      );
    } on ValidationException catch (e) {
      _logError('Validation error during account completion', e);
      _handleError(
          _firstServerError(e.data) ?? "Couldn't complete your profile".tr);
      return false;
    } catch (e) {
      _logError('Unexpected error during account completion', e);
      _handleError('wrong'.tr);
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  /// yyyy-MM-dd with Latin digits whatever the app locale.
  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// First message from a Laravel 422 body ({message, errors: {field: [..]}}).
  String? _firstServerError(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      return first is List && first.isNotEmpty ? '${first.first}' : '$first';
    }
    final message = data['message'];
    return message is String && message.isNotEmpty ? message : null;
  }

  /// Flags the cached user as completed so the event-apply gate lets them
  /// through without logging out and back in.
  void _markProfileCompleted() {
    final stored = GetStorage().read('userData');
    final user = <String, dynamic>{
      if (stored is Map) ...Map<String, dynamic>.from(stored),
      'is_completed': true,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
    };
    GetStorage().write('userData', user);
    authController.authenticatedUser = user;
    authController.update();
  }

  /// Updates user profile information. Returns true once saved.
  Future<bool> updateProfile({bool showSuccessMessage = true}) async {
    _setLoadingState(true);

    final Map<String, dynamic> body = {};

    // Only include fields that have values
    if (firstName != null && firstName!.isNotEmpty)
      body['firstName'] = firstName;
    if (middleName != null && middleName!.isNotEmpty)
      body['middleName'] = middleName;
    if (lastName != null && lastName!.isNotEmpty) body['lastName'] = lastName;
    if (email != null && email!.isNotEmpty) body['email'] = email;
    if (phone != null && phone!.isNotEmpty) body['phone'] = phone;
    if (nationalNo != null && nationalNo!.isNotEmpty)
      body['nationalID'] = nationalNo;
    if (ibanNumber != null && ibanNumber!.isNotEmpty) body['iban'] = ibanNumber;
    if (bankAccountName != null && bankAccountName!.isNotEmpty) {
      body['bankAccountName'] = bankAccountName;
    }
    // Sent even when empty, so these optional notes can be cleared.
    if (experts != null) body['experts'] = experts;
    if (chronicDiseases != null) body['chronic_diseases'] = chronicDiseases;
    if (previousEvents != null && previousEvents!.isNotEmpty) {
      body['previous_events_past'] = previousEvents;
    }

    body['countryCode'] = countryCode;
    body['gender'] = gender;

    if (selectedJob.id != null) body['job_id'] = selectedJob.id;
    if (selectedMaritalStatus.id != null) {
      body['marital_status_id'] = selectedMaritalStatus.id;
    }
    if (selectedEducation.id != null)
      body['education_id'] = selectedEducation.id;
    // The API reads region_id (zone_id was silently ignored).
    if (selectedRegion.id != null) body['region_id'] = selectedRegion.id;
    if (selectedNationality.id != null) {
      body['nationality_id'] = selectedNationality.id;
    }
    if (birthdate != null) body['birthdate'] = _isoDate(birthdate!);

    // Include files only if they're new/updated
    if (imagePath.isNotEmpty) body['image'] = imagePath;
    if (cvEmpPath.isNotEmpty) body['emp_cv'] = cvEmpPath;
    if (ibanFilePath.isNotEmpty) body['iban_file'] = ibanFilePath;

    // Include languages
    if (_languages.isNotEmpty) {
      body['langs'] = _languages.map((lang) => lang.id).toList();
    }


    try {
      final failureOrCustomer = await authUsecase.updateProfile(body);

      return failureOrCustomer.fold(
        (failure) {
          _setLoadingState(false);
          // A 422 names the field that failed; show that, not a generic line.
          _handleError(failure is ValidationFailure
              ? (failure.firstError ?? failure.message)
              : "Couldn't save your profile".tr);
          return false;
        },
        (receivedData) {
          // The data source has stored the returned profile; reload it.
          authController.getProfile();

          if (showSuccessMessage) {
            AppNotice.success('Success'.tr, 'Profile updated successfully'.tr);
          }

          _setLoadingState(false);
          return true;
        },
      );
    } on ValidationException catch (e) {
      _logError('Validation error during profile update', e);
      _handleError(
          _firstServerError(e.data) ?? "Couldn't save your profile".tr);
      return false;
    } catch (e) {
      _logError('Unexpected error during profile update', e);
      _handleError("Couldn't save your profile".tr);
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  /// Deletes user account
  Future<void> deleteAccount() async {
    _setLoadingState(true);

    // try {
    //   final failureOrSuccess = await authUsecase.deleteAccount();

    //   failureOrSuccess.fold(
    //     (failure) {
    //       _setLoadingState(false);
    //       _handleError('Failed to delete account');
    //     },
    //     (success) {
    //       GetStorage().erase();
    //       Get.offAllNamed('/login');
    //       Get.snackbar(
    //         'Success',
    //         'Account deleted successfully',
    //         snackPosition: SnackPosition.BOTTOM,
    //       );
    //     },
    //   );
    // } catch (e) {
    //   _logError('Error deleting account', e);
    //   _handleError('Failed to delete account. Please try again.');
    // } finally {
    //   _setLoadingState(false);
    // }
  }

  // ========== Helper Methods ==========
  void _setLoadingState(bool isLoading) {
    _isLoading.value = isLoading;
    update();
  }

  /// The last message shown by [_handleError]; read by tests.
  @visibleForTesting
  String? lastErrorMessage;

  void _handleError(String message) {
    lastErrorMessage = message;
    AppNotice.error("Error".tr, message);

    if (kDebugMode) {
      developer.log(
        'Error: $message',
        name: 'CreateAccountController',
        level: 900,
      );
    }
  }

  void _logError(String message, dynamic error) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'CreateAccountController',
        error: error,
        level: 1000,
      );
    }
  }

  void _updateLocalStorage(Map<String, dynamic> userData) {
    GetStorage().write('userData', userData);

    if (kDebugMode) {
      developer.log(
        'User data updated in local storage',
        name: 'CreateAccountController',
      );
    }
  }

  void _navigateToSuccessPage() {
    Future.delayed(const Duration(milliseconds: 1000)).then(
      (value) => Get.to(() => const RegistrationSuccessPage()),
    );
  }

  /// Resets all form fields
  void resetForm() {
    firstName = null;
    middleName = null;
    lastName = null;
    email = null;
    phone = null;
    password = null;
    confirmationPassword = null;
    nationalNo = null;
    ibanNumber = null;
    bankAccountName = null;
    experts = null;
    previousEvents = null;
    chronicDiseases = null;

    _gender.value = 'male';
    _countryCode.value = 'sa';
    _cvEmpPath.value = '';
    _ibanFilePath.value = '';
    _imagePath.value = '';
    _imageFile.value = XFile('');
    _agree.value = true;
    _agreeErrorMessage.value = false;
    _imagePathRequired.value = false;

    _selectedMaritalStatus.value = MaritalStatusModel();
    _selectedJobs.value = JobModel();
    _selectedEducation.value = EducationModel();
    _selectedRegion.value = RegionModel();
    _languages.clear();

    update();
  }


  

      

}
