import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/features/auth/domain/usecases/auth.dart';
import 'package:get/get.dart';
import 'package:sagr/features/education/data/models/education_model.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import 'package:sagr/features/language/data/models/language_model.dart';
import 'package:sagr/features/marital_status/data/models/marital_status_model.dart';
import 'package:sagr/features/regions/presentation/controllers/regions_controller.dart';

import '../../../regions/data/models/region_model.dart';
import '../screens/registration_success_page.dart';
import 'auth_controller.dart';

import 'dart:developer' as developer;


class CreateAccountController extends GetxController {
  final AuthUsecase authUsecase;

  final AuthController authController = Get.put(AuthController());

  CreateAccountController(this.authUsecase);

  String? firstName,
      middleName,
      lastName,
      email,
      phone,
      password,
      confirmationPassword,
      nationalNo,
      ibanNumber,
      bankAccountName,
      experts,
      previousEvents,
      chronicDiseases;

  final RxString _gender = 'male'.obs;

  final RxBool _isLoading = false.obs;

  final RxBool _agree = true.obs;
  final RxBool _agree_error_message = false.obs;

  bool get isLoading => _isLoading.value;
  bool get agree => _agree.value;
  bool get agree_error_message => _agree_error_message.value;

  final _selected_marital_status = MaritalStatusModel().obs;

  MaritalStatusModel get selectedMaritalStatus =>
      _selected_marital_status.value;

  final _selected_jobs = JobModel().obs;

  JobModel get selectedJob => _selected_jobs.value;


final _languages = <LanguageModel>[].obs;

 List<LanguageModel>? get languages => _languages.toList();



  final _selected_education = EducationModel().obs;

  EducationModel get selectedEducation => _selected_education.value;

  String get gender => _gender.value;

  final _selected_region = RegionModel().obs;

  RegionModel get selectedRegion => _selected_region.value;

  final RxString _countryCode = 'sa'.obs;

  String get countryCode => _countryCode.value;

  void setGender(gender) {
    _gender.value = gender;
    update();
  }

  void setSelectedMaritalStatus(maritalStatus) {
    _selected_marital_status.value = maritalStatus;
    update();
  }

  void setSelectedJob(job) {
    _selected_jobs.value = job;
    update();
  }

  void setSelectedRegion(region) {
    _selected_region.value = region;
    update();
  }

  void setSelectedEducation(education) {
    _selected_education.value = education;
    update();
  }


 void setSelectedLanguages(language) {
     _languages.add(language); 
    update();
  }

  selectedCountryCode(code) async {
    RegionsController regionsController =
        Get.put(RegionsController(Get.find()));

    _countryCode.value = code;
    regionsController.getAllRegions(code);

    _selected_region.value = RegionModel();
  }

  final RxString _cvEmpPath = "".obs;

  String get cvEmpPath => _cvEmpPath.value;

  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    _cvEmpPath.value = result?.files.single.path! ?? "";

    update();

    // print(result?.files.single.name);
    // print(result?.files.single.size);
    // print(result?.files.single.path!);
    // print(result?.files.single.extension!);
  }

  final _ibanFilePath = "".obs;

  String get ibanFilePath => _ibanFilePath.value;

  void handleFileSelectionForIban() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    _ibanFilePath.value = result?.files.single.path! ?? "";

    update();

    // print(result?.files.single.name);
    // print(result?.files.single.size);
    // print(result?.files.single.path!);
    // print(result?.files.single.extension!);
  }

  final ImagePicker _picker = ImagePicker();

  final _imagePath = "".obs;
  final _imageFile = XFile("").obs;

  String get imagePath => _imagePath.value;
  XFile get imageFile => _imageFile.value;

  Future<void> pickImage() async {
    try {

      final image = await _picker.pickImage(source: ImageSource.gallery);

      _imagePath.value = image!.path;

      _imageFile.value = image;

      update();
    } catch (e) {}
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();




if(authController.authenticatedUser!['job']!= null){
 _selected_jobs.value = JobModel.fromJson(authController.authenticatedUser!['job']);
}


if(authController.authenticatedUser!['maritalStatus']!= null){
 _selected_marital_status.value = MaritalStatusModel.fromJson(authController.authenticatedUser!['maritalStatus']);
}


if(authController.authenticatedUser!['education']!= null){
 _selected_education.value = EducationModel.fromJson(authController.authenticatedUser!['education']);
}


   
  }

  @override
  void onClose() {
    super.onClose();
  }

  void acceptAgree() {
    _agree.value = !_agree.value;
    _agree_error_message.value = false;
    update();
  }

  Future<void> deleteAccount(context) async {
    print("Deleted ME 🤔");
  }

  Future<void> register() async {
    _isLoading.value = true;

    // if (agree == false) {
    //   _agree_error_message.value = true;
    //   _isLoading.value = false;
    //   update();

    //   return;
    //   //  Get.snackbar("Error!", "Please Accept ");
    // } else {
    //   _agree_error_message.value = false;
    // }

    update();

    Random random = new Random();
    int randomNumber = random.nextInt(100000000);
    final Map<String, dynamic> body = {
      'name': firstName,
      'email': '$randomNumber@gmail.com',
      // 'firstName': firstName,
      // 'middleName': middleName,
      // 'lastName': lastName,
      // 'nationalID': nationalNo,
      // 'email': email,
      'phone': phone,
      // 'bankAccountName': bankAccountName,
      // 'experts': experts,
      // 'previous_events_past': previousEvents,
      // 'chronic_diseases': chronicDiseases,
      'countryCode': countryCode,
      // 'zone_id': selectedRegion.id!,
      // 'iban': ibanNumber,
      'gender': gender,
      // 'job_id': selectedJob.id!,
      // 'marital_status_id': selectedMaritalStatus.id!,
      // 'education_id': selectedEducation.id!,
      'password': password,
      'password_confirmation': confirmationPassword,
      // 'image': imagePath,
      // 'emp_cv': cvEmpPath,
      // 'iban_file': ibanFilePath
    };

    try {
      final failureOrCustomer = await authUsecase.createAccount(body);

      failureOrCustomer.fold((failure) {
        _isLoading.value = false;
      }, (receivedData) {
        // Future.delayed(Duration(milliseconds: 1000))
        //     .then((value) => Get.offAllNamed('/login'));
        Future.delayed(Duration(milliseconds: 1000))
            .then((value) => Get.to(() => RegistrationSuccessPage()));

        _isLoading.value = false;
        update();
      });

      _isLoading.value = false;

      update();
    } on ValidationException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error!", e.data['message']);
      _isLoading.value = false;
      update();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error!", 'wrong'.tr);
      _isLoading.value = false;
    }

    update();
  }

  final RxBool _imagePathRequired = false.obs;
  bool get profileImage => _imagePathRequired.value;
  void _setValidationState() {
     _imagePathRequired.value = _imagePath.value == '' ? true : false;
    update();
  }
  Future<void> completeAccount() async {

    _setValidationState();
   
    _setLoadingState(true);

    if (profileImage == true){
      _setLoadingState(false);
      return;
    }
     

    // try {
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
        'job_id': selectedJob.id!,
        'marital_status_id': selectedMaritalStatus.id!,
        'education_id': selectedEducation.id!,
        'image': imagePath,
        'emp_cv': cvEmpPath,
        'iban_file': ibanFilePath
      };

      final failureOrCustomer = await authUsecase.completeAccount(body);



      failureOrCustomer.fold(
        (failure) {
          
          _setLoadingState(false);

          print("🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔🤔");
          
          // Handle failure case if needed
          // You might want to show error message here.

        },
        (receivedData) {

          print("sadas;dkal;sdk");

          // print(receivedData.toJson());
        
        // {id: 14,
        // name: GIGA,
        // email: 64348730@gmail.com, 
        // phone: 5566778899,
        // type: employee,
        // firstName: Ahmed,
        // middleName: Salama,
        // lastName: Hamada,
        // countryCode: sa,
        // gender: male,
        // is_completed: 0,
        // fcm_token: null,
        // nationalID: 7888765556, 
        // experts: null, 
        // previous_events_past: null,
        // chronic_diseases: null,
        // image: images/1757344000.jpg,
        // emp_cv: files/1757344000.sqlite3,
        // iban_file: files/1757344000.sqlite3,
        // status: offline, last_seen: null,
        // ibanNo: null,
        // bankAccountName: null,
        // job: null,
        // maritalStatus: null,
        // education: null,
        // region: null,
        // languages: []}


          GetStorage().write('userData', receivedData.toJson());

           final userData = GetStorage().read('userData');
// userData['is_completed']= receivedData.
           print(userData);


          print("asld;as; lkdask;l d🔥");
          
          // _navigateToSuccessPage();
        },
      );
    // } on ValidationException catch (e) {



    //    if (e is ValidationException) {
    //     _logValidationException(e);
    //     // Re-throw or handle as needed
    //     rethrow;
    //   }

    //   _handleError(e.data['message']);
    // } catch (e) {

    //   print("as l;sadlk ask dl;k👁️");


    //   if (kDebugMode) {
    //     print(e);
    //   }
    //   _handleError('wrong'.tr);
    // } finally {

    //   print("as l;sadlk ask dl;k👁️");

    //   _setLoadingState(false);
    // }


          _setLoadingState(false);

  }

// Helper methods for better code organization
  void _setLoadingState(bool isLoading) {
    _isLoading.value = isLoading;
    update();
  }

  void _handleError(String message) {
    Get.snackbar("Error!", message);
    if (kDebugMode) {
      print("Registration error: $message");
    }
  }

  void _navigateToSuccessPage() {
    Future.delayed(const Duration(milliseconds: 1000)).then(
      (value) => Get.to(() => RegistrationSuccessPage()),
    );
  }

  // void _logValidationException(ValidationException e) {
  //   // Method 1: Using dart:developer log (recommended)
  //   developer.log(
  //     e.getFormattedDebugInfo(),
  //     name: 'ValidationException',
  //     level: 1000, // Error level
  //     error: e,
  //   );

  //   // Method 2: Using debugPrint (Flutter specific)
  //   if (kDebugMode) {
  //     debugPrint('\n${e.getFormattedDebugInfo()}');
  //   }

  //   // Method 3: Using print (basic)
  //   // print(e.getFormattedDebugInfo());
  // }
  
}
