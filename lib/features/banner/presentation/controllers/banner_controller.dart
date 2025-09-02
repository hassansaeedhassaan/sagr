import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/features/banner/data/models/banner_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../domain/usecases/get_wallet.dart';

class BannerController extends GetxController {
  final BannerUsecase walletUsecase;

  BannerController(this.walletUsecase);

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
  final RxString _paymentId = "".obs;

  final RxString _amount = "".obs;

  /**
 * Rx Filters  Getter
 */
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;
  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;
  String get paymentId => _paymentId.value;
  bool get isLoadingList => _isLoadingList.value;
  bool get isLoadingPay => _isLoadingPay.value;

  String get amount => _amount.value;

  /**
   * List of products 
   * @Setter
   */

  final _banner = BannerModel().obs;

  /**
   * List of products 
   * @ Getter
   */
  BannerModel get banner => _banner.value;

  void setAmount(amount) => _amount.value = amount;

  void setPaymentId(paymentId) {
    _paymentId.value = paymentId;
    update();
  }

  // Future<void> confirmCharge(context) async {
  //   _isLoadingPay.value = true;

  //   if (paymentId == "")
  //     SharedData().showMessage(context,
  //         message: "Select Payment Method to complete your process.");
  //   if (amount == "")
  //     SharedData()
  //         .showMessage(context, message: "Set Amount to charge your wallet.");

  //   Map<String, dynamic> body = {"amount": amount, "payment_method": paymentId};
  //   final failureOrChargeWallet = await walletUsecase.chargeWallet(body);

  //   failureOrChargeWallet.fold((l) {
  //     // Get Failure and catch exception then show erro message.
  //     final error =
  //         ErrorMessage.fromJson(l.props.single as Map<String, dynamic>);

  //     print(error);

  //     // Get.snackbar("Error!", error.error.toString());

  //     // Navigator.pop(context);
  //   }, (r) {
  //     _wallet.value = WalletModel.fromJson(r.data['data']['wallet']);

  //     if (r.data['code'] == 200) {
  //       SharedData().showMessage(context,
  //           message: r.data['message'], color: Color(0xff232323));
  //     }
  //   });

  //   _isLoadingPay.value = false;
  // }

  Future<void> payAllCommissions(context) async {
    _isLoadingPay.value = true;

    update();
    final failureOrPayCommissions = await walletUsecase();

    failureOrPayCommissions.fold((l) {
      // Get Failure and catch exception then show erro message.
      final error =
          ErrorMessage.fromJson(l.props.single as Map<String, dynamic>);

      Get.snackbar("Error!", error.error.toString());

      Navigator.pop(context);
    }, (r) {});

    _isLoadingPay.value = false;

    update();
  }

  /**
   * Products Loading 
   * @Setter
   */

  /**
   * List of products 
   * @ Getter
   */

  @override
  void onInit() {
    super.onInit();
    // ever(_wallet, (_) => _findWallet());

    _findWallet();
    // _changePaginationFilter(1, 100);
  }

  Future<void> _findWallet() async {
    _isLoadingList.value = true;
    final failureOrWallet = await walletUsecase();

    failureOrWallet.fold((failure) {}, (receivedData) {
      _banner.value = receivedData;


     print("🙄Start 01");
      print(receivedData);
     print("End 01");
      // _items.addAll(receivedCategories);

      // categoriesList.add({receivedCategories[0].id!: receivedCategories});

      // print("🙄Start 01");

      // var logger = Logger( printer: PrettyPrinter());

      // logger.d(categoriesList[0]);

      // print("End 01");
      // }

      _isLoadingList.value = false;
      update();
    });

    update();
  }

  RxBool _enableRecharge = false.obs;
  bool get enableRecharge => _enableRecharge.value;

  void onRecharage() {
    _enableRecharge.value = !_enableRecharge.value;
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
