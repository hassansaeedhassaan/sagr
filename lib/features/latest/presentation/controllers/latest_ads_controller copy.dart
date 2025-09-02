import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
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
  final _selected_category = CategoryModel().obs;
  RxInt _selected_negotiable = 0.obs;

  /**
 * Rx Filters  Getter
 */
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;

  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;

  CategoryModel get selectedCategory => _selected_category.value;
  int get selectedNegotable => _selected_negotiable.value;

  void setFeaturedSelectedCategory(category) {
    _selected_category.value = category;
        _changePaginationFilter(1, 100, '', selectedCategory.id);
    _items.clear();
    _findItems();

    update();
  }


    void setFeaturedSelectedNegotiable(negotiable) {
    _selected_negotiable.value = negotiable;
    
    _paginationFilter.update((val) {
      val?.is_negotiable = negotiable;
    });

    _items.clear();
    _findItems();


    // _changePaginationFilter(1, 100, '', selectedCategory.id);

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

    _changePaginationFilter(1, 100, '', 0);
  }

  Future<void> _findItems() async {
    _productsLoading.value = products.length == 0 ? true : false;

    final failureOrProducts = await latestAdUsecase(_paginationFilter.value);

    print("🔥");

    print(failureOrProducts);

    print("😍");

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

  void _changePaginationFilter(
      int page, int limit, String? name, int? category_id) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
      val?.name = "";
      val?.category_id = category_id;
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
    _changePaginationFilter(page + 1, limit, '', selectedCategory.id);
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
