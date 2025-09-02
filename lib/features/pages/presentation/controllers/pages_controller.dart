import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/categories/domain/entities/category.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../data/models/page_model.dart';
import '../../domain/usecases/get_categories.dart';

class PagesController extends GetxController {
  final PagesUsecase pagesUsecase;

  late String slug;

  PagesController(this.pagesUsecase, this.slug);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

/**
 * Rx Filters  Setter
 */
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;
  final RxBool _isLoading = true.obs;

  /**
 * Rx Filters  Getter
 */
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;
  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;
  bool get isLoading => _isLoading.value;
  /**
   * List of products 
   * @Setter
   */
  final _items = <Category>[].obs;
  final _sub_items = <CategoryModel>[].obs;
  final _ssub_items = <CategoryModel>[].obs;
  final _thsub_items = <CategoryModel>[].obs;
  /**
   * List of products 
   * @ Getter
   */
  List<Category> get categories => _items.toList();
  List<CategoryModel> get subCategories => _sub_items.toList();
  List<CategoryModel> get subCategoriesTwo => _ssub_items.toList();
  List<CategoryModel> get thirdLevelSubCategories => _thsub_items.toList();
  // List<Map<int, List<CategoryModel>>> categoriesList = [];

  PageModel? pageData;

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

    slug = Get.arguments;
    _findItems();
  }

//   Future<void> getChildLevelOne(int subCategoryId) async {
//     _findSubCategories(subCategoryId, 'firstLevel');

// //     CategoryModel cat =
// //         subCategories.firstWhere((element) => element.id == subCategoryId);

// // // print(cat);
// //     // cat.childs!.clear();
// //     // cat.childs!.addAll(subCategories);

// //     categoriesList.add({subCategoryId: cat.childs!});

// //     print("🤌");
// //     print(categoriesList);

// //     var logger = Logger();

// //     logger.d(categoriesList);
// //     print("😋");

//     update();
//   }

//   Future<void> getChildLevelTwo(int subCategoryId) async {
//     _findSubCategories(subCategoryId, 'secondLevel');

// //     CategoryModel cat =
// //         subCategories.firstWhere((element) => element.id == subCategoryId);

// // // print(cat);
// //     // cat.childs!.clear();
// //     // cat.childs!.addAll(subCategories);

// //     categoriesList.add({subCategoryId: cat.childs!});

// //     print("🤌");
// //     print(categoriesList);

// //     var logger = Logger();

// //     logger.d(categoriesList);
// //     print("😋");

//     update();
//   }

  // Future<void> getChildLevelThird(int subCategoryId) async {
  //   _findSubCategories(subCategoryId, 'thirdLevel');

  //   update();
  // }

  Future<void> _findItems() async {
    _productsLoading.value = categories.length == 0 ? true : false;

    final failureOrPage = await pagesUsecase(slug);

    failureOrPage.fold((failure) {
      _isLoading.value = false;
    }, (receivedPage) {
      _isLoading.value = true;
      pageData = receivedPage;

      _isLoading.value = false;
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
