import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/products/data/models/city_model.dart';
import 'package:sagr/features/products/data/models/state_model.dart';
import 'package:sagr/features/products/domain/usecases/get_products.dart';
import 'package:get/get.dart';

import '../../../../core/error/exceptions.dart';
import '../../../countries/data/models/country_model.dart';

class CreateAdController extends GetxController {
  final ProductUsecase productUsecase;

  CreateAdController(this.productUsecase);

  /**
   * Is Loading 
   * @Setter
   */
  RxBool _isLoading = false.obs;

  RxBool _isPremium = false.obs;

  RxBool _mapLoading = false.obs;

  RxDouble _lat = 0.0.obs;

  RxDouble _long = 0.0.obs;

  RxInt _currentStep = 1.obs;

 

  String hasImages = "";
  

  /// Required Fields For Ad.
  String title = "";
  String description = "";
  String phone = "";
  String whatsapp = "";
  String price = '';
  String min_price = '';

  final _selected_country = CountryModel().obs;
  CountryModel get selectedCountry => _selected_country.value;

  final _selected_state = StateModel(name: '').obs;
  StateModel get selectedState => _selected_state.value;

  final _selected_city = CityModel(name: '').obs;
  CityModel get selectedCity => _selected_city.value;

  final _selected_category = CategoryModel().obs;
  CategoryModel get selectedCategory => _selected_category.value;

  RxInt _mainImage = 0.obs;

  int get mainImage => _mainImage.value;

  void setMainImage(value) {
    _mainImage.value = value;

    update();
  }

  Position? position;
 
 
  void setFeaturedSelectedCountry(country) {
    _selected_country.value = country;

    _selected_state.value = StateModel(name: "");
    setCityNull();
    update();
  }

  void setFeaturedSelectedState(state) {
    _selected_state.value = state;
    setCityNull();
    update();
  }

  void setCityNull() {
    _selected_city.value = CityModel(name: "");
  }

  void setFeaturedSelectedCity(city) {
    _selected_city.value = city;
    update();
  }

  void setSelectedCategory(category) {
    _selected_category.value = category;
    update();
  }

  RxString _selectedPriceType = "Fixed Price".obs;

  String get selectedPriceType => _selectedPriceType.value;

  void setPriceType(priceType) {
    _selectedPriceType.value = priceType;
    update();
  }

  /**
   * List of products 
   * @ Getter
   */
  bool get isLoading => _isLoading.value;

  bool get isPremium => _isPremium.value;

  bool get mapLoading => _mapLoading.value;

  int get currentStep => _currentStep.value;

  double get lat => _lat.value;
  double get long => _long.value;

  @override
  void onInit() {
    super.onInit();
    getPosition();
  }

  Future<void> getPosition() async {
    bool serviceEnabled;

    LocationPermission permission;
    _mapLoading.value = true;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    await Geolocator.getCurrentPosition();

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _lat.value = position!.latitude;

    _long.value = position!.longitude;

    _mapLoading.value = false;

    update();
  }

  void setCurrenStep(step) {
    _currentStep.value = step;
    update();
  }

  void setAdPremium(type) {
    _isPremium.value = type;
    update();
  }

  void removeImageInCreate(index) {
    _imagePaths.removeAt(index);
    _imageFiles.removeAt(index);

    if (imagePaths.length == 1) {
      _mainImage.value = 0;
    }

    update();
  }

  void removeVideoInCreate(index) {
    _videoPaths.removeAt(index);

    _uint8lists!.removeAt(index);

    update();
  }






  // Images Setter AND Getter
  RxList<String> _imagePaths = RxList<String>();

  final List<XFile> _imageFiles = <XFile>[].obs;

  List<String> get imagePaths => _imagePaths.toList();


  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    try {
      final images = await _picker.pickMultiImage();

      if (images.length > 0) {
        hasImages = "Yes we have.";

        images.forEach((image) {
          _imagePaths.add(image.path);
        });

        _imageFiles.addAll(images);
      }

      // print(images);

      update();
    } catch (e) {}
  }


  // Videos Setter AND Getter
  RxList<String> _videoPaths = RxList<String>();

  final List<XFile> _videoFiles = <XFile>[].obs;

  List<String> get videoPaths => _videoPaths.toList();


  Future<void> pickVideo() async {
    try {

      if (_videoPaths.length >=5 ){

        Get.snackbar("Error", "Allowed Only 5 videos for your ad.");
        return;
      }
      var video = await _picker.pickVideo(source: ImageSource.gallery);

      _videoPaths.add(video!.path);

      _videoFiles.add(video);

      generateVideoThumb();

      update();
    } catch (e) {}
  }

  RxList? _uint8lists = [].obs;

  List get uint8lists => _uint8lists!.toList();

  Future<void> generateVideoThumb() async {
    _uint8lists!.clear();
    // for (var video in _videoPaths) {
    //   _uint8lists!.add(await VideoThumbnail.thumbnailData(
    //     video: video,
    //     imageFormat: ImageFormat.PNG,
    //     maxWidth:
    //         128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
    //     quality: 25,
    //   ));
    // }
    update();
  }

  Future<void> submitAd(context) async {
    _isLoading.value = true;

    update();

    final Map<String, dynamic> body = {
      'name': title,
      'description': description,
      'status': 'active',
      'phone_number': phone,
      'whatsapp_number': whatsapp,
      'category_id': selectedCategory.id,
      'type': isPremium ? 'premium' : 'free',
      'price_type': selectedPriceType,
      'nationality_id': selectedCountry.id,
      'state_id': selectedState.id,
      'city_id': selectedCity.id,
      'latitude': lat,
      'longitude': long,
      'image': _imagePaths[0],
      'images': _imagePaths,
      'videos': _videoPaths,
      'min_price': selectedPriceType == "fixed" ? 0 : min_price,
      'price': price
    };

    try {
      final failureOrProduct = await productUsecase.createAd(body, context);

      failureOrProduct.fold((failure) {

        _isLoading.value = false;
     
     }, (receivedData) {
        Future.delayed(Duration(milliseconds: 1000))
            .then((value) => Get.toNamed('/my_ads_screen'));
        _isLoading.value = false;
      });

      _isLoading.value = false;

      update();
    } on ValidationException catch (e) {
      Get.snackbar("Error!", e.data['message']);
      _isLoading.value = false;
      update();
    } catch (e) {
      print(e);
      Get.snackbar("Error!", 'wrong'.tr);
    }
  }


}
