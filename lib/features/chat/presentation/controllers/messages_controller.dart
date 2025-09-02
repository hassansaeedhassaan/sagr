import 'dart:async';

import 'package:get/get.dart';
import 'package:sagr/config/app_config.dart';
import 'package:sagr/features/chat/data/models/message_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/usecases/get_conversation.dart';

class MessagesController extends GetxController {
  final ConversationUsecase conversationUsecase;

  MessagesController(this.conversationUsecase);

  RefreshController refreshController =
      Get.put(RefreshController(initialRefresh: true));

/**
 * Rx Filters  Setter
 */
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;
  final RxBool _isLoadingList = false.obs;
  final RxBool _isLoadingPay = false.obs;
  final RxString _paymentMethod = "wallet".obs;

  int conversationId = 0;

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
  final _items = <MessageModel>[].obs;

  /**
   * List of products 
   * @ Getter
   */
  List<MessageModel> get conversations => _items.toList();

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

    print(Get.arguments);
    conversationId = Get.arguments!.id;

    ever(_paginationFilter, (_) => _findItems());

    _changePaginationFilter(1, 10);
  }

  Future<void> _findItems() async {
    _isLoadingList.value = true;

    final failureOrMessages = await conversationUsecase.getMessages(
        conversationId, _paginationFilter.value);

    failureOrMessages.fold((failure) {
      _productsLoading.value = false;
    }, (receivedMessages) {
      if (receivedMessages.isEmpty) {
        _hasMore.value = false;
        _lastPage.value = true;
      }

      print("Messages @@@@@@ 👏👏  👏👏");
      print(Get.arguments);
      print("Messages @@@@@@ 👏👏  👏👏");

      if (receivedMessages.isNotEmpty) _items.addAll(receivedMessages);

      _isLoadingList.value = false;

      update();
    });
  }

  final RxString _textMessage = "".obs;

  String get textMessage => _textMessage.value;

  void setTextMessage(value) {
    _textMessage.value = value;
  }

  Future<void> sendMessage(context) async {
    final Map<String, dynamic> body = {
      'message': textMessage,
      'chat_id': conversationId,
    };

    try {
      final failureOrMessage =
          await conversationUsecase.sendMessage(body, context);
      _textMessage.value = "sadkjlasjdlkasj";
      failureOrMessage.fold((failure) {}, (receivedData) {
        _items.insert(0, MessageModel.fromJson(receivedData.data['data']));

        update();
      });

      update();
    } on ValidationException catch (e) {
      Get.snackbar("Error!", e.data['message']);
      // _isLoading.value = false;
      update();
    } catch (e) {
      print(e);
      Get.snackbar("Error!", 'wrong'.tr);
    }
  }

  void _changePaginationFilter(int page, int limit) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
      val?.name = '';
    });
  }

  RxString _status = "pendding".obs;

  String get status => _status.value;

  RxInt _updatedAdId = 0.obs;
  int get updatedAdId => _updatedAdId.value;

  RxInt _updatedOfferId = 0.obs;
  int get updatedOfferId => _updatedOfferId.value;

  Future<void> replyOnOffer(context, adId, offerId) async {
    final Map<String, dynamic> body = {
      'adId': adId,
      'offerId': offerId,
      'status': "approved",
    };
    try {
      final failureOrMessage =
          await conversationUsecase.updateOfferStatus(body, context);

      failureOrMessage.fold((failure) {}, (receivedData) {
        SharedData().showAlert(context, 'Success 🤌');

        _status.value = "approved";

      });

      update();
    } on ValidationException catch (e) {
      SharedData().showAlertError(context, '${e.data['error']} 🤌');
      // Get.snackbar("Error!", e.data['error']);
      update();
    } catch (e) {
      Get.snackbar("Error!", 'wrong'.tr);
    }
  }

  Future<void> rejectOnOffer(context, adId, offerId) async {
    final Map<String, dynamic> body = {
      'adId': adId,
      'offerId': offerId,
      'status': "rejected",
    };

    try {
      final failureOrMessage =
          await conversationUsecase.updateOfferStatus(body, context);

      failureOrMessage.fold((failure) {}, (receivedData) {
        SharedData().showAlert(context, 'Success 🤌');

        _status.value = "rejected";
      });

      update();
    } on ValidationException catch (e) {
      SharedData().showAlertError(context, '${e.data['error']} 🤌');
      // Get.snackbar("Error!", e.data['error']);
      update();
    } catch (e) {
      Get.snackbar("Error!", 'wrong'.tr);
    }
  }

  void onRefresh() async {
    _items.clear();

    _changePaginationFilter(1, limit);
    _hasMore.value = true;
    await Future.delayed(Duration(milliseconds: 1000));

    _findItems();
    refreshController.refreshCompleted();
    update();
  }

  nextPage() {
    if (_hasMore.isFalse) return;
    _changePaginationFilter(page + 1, limit);
    // update();
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
