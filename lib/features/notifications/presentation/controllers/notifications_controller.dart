import 'package:dio/dio.dart' show Dio;
import 'package:sagr/helper/base_url.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:sagr/features/notifications/data/models/notification_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../domain/usecases/get_commissions.dart';

class NotificationsController extends GetxController {
  final NotificationsUsecase notificationsUsecase;

  NotificationsController(this.notificationsUsecase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

/**
 * Rx Filters  Setter
 */
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;
  final RxBool _isLoadingList = false.obs;
  final RxBool _isLoadingPay = false.obs;
  final RxString _paymentMethod = "wallet".obs;

  /**
 * Rx Filters  Getter
 */
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;
  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;
  String get paymentMethod => _paymentMethod.value;
    bool get isLoadingList => _isLoadingList.value;
    bool get isLoadingPay => _isLoadingPay.value;

  /**
   * List of products 
   * @Setter
   */
  final _items = <NotificationModel>[].obs;

  /**
   * List of products 
   * @ Getter
   */
  List<NotificationModel> get notifications => _items.toList();

  void setFeaturedSelectedCategory(category) {
    // _selected_category.value = category;
    update();
  }

  void setPaymentMethod(paymentMethod) {
    _paymentMethod.value = paymentMethod;
    update();
  }

  // Future<void> payAllCommissions(context) async {
  //   _isLoadingPay.value = true;
   
  //      update();
  //   final failureOrPayCommissions =
  //       await notificationsUsecase.getNotificationsList(paymentMethod);

  //   failureOrPayCommissions.fold((l) {

  //     // Get Failure and catch exception then show erro message.
  //     final error =
  //         ErrorMessage.fromJson(l.props.single as Map<String, dynamic>);

  //     Get.snackbar("Error!", error.error.toString());

  //     Navigator.pop(context);
     

  //   }, (r) {});

  //   _isLoadingPay.value = false;

  //   update();
  // }

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

    _changePaginationFilter(1, 20);
  }

  Future<void> _findItems() async {
_isLoadingList.value = true;

    final failureOrCategories =
        await notificationsUsecase(_paginationFilter.value);

    failureOrCategories.fold((failure) {
      // Clear the loader on failure too, or the screen spins forever.
      _productsLoading.value = false;
      _isLoadingList.value = false;
      _hasMore.value = false;
      update();
    }, (receivedCategories) {
      if (receivedCategories.length < limit) {
        _hasMore.value = false;
      }

      // Page 1 replaces the list (first load or pull-to-refresh).
      if (page <= 1) {
        _items.clear();
        _markAllRead();
      }

      if (receivedCategories.isNotEmpty) {
        _items.addAll(receivedCategories);

        // categoriesList.add({receivedCategories[0].id!: receivedCategories});

        // appLog("🙄Start 01");

        // var logger = Logger( printer: PrettyPrinter());

        // logger.d(categoriesList[0]);

        // appLog("End 01");
      }

      _isLoadingList.value = false;
      update();
    });
  }

  /// Opening the list counts as reading it; best effort.
  Future<void> _markAllRead() async {
    if (!Get.isRegistered<Dio>()) return;
    try {
      await Get.find<Dio>().post('$BASEURL/notifications/read');
    } catch (_) {}
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
    _hasMore.value = true;
    if (page == 1) {
      await _findItems();
    } else {
      _changePaginationFilter(1, limit);
    }
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

class ErrorMessage {
  final int? code;
  final String? error;

  const ErrorMessage({
    this.code,
    this.error,
  });

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(code: json['code'], error: json['error']);
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'error': error,
    };
  }
}
