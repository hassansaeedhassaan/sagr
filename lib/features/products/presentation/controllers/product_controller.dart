import 'package:image_picker/image_picker.dart';
import 'package:sagr/features/countries/data/models/country_model.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/features/products/domain/usecases/get_products.dart';
import 'package:get/get.dart';

import '../../../../../models/pagination_filter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../countries/domain/usecases/get_countries.dart';
import '../../data/models/city_model.dart';
import '../../data/models/state_model.dart';

class ProductController extends GetxController {
  final ProductUsecase productUsecase;

  final CountriesUsecase countriesUsecase;

  ProductController(this.productUsecase, this.countriesUsecase);

/// Rx Filters  Setter

  Product? product;

  /// Products Loading 
  /// @Setter
  RxBool _productsLoading = false.obs;
  RxBool _status = false.obs;
  RxBool _sold = false.obs;
  RxString _productImage = "".obs;
  /// List of products 
  /// @ Getter
  bool get productsLoading => _productsLoading.value;
  bool get status => _status.value;
  bool get sold => _sold.value;
  String get productImage => _productImage.value;

  void toggleStatus() {
    _status.value = !_status.value;

    update();
  }

  void toggleSold() {
    _sold.value = !_sold.value;

    update();
  }

  Product? get product1 => product;

  @override
  void onInit() {
    super.onInit();

    // Get Product Info And set main image.
    getProductInfo().then((value) {
      _productImage.value = product!.image!;
    });
  }

  void setProductImage(image) {
    _productImage.value = image;

    update();
  }

  RxList? _uint8lists = [].obs;

  List get uint8lists => _uint8lists!.toList();

  Future<void> generateVideoThumb(product) async {
    // for (var video in product!.videos) {
    //   _uint8lists!.add(await VideoThumbnail.thumbnailFile(
    //     video: video['file'],

    //     imageFormat: ImageFormat.WEBP,
    //     maxHeight:
    //         64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //     quality: 25,
    //   ));
    // }

    update();
  }

  RxString _cName = "".obs;
  String get categoryName => _cName.value;

  var _selected_country = CountryModel().obs;
  CountryModel get selectedCountry => _selected_country.value;

  final _selected_state = StateModel(name: '').obs;
  StateModel get selectedState => _selected_state.value;

  final _selected_city = CityModel(name: '').obs;

  CityModel get selectedCity => _selected_city.value;

  RxString _type = "".obs;
  String get type => _type.value;

  RxString _priceType = "".obs;
  String get priceType => _priceType.value;

  String? title = '';
  String? description = '';

  String? phone = '';
  String? whatsapp = '';
  String? price = '';
  String? maxPrice = '';
  String? minPrice = '';
  int? categoryId;

  List<StateModel> initStates = [];

  final _paginationFilter = PaginationFilter().obs;

  Future<void> getProductInfo() async {
    _productsLoading.value = true;

    final failureOrProduct = await productUsecase.productInfo(Get.arguments);

    failureOrProduct.fold((failure) {
      _productsLoading.value = false;
    }, (receivedProduct) async {
      // receivedProduct.images!
      //     .add({"id": 0, "file": receivedProduct.image, "type": "image"});



      receivedProduct.videos!.addAll(uint8lists);

      // generateVideoThumb(receivedProduct);

      product = receivedProduct;

      title = product!.name;
      description = product!.description;
      phone = product!.phone_number;
      whatsapp = product!.whatsapp_number;

      if (product!.category != null) {
        _cName.value = product!.category!.name!;
        categoryId = product!.category!.id;
      } else {
        _cName.value = "Category".tr;
        categoryId = 0;
      }

      _selected_country.value = CountryModel.fromJson(
          {'id': product!.nationality.id, 'name': product!.nationality.name});

      _selected_state.value = StateModel.fromJson(
          {'id': product!.state!.id, 'name': product!.state!.name});

      _selected_city.value = CityModel.fromJson(
          {'id': product!.city!.id, 'name': product!.city!.name});

      // Get all countries here to fill states and cities of current ad.
      getCountriesData();

      _type.value = product!.type!;

      _sold.value = product!.isSold == "0" ? false : true;

      _priceType.value = product!.price_type!;

      price = product!.price;





      if (product!.images!.length > 0) {
        product!.images!.forEach((image) {
          _adImages.add({
            'id': image['id'],
            'path': image['file'],
            'type': 'retrivedImage'
          });
        });
      }



      // generate thumbs for saved videos
      // generateVideoThumb(product);

      // if (product!.status! != null) {
      //   _status.value = true;
      // }

      if (product!.isSold! != '') {
        _sold.value = true;
      }

      _productsLoading.value = false;

      update();
    });
  }

  RxBool _fetingCountry = false.obs;

  bool get fetching => _fetingCountry.value;

  Future<void> getCountriesData() async {
    _fetingCountry.value = true;

    _paginationFilter.value.page = 1;
    _paginationFilter.value.limit = 100;

    final failureOrCountries = await countriesUsecase(_paginationFilter.value);

    failureOrCountries.fold((failure) {
      // _isLoading.value = false;
    }, (receivedData) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        receivedData.forEach((country) {
          if (country.id == product!.nationality.id) {
            country.states!.length > 0
                ? _selected_country.value.states!.addAll(country.states!)
                : [];
          }
        });

        selectedCountry.states!.forEach((state) {
          if (state.id == product!.state!.id) {
            _selected_state.value = state;
          }
        });

        _fetingCountry.value = false;

        update();
      });
    });
  }

  void setCurrentCategory(category) {
    _cName.value = category!.name;

    categoryId = category!.id;

    update();
  }

  void updateAdType(type) {
    _type.value = type;

    update();
  }

  void removeImageInUpdate(path) {
    _imagePaths.removeWhere((ele) => ele == path);

    _adImages.removeWhere((image) => image['path'] == path);

    update();
  }

  void updateAdPriceType(type) {
    _priceType.value = type == 'Fixed Price' ? 'fixed' : 'offer_price';

    update();
  }

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

  Future<void> updateAd(int page) async {
    Map<String, dynamic> body = {
      'id': Get.arguments,
      'current_step': page,
      'price_type': priceType,
      'price': priceType == 'fixed' ? price : 0,
      'min_price': priceType != 'fixed' ? minPrice : 0,
      'max_price': priceType != 'fixed' ? maxPrice : 0,
      'currency': "EGP",
    };
    if (page == 3) {
      body = {
        ...body,
        'country_id': selectedCountry.id,
        'state_id': selectedState.id,
        'city_id': selectedCity.id
      };
    } else if (page == 2) {
      body = {
        ...body,
        'category_id': categoryId,
        'name': title,
        'description': description,
        'phone': phone,
        'whatsapp': whatsapp,
        'type': type,
        'isSold': sold,
        'status': "active",
      };
    } else if (page == 1) {
      body = {
        ...body,
        'image': adImages.where((element) => element['type'] == 'file').first['path'],
        'images': adImages.where((element) => element['type'] == "file").toList(),
        'videos': _videoPaths,
      };
    } else {
      body = {...body};
    }



// print(body);
//     return;

    try {
      final failureOrCustomer = await productUsecase.updateAd(body);

      failureOrCustomer.fold((failure) {
        // _isLoading.value = false;
      }, (receivedData) {
        print(receivedData);
        // Future.delayed(Duration(milliseconds: 1000))
        //     .then((value) => Get.offAllNamed('/login'));

        // _isLoading.value = false;
      });

      update();

      // _isLoading.value = false;

      update();
    } on ValidationException catch (e) {
      Get.snackbar("Error!", e.data['message']);
      // _isLoading.value = false;
      update();
    } catch (e) {
      print(e);
      Get.snackbar("Error!", 'wrong'.tr);
    }
  }

  Future<void> deleteMedia({required adId, required mediaId}) async {
    final failureOrDeleted = await productUsecase.deleteAd(adId, mediaId);

    failureOrDeleted.fold((failure) {
      print(failure);
    }, (receivedData) {
      if (receivedData.data['code'] == 200) {
        print(receivedData);

        Get.snackbar("Success", receivedData.data['message']);
      }
    });
  }

  // Images Setter AND Getter
  RxList<Map<String, dynamic>> _adImages = RxList<Map<String, dynamic>>();

  List<Map<String, dynamic>> get adImages => _adImages.toList();

  // Images Setter AND Getter
  RxList<String> _imagePaths = RxList<String>();

  // final List<XFile> _imageFiles = <XFile>[].obs;
  

  List<String> get imagePaths => _imagePaths.toList();

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    try {
      final images = await _picker.pickMultiImage();

      if (images.length > 0) {
        images.forEach((image) {

         _adImages.add({
            'id': DateTime.now().timeZoneName,
            'path': image.path,
            'type': 'file'
          });
          // _imagePaths.add(image.path);
        });

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
      if (_videoPaths.length >= 5) {
        Get.snackbar("Error", "Allowed Only 5 videos for your ad.");
        return;
      }
      var video = await _picker.pickVideo(source: ImageSource.gallery);

      _videoPaths.add(video!.path);

      _videoFiles.add(video);

      generateVideoThumb(product);

      update();
    } catch (e) {}
  }
}
