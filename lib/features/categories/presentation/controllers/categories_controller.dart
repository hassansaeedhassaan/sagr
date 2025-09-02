import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/categories/domain/entities/category.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../domain/usecases/get_categories.dart';

class CategoriesController extends GetxController {
  final CategoriesUsecase categoriesUsecase;

  CategoriesController(this.categoriesUsecase);

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

  final _selected_category = CategoryModel().obs;
  final _selected_category_level_two = CategoryModel().obs;
  final _selected_category_level_three = CategoryModel().obs;
  final _selected_category_level_four = CategoryModel().obs;

  /**
   * List of products 
   * @Setter
   */
  final _items = <Category>[].obs;
  final _sub_items = <CategoryModel>[].obs;
  final _ssub_items = <CategoryModel>[].obs;
  final _thsub_items = <CategoryModel>[].obs;
  final _four_sub_items = <CategoryModel>[].obs;
  /**
   * List of products 
   * @ Getter
   */
  List<Category> get categories => _items.toList();
  List<CategoryModel> get subCategories => _sub_items.toList();
  List<CategoryModel> get subCategoriesTwo => _ssub_items.toList();
  List<CategoryModel> get thirdLevelSubCategories => _thsub_items.toList();
  List<CategoryModel> get fourLevelSubCategories => _four_sub_items.toList();
  // List<Map<int, List<CategoryModel>>> categoriesList = [];

  CategoryModel get selectedCategory => _selected_category.value;
  CategoryModel get selectedCategoryLevelTwo => _selected_category_level_two.value;
  CategoryModel get selectedCategoryLevelThree => _selected_category_level_three.value;
  CategoryModel get selectedCategoryLevelFour => _selected_category_level_four.value;

  void setFeaturedSelectedCategory(category) {
    // _selected_category.value = category;
    update();
  }

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

  Future<void> getChildLevelOne(int subCategoryId) async {
    _findSubCategories(subCategoryId, 'firstLevel').then((value) {
      _selected_category.value = categories
          .where((element) => element.id == subCategoryId)
          .first as CategoryModel;
    });

//     CategoryModel cat =
//         subCategories.firstWhere((element) => element.id == subCategoryId);

// // print(cat);
//     // cat.childs!.clear();
//     // cat.childs!.addAll(subCategories);

//     categoriesList.add({subCategoryId: cat.childs!});

//     print("🤌");
//     print(categoriesList);

//     var logger = Logger();

//     logger.d(categoriesList);
//     print("😋");

    update();
  }

  Future<void> getChildLevelTwo(int subCategoryId) async {


  
    _findSubCategories(subCategoryId, 'secondLevel').then((value){
       _selected_category_level_two.value = subCategories
          .where((element) => element.id == subCategoryId)
          .first;
    });

//     CategoryModel cat =
//         subCategories.firstWhere((element) => element.id == subCategoryId);

// // print(cat);
//     // cat.childs!.clear();
//     // cat.childs!.addAll(subCategories);

//     categoriesList.add({subCategoryId: cat.childs!});

//     print("🤌");
//     print(categoriesList);

//     var logger = Logger();

//     logger.d(categoriesList);
//     print("😋");

    update();
  }

  Future<void> getChildLevelThird(int subCategoryId) async {
    _findSubCategories(subCategoryId, 'thirdLevel').then((value){
       _selected_category_level_three.value = subCategoriesTwo
          .where((element) => element.id == subCategoryId)
          .first;
    });

    update();
  }


    Future<void> getChildLevelFourth(int subCategoryId) async {
    _findSubCategories(subCategoryId, 'fourLevel').then((value){
       _selected_category_level_four.value = thirdLevelSubCategories
          .where((element) => element.id == subCategoryId)
          .first;
    });

    update();
  }

  Future<void> _findItems() async {
    _productsLoading.value = categories.length == 0 ? true : false;

    final failureOrCategories =
        await categoriesUsecase(_paginationFilter.value);

    failureOrCategories.fold((failure) {
      _productsLoading.value = false;
    }, (receivedCategories) {
      if (receivedCategories.isEmpty) {
        _hasMore.value = false;
      }

      if (receivedCategories.isNotEmpty) {
        _items.addAll(receivedCategories);
        _selected_category.value = receivedCategories[0];

        _findSubCategories(1, 'firstLevel');

        // categoriesList.add({receivedCategories[0].id!: receivedCategories});

        // print("🙄Start 01");

        // var logger = Logger( printer: PrettyPrinter());

        // logger.d(categoriesList[0]);

        // print("End 01");
      }

      _productsLoading.value = false;
      update();
    });
  }

  Future<void> _findSubCategories(int? categoryId, String? type) async {
    _productsLoading.value = categories.length == 0 ? true : false;

    final failureOrCategories = await categoriesUsecase.getSubChilds(
        _paginationFilter.value, categoryId);

    failureOrCategories.fold((failure) {
      _productsLoading.value = false;
    }, (receivedCategories) {
      if (receivedCategories.isEmpty) {
        _hasMore.value = false;
      }

      if (receivedCategories.isNotEmpty) {
        if (type == 'firstLevel') {
          [_sub_items, _ssub_items, _thsub_items].forEach((element) {
            element.clear();
          });

          _sub_items.addAll(receivedCategories);
        } else if (type == 'secondLevel') {
          _ssub_items.clear();
          _thsub_items.clear();
          _ssub_items.addAll(receivedCategories);
        } else if (type == 'thirdLevel') {
          _thsub_items.clear();
          _thsub_items.addAll(receivedCategories);
        }else if (type == 'fourLevel') {
          _four_sub_items.clear();
          _four_sub_items.addAll(receivedCategories);
        }

        // categoriesList.add({categoryId!: receivedCategories});

        // print("🙄Start 01");
        // print(categoriesList.reversed);

        //  var logger = Logger( printer: PrettyPrinter());

        // logger.d(categoriesList.reversed);
        // print("End 01");

        // _findSubCategories(receivedCategories[0].id);
      }

      _productsLoading.value = false;

      update();
    });
  }

  Future<void> _findSSubCategories(int? categoryId) async {
    _productsLoading.value = categories.length == 0 ? true : false;

    final failureOrCategories = await categoriesUsecase.getSubChilds(
        _paginationFilter.value, categoryId);

    failureOrCategories.fold((failure) {
      _productsLoading.value = false;
    }, (receivedCategories) {
      if (receivedCategories.isEmpty) {
        _hasMore.value = false;
      }
      _ssub_items.clear();
      if (receivedCategories.isNotEmpty) {
        _ssub_items.addAll(receivedCategories);

        // categoriesList.add({categoryId!: receivedCategories});

        // print("🙄Start 01");
        // print(categoriesList.reversed);

        //  var logger = Logger( printer: PrettyPrinter());

        // logger.d(categoriesList.reversed);
        // print("End 01");

        // _findSubCategories(receivedCategories[0].id);
      }

      _productsLoading.value = false;

      update();
    });
  }

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
