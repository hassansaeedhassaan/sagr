import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/models/country_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthController extends GetxController {
  final _items = <CountryModel>[].obs;

  List<CountryModel> get countries => _items.toList();

  final RxInt _selectedCountry = 0.obs;

  int get selectedCountry => _selectedCountry.value;

  final RxBool _isLoading = false.obs;

  final RxBool _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  final RxInt _tabIndex = 0.obs;

  AuthController();

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
    getProfile().then((value) {});

  }

  Future<void> getProfile() async {
    _isLoading.value = true;

    authenticatedUser = GetStorage().read('userData');


    if (authenticatedUser != null) {
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        _isLoggedIn.value = true;
        update();
      });

      _isLoading.value = false;
      
    }
  }

  @override
  void onReady() {
    super.onReady();
  }
}
