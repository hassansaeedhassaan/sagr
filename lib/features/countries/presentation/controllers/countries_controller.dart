import 'package:get/get.dart';
import 'package:sagr/features/countries/domain/entities/country.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../domain/usecases/get_countries.dart';

class CountriesController extends GetxController {
  final CountriesUsecase countriesUsecase;

  CountriesController(this.countriesUsecase);

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
  final _items = <Country>[].obs;
  // final _sub_items = <CategoryModel>[].obs;
  // final _ssub_items = <CategoryModel>[].obs;
  // final _thsub_items = <CategoryModel>[].obs;
  /**
   * List of products 
   * @ Getter
   */
  List<Country> get countries => _items.toList();
  // List<CategoryModel> get subCategories => _sub_items.toList();
  // List<CategoryModel> get subCategoriesTwo => _ssub_items.toList();
  // List<CategoryModel> get thirdLevelSubCategories => _thsub_items.toList();
  // List<Map<int, List<CategoryModel>>> categoriesList = [];

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
    _changePaginationFilter(1, 100);
  }

  // Future<void> getChildLevelOne(int subCategoryId) async {
  //   _findSubCategories(subCategoryId, 'firstLevel');
  //   update();
  // }


  // Future<void> getChildLevelTwo(int subCategoryId) async {
  //   _findSubCategories(subCategoryId, 'secondLevel');
  //   update();
  // }

  // Future<void> getChildLevelThird(int subCategoryId) async {
  //   _findSubCategories(subCategoryId, 'thirdLevel');

  //   update();
  // }


  Future<void> _findItems() async {
    _productsLoading.value =   true;

    final failureOrCategories =
        await countriesUsecase(_paginationFilter.value);

    failureOrCategories.fold((failure) {
      _productsLoading.value = false;
    }, (receivedCategories) {
      if (receivedCategories.isEmpty) {
        _hasMore.value = false;
      }

      if (receivedCategories.isNotEmpty) {
        _items.addAll(receivedCategories);
      }

      _productsLoading.value = false;
      update();
    });
  }

  // Future<void> _findSubCategories(int? categoryId, String? type ) async {
  //   _productsLoading.value = categories.length == 0 ? true : false;

  //   final failureOrCategories = await categoriesUsecase.getSubChilds(
  //       _paginationFilter.value, categoryId);

  //   failureOrCategories.fold((failure) {
  //     _productsLoading.value = false;
  //   }, (receivedCategories) {
  //     if (receivedCategories.isEmpty) {
  //       _hasMore.value = false;
  //     }
    
  //     if (receivedCategories.isNotEmpty) {
  //       if(type == 'firstLevel'){

  //         [_sub_items, _ssub_items, _thsub_items].forEach((element) {
  //           element.clear();
  //         }); 

  //       _sub_items.addAll(receivedCategories);
  //       }else  if(type == 'secondLevel'){
  //       _ssub_items.clear();
  //       _thsub_items.clear();
  //       _ssub_items.addAll(receivedCategories);
  //       }else  if(type == 'thirdLevel'){
  //       _thsub_items.clear();
  //       _thsub_items.addAll(receivedCategories);
  //       }


  //       // categoriesList.add({categoryId!: receivedCategories});

  //       // print("🙄Start 01");
  //       // print(categoriesList.reversed);

  //       //  var logger = Logger( printer: PrettyPrinter());

  //       // logger.d(categoriesList.reversed);
  //       // print("End 01");

  //       // _findSubCategories(receivedCategories[0].id);
  //     }

  //     _productsLoading.value = false;

  //     update();
  //   });
  // }

// Future<void> _findSSubCategories(int? categoryId) async {
//     _productsLoading.value = categories.length == 0 ? true : false;

//     final failureOrCategories = await categoriesUsecase.getSubChilds(
//         _paginationFilter.value, categoryId);

//     failureOrCategories.fold((failure) {
//       _productsLoading.value = false;
//     }, (receivedCategories) {
//       if (receivedCategories.isEmpty) {
//         _hasMore.value = false;
//       }
//       _ssub_items.clear();
//       if (receivedCategories.isNotEmpty) {
//         _ssub_items.addAll(receivedCategories);

//         // categoriesList.add({categoryId!: receivedCategories});

//         // print("🙄Start 01");
//         // print(categoriesList.reversed);

//         //  var logger = Logger( printer: PrettyPrinter());

//         // logger.d(categoriesList.reversed);
//         // print("End 01");

//         // _findSubCategories(receivedCategories[0].id);
//       }

//       _productsLoading.value = false;

//       update();
//     });
//   }

  void _changePaginationFilter(int page, int limit) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
      val?.name = '';
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
