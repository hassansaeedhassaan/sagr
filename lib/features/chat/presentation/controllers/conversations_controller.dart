import 'dart:async';

import 'package:get/get.dart';
import 'package:sagr/features/chat/data/models/conversation_model.dart';
import 'package:sagr/features/chat/presentation/screens/conversations_list_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../domain/usecases/get_conversation.dart';

class ConversationsController extends GetxController {
  final ConversationUsecase conversationUsecase;

  ConversationsController(this.conversationUsecase);

  RefreshController refreshController = RefreshController(
      initialRefresh: false, initialRefreshStatus: RefreshStatus.canRefresh);

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
  final _items = <ConversationModel>[].obs;

  /**
   * List of products 
   * @ Getter
   */
  List<ConversationModel> get conversations => _items.toList();

  void setFeaturedSelectedCategory(category) {
    // _selected_category.value = category;
    update();
  }

  void setPaymentMethod(paymentMethod) {
    _paymentMethod.value = paymentMethod;
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

    _changePaginationFilter(1, 15);
  }

  Future<void> openChat(adId, context) async {
    print(adId);
// print(context);

    final conversationOpenChat =
        await conversationUsecase.openChat(adId, context);

    print(conversationOpenChat);

    conversationOpenChat.fold((failure) {
      _productsLoading.value = false;
    }, (receivedConversations) {
      if (receivedConversations.statusCode == 200) {
        Get.to(() => ConversationListScreen(Get.find()));
      }

      _isLoadingList.value = false;
      update();
    });
  }

  Future<void> _findItems() async {
    _isLoadingList.value = true;

    final failureOrConversations =
        await conversationUsecase(_paginationFilter.value);

    failureOrConversations.fold((failure) {
      _productsLoading.value = false;
    }, (receivedConversations) {
      if (receivedConversations.isEmpty) {
        _hasMore.value = false;
        _lastPage.value = true;
      }

      if (receivedConversations.isNotEmpty) {
        _items.addAll(receivedConversations);
      }

      _isLoadingList.value = false;
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
    _items.clear();
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _paginationFilter.value.page = 1;
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



  String offerPrice = "";

 

  Future<void> sendOffer(int adId, context) async {
    final conversationSendOffer =
        await conversationUsecase.sendOffer(adId, offerPrice , context);


    conversationSendOffer.fold((failure) {
      _productsLoading.value = false;
    }, (receivedConversations) {
      if (receivedConversations.statusCode == 200) {

          Get.to( () => ConversationListScreen(Get.find()));

      }

      _isLoadingList.value = false;
      update();
    });
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
