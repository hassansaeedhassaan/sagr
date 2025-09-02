import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sagr/models/country_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/app_config.dart';
import '../../../repositories/auth_repository.dart';
import '../../../view/contact_us_screen/contact_us_screen.dart';

class ProfileController extends GetxController {
  
  final _items = <CountryModel>[].obs;

  List<CountryModel> get countries => _items.toList();

  RxInt _selectedCountry = 0.obs;

  int get selectedCountry => _selectedCountry.value;

  RxBool _isLoading = false.obs;

  RxInt _tabIndex = 0.obs;

  final AuthRepository _authRepository;

  ProfileController(this._authRepository);

  bool get isLoading => _isLoading.value;

  Map<String, dynamic>? authenticatedUser;

  int get tabIndex => _tabIndex.value;

  void changeTabIndex(index) {
    _tabIndex.value = index;
    update();
  }

  void changeSelectedCountry(value) {
    _selectedCountry.value = value;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    getProfile().then((value) {
      if (authenticatedUser!['nationality'] != "")
        _selectedCountry.value = authenticatedUser!['nationality']['id'];
    });
  }

  Future<void> getProfile() async {
    _isLoading.value = true;

    authenticatedUser = await GetStorage().read('userData');

    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      _isLoading.value = false;
      update();
    });

    _items.clear();
    getCountries();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> getCountries() async {
    _isLoading.value = true;
    final countries = await _authRepository.countries();
    _items.addAll(countries);
    _isLoading.value = false;
    update();
  }

  setSelectedCountry() {
    if (authenticatedUser!['nationality'] != null) {
      _selectedCountry.value = authenticatedUser!['nationality']['id'];
    }
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

  String? name, email, phone, nationality;

  Future<void> updateProfile(context) async {
    _isLoading.value = true;
    try {
      // print(GetStorage().read('userData'));

      final Map<String, dynamic> body = {
        'name': name,
        'email': email,
        'phone': phone,
        'nationality': selectedCountry,
        'image': imagePath
      };

      await _authRepository.updateData(body).then((data) {
        // Map response data to replace stored user data.
        final response = Map<String, dynamic>.from(data.data['data']);

        // replace data user stored
        GetStorage().write('userData', response['user']);

        // update profile data stored in Storage.
        getProfile();

        // Redirect to Profile Page after update.
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ContactUsScreen()));

        // Show success Message After profile updated
        SharedData().showAlert(context, "تم تعديل حسابك بنجاح");

        update();
      });
      _isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error!", e.toString());
      _isLoading.value = false;
    }
  }

  String? old_password, new_password, new_password_confirmation;

  Future<void> changePassword(context) async {
    _isLoading.value = true;
    try {
      // print(GetStorage().read('userData'));

      final Map<String, dynamic> body = {
        'old_password': old_password,
        'new_password': new_password,
        'new_password_confirmation': new_password_confirmation
      };

      await _authRepository.changePassword(body).then((data) {
        // Map response data to replace stored user data.
        final response = Map<String, dynamic>.from(data.data['data']);

        if (response['code'] == 200) {
          GetStorage().remove('access_token');
          GetStorage().remove('userData');
          Get.offAndToNamed("/login");

          SharedData().showAlert(context, response['message']);
        }
      });
      _isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error!", e.toString());
      _isLoading.value = false;
    }
  }

  Future<void> deleteAccount(context) async {
    try {
      // print(GetStorage().read('userData'));

      await _authRepository.deleteAccount().then((data) {
        // Map response data to replace stored user data.
        final response = Map<String, dynamic>.from(data.data);

        print(data);

        if (response['code'] == 200) {
          GetStorage().remove('access_token');
          GetStorage().remove('userData');
          Get.offAndToNamed("/login");

          SharedData().showAlert(context, response['message']);
        }
      });
      _isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error!", e.toString());
      _isLoading.value = false;
    }
  }
}
