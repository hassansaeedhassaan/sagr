import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:sagr/features/products/domain/usecases/get_products.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';

class RelatedAdsController extends GetxController {
  final ProductUsecase productUsecase;
  final int adId;

  RelatedAdsController(this.productUsecase, this.adId);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

/**
 * Rx Filters  Setter
 */
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;

  /**
 * Rx Filters  Getter
 */
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;
  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;

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
_findItems();
  }

  Future<void> _findItems() async {



    _productsLoading.value = products.length == 0 ? true: false;

    final failureOrProducts = await productUsecase.getRelatedAds(adId);
    
      print("🤌🤌🤌🤌🤌🤌🤌🤌🤌🤌🤌");
      print(failureOrProducts);
    print("🤌🤌🤌🤌🤌🤌🤌🤌🤌🤌🤌");


    failureOrProducts.fold((failure) {

      _productsLoading.value = false;

    }, (receivedProducts) {
      if (receivedProducts.isEmpty) {
        _hasMore.value = false;
      }

      print("🤌🤌🤌🤌🤌🤌🤌🤌🤌🤌🤌");
      print(receivedProducts);
    print("🤌🤌🤌🤌🤌🤌🤌🤌🤌🤌🤌");

      if (receivedProducts.isNotEmpty) {
        _items.addAll(receivedProducts);
      }

      _productsLoading.value = false;
      update();
    });
// _items.addAll(productsData);

    // printInfo(info: "_findItems $_paginationFilter");
    // _isLoading.value = true;
    // final  productsData =
    //     await _productRepository.findAll(_paginationFilter.value);
    // if (productsData.isEmpty) {
    //   _lastPage.value = true;
    //   _hasMore.value = false;
    // }

    // _isLoading.value = false;
  }

  void _changePaginationFilter(int page, int limit) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
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
    _changePaginationFilter(page + 1, limit);
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
