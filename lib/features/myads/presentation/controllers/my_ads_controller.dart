import 'package:sagr/features/myads/domain/usecases/get_my_ads.dart';
import 'package:sagr/features/products/domain/entities/product.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';

class MyAdsController extends GetxController {
  final MyAdsUsecase myAdsUsecase;

  MyAdsController(this.myAdsUsecase);

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
  RxBool _isLoading = false.obs;

  /**
   * List of products 
   * @ Getter
   */
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    ever(_paginationFilter, (_) => _findItems());

    _changePaginationFilter(1, 100);
  }

  Future<void> _findItems() async {

    _isLoading.value = true;

    final failureOrProducts = await myAdsUsecase(_paginationFilter.value);

    failureOrProducts.fold((failure) {

      _isLoading.value = false;

    }, (receivedProducts) {
      if (receivedProducts.isEmpty) {
        _hasMore.value = false;
      }


      print("object🔥🔥🔥🔥🔥🔥");

      print(receivedProducts);
      print("object🔥🔥🔥🔥🔥🔥");
      if (receivedProducts.isNotEmpty) {
        _items.addAll(receivedProducts);
      }

      _isLoading.value = false;
      update();
    });

  }

  void _changePaginationFilter(int page, int limit) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
    });
  }

  Future<void> onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _items.clear();
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
