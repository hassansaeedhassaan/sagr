import 'package:geolocator/geolocator.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/featured/domain/usecases/get_featured_ads.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../../countries/data/models/country_model.dart';

class FeaturedAdsController extends GetxController {
  final FeaturedAdUsecase featuredAdUsecase;

  FeaturedAdsController(this.featuredAdUsecase);

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

  final RxBool _show_search_dialog = false.obs;
  final RxBool _search_loading = false.obs;
  final RxString _keyword = "".obs;

  String get keyword => _keyword.value;
  bool get show_search_dialog => _show_search_dialog.value;
  bool get searchLoading => _search_loading.value;

  bool get available_photo_featured_secction =>
      _available_photo_featured_secction.value;

  int get selectedNegotable => _selected_negotiable.value;

  void setFeaturedSelectedCategory(category) {
    _selected_category.value = category;

    _paginationFilter.update((val) {
      val?.category_id = category.id;
      val?.page = 1;
    });

    _items.clear();
    update();
  }

  void setFeaturedSelectedCountry(country) {
    _selected_country.value = country;

    _paginationFilter.update((val) {
      val?.country_id = country.id;
      val?.page = 1;
    });

    _items.clear();
    update();
  }

  void setFeaturedSelectedMostVied(mostViewed) {
    _selected_most_viewed.value = mostViewed;

    _paginationFilter.update((val) {
      val?.created_at = mostViewed;
      val?.page = 1;
    });

    _items.clear();
    update();
  }

  void setFeaturedSelectedNegotiable(negotiable) {
    _selected_negotiable.value = negotiable;

    _paginationFilter.update((val) {
      val?.is_negotiable = negotiable;
    });

    // _items.clear();
    // _findItems();
    // _changePaginationFilter(1, 100, '', selectedCategory.id);

    update();
  }

  void toggleAvailablePhoto() {
    _available_photo_featured_secction.value =
        !_available_photo_featured_secction.value;

    _paginationFilter.update((val) {
      val?.available_photo = available_photo_featured_secction;
      val?.page = 1;
    });

    _items.clear();

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

void setSearchQuery(skeyword)  {
    _keyword.value = skeyword;


    _items.clear();

    _search_loading.value = true;



    if (_keyword.value != "") {
      _show_search_dialog.value = true;
    } else {
      _show_search_dialog.value = false;
    }


    Future.delayed(Duration(seconds: 1)).then((value) {

    _paginationFilter.value.name = _keyword.value;
    _items.clear();
      _findItems();
      _search_loading.value = false;
    });

 
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

    final failureOrProducts = await featuredAdUsecase(_paginationFilter.value);

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
