
import 'package:geolocator/geolocator.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../../countries/data/models/country_model.dart';
import '../../domain/usecases/get_latest_ads.dart';

class LatestAdsController extends GetxController {
  final LatestAdUsecase latestAdUsecase;

  LatestAdsController(this.latestAdUsecase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

/**
 * Rx Filters  Setter
 */
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;



  final RxBool _nearBy = false.obs;
  final _selected_most_viewed = "".obs;
  final _selected_category = CategoryModel().obs;
  final _selected_country = CountryModel().obs;
  RxInt _selected_negotiable = 0.obs;
  final RxBool _available_photo_featured_secction = false.obs;

  /**
 * Rx Filters  Getter
 */
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;

  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;

  bool get nearBy => _nearBy.value;

  CategoryModel get selectedCategory => _selected_category.value;
  CountryModel get selectedCountry => _selected_country.value;
  String get selectedMostViewed => _selected_most_viewed.value;

  bool get available_photo_featured_secction =>
      _available_photo_featured_secction.value;

  int get selectedNegotable => _selected_negotiable.value;

  void setFeaturedSelectedCategory(category) {
    _selected_category.value = category;
    _paginationFilter.update((val) {
      val?.category_id = category.id;
    });
    _items.clear();
    update();
  }


  void setFeaturedSelectedCountry(country) {
   
    _selected_country.value = country;
   
    _paginationFilter.update((val) {
      val?.country_id = country.id;
    });

    _items.clear();

    update();
  }


  void setFeaturedSelectedMostVied(mostViewed) {
    _selected_most_viewed.value = mostViewed;

    _paginationFilter.update((val) {
      val?.created_at = mostViewed;
    });

    _items.clear();
    update();
  }




  void toggleAvailablePhoto() {

    // _productsLoading.value = true;
    _available_photo_featured_secction.value =
        !_available_photo_featured_secction.value;

    _paginationFilter.update((val) {
      val?.available_photo = available_photo_featured_secction;
    });

    _items.clear();

    // _productsLoading.value = false;
    update();
  }

  Future<void> nearByFilter() async {
    _nearBy.value = !_nearBy.value;

    _paginationFilter.update((val) {
      val?.nearBy = nearBy;
    });

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);



    if (nearBy == true) {
      _paginationFilter.update((val) {
        val?.lat = position.latitude;
        val?.long = position.longitude;
      });
    }

    // print(_paginationFilter.value);

_items.clear();

    update();
  }

  /**
   * List of products 
   * @Setter
   */
  final _items = <Product>[].obs;

  /**
   * List of products 
   * @ Getter
   */
  List<Product> get products => _items.toList();

  /**
   * Products Loading 
   * @Setter
   */
  RxBool _productsLoading = false.obs;

  /**
   * List of products 
   * @ Getter
   */
  bool get productsLoading => _productsLoading.value;

  @override
  void onInit() {
    super.onInit();
    ever(_paginationFilter, (_) => _findItems());

    _changePaginationFilter(1, 100, '');
  }

  Future<void> _findItems() async {
    _productsLoading.value = true;
    // _productsLoading.value = products.length == 0 ? true : false;

    final failureOrProducts = await latestAdUsecase(_paginationFilter.value);

    failureOrProducts.fold((failure) {
      _productsLoading.value = false;
    }, (receivedProducts) {
      if (receivedProducts.isEmpty) {
        _hasMore.value = false;
      }

      if (receivedProducts.isNotEmpty) {
        _items.addAll(receivedProducts);
      }

      _productsLoading.value = false;
      update();
    });
  }

  void _changePaginationFilter(int page, int limit, String? name) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
      val?.name = "";
      // val?.is_negotiable = isNegotiable;
    });
  }

  void onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // _items.clear();
    _findItems();
    refreshController.refreshCompleted();
  }

  nextPage() {
    if (_hasMore.isFalse) return;
    _changePaginationFilter(page + 1, limit, '');
    update();
  }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    nextPage();
    refreshController.loadComplete();
    update();
  }
}
