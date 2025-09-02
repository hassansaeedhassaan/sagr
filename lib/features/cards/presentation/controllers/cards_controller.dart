import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/config/app_config.dart';
import 'package:sagr/features/cards/data/models/card_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:stripe_payment/stripe_payment.dart';

import '../../../../../models/pagination_filter.dart';
import '../../domain/usecases/get_cards.dart';
import 'package:http/http.dart' as http;

class CardsController extends GetxController {
  final CardUsecase _cardUsecase;

  CardsController(this._cardUsecase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

/**
 * Rx Filters  Setter
 */
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;
  final RxBool _isLoadingList = false.obs;
  final RxBool _isLoadingSave = false.obs;
  final RxString _paymentMethod = "wallet".obs;

  final RxBool _agree = false.obs;

  bool get agree => _agree.value;

  /**
 * Rx Filters  Getter
 */
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;
  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;
  String get paymentMethod => _paymentMethod.value;
  bool get isLoadingList => _isLoadingList.value;
  bool get isLoadingSave => _isLoadingSave.value;

  /**
   * List of products 
   * @Setter
   */
  final _items = <CardModel>[].obs;

  /**
   * List of products 
   * @ Getter
   */
  List<CardModel> get cards => _items.toList();

  void setFeaturedSelectedCategory(category) {
    // _selected_category.value = category;
    update();
  }

  void setPaymentMethod(paymentMethod) {
    _paymentMethod.value = paymentMethod;
    update();
  }

  Future<void> payAllCommissions(context) async {
    _isLoadingSave.value = true;

    update();
    final failureOrPayCommissions = await _cardUsecase.addCard(paymentMethod);

    failureOrPayCommissions.fold((l) {
      // Get Failure and catch exception then show erro message.
      final error =
          ErrorMessage.fromJson(l.props.single as Map<String, dynamic>);

      Get.snackbar("Error!", error.error.toString());

      Navigator.pop(context);
    }, (r) {});

    _isLoadingSave.value = false;

    update();
  }


  void setAgreeTermsAndConditions(){
    _agree.value = !_agree.value;
    _isLoadingSave.value = false;
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
    // ever(_paginationFilter, (_) => _findItems());

    _findItems();

    // _changePaginationFilter(1, 100);
  }

  Future<void> _findItems() async {
    _isLoadingList.value = true;

    final failureOrCategories = await _cardUsecase(_paginationFilter.value);

    failureOrCategories.fold((failure) {
      _productsLoading.value = false;
    }, (receivedCategories) {
      if (receivedCategories.isEmpty) {
        _hasMore.value = false;
      }

      if (receivedCategories.isNotEmpty) {
        _items.addAll(receivedCategories);

        // categoriesList.add({receivedCategories[0].id!: receivedCategories});

        // print("🙄Start 01");

        // var logger = Logger( printer: PrettyPrinter());

        // logger.d(categoriesList[0]);

        // print("End 01");

        update();
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

// CREATE NEW CARD

  String? card_name = "";

  String? card_number = "";
  String? card_ccv = "";
  String? card_expire_date = "";
  String? month = "";
  String? year = "";

  Future<void> saveCard(context) async {
    _isLoadingSave.value = true;
    final month_year = card_expire_date!.split("/");

    if (month_year.length == 2) {
      month = month_year.elementAt(0);
      year = month_year.elementAt(1);
    } else {
      //Interactive toast, set [isIgnoring] false.
      SharedData().showMessage(context, message: "Please, Check Expire date is correct date.");
      _isLoadingSave.value = false;
      return;
    }




print("🙄");
print(agree);
print("🙄");


    if(agree != true){
       SharedData().showMessage(context, message: "Agree on terms and conditions required!.");
           _isLoadingSave.value = false;
       return;
    }

    card_number = card_number!.split('-').join('');

    final _paymentMethod = await _createPaymentMethod(
        number: card_number!, expMonth: month!, expYear: year!, cvc: card_ccv!);

    if (_paymentMethod['error'] != null) {
      print(_paymentMethod['error']['message']);
    } else {
      print(_paymentMethod);

      _isLoadingSave.value = true;

      update();
      final failureOrAddCard = await _cardUsecase.addCard(_paymentMethod['id']);

      failureOrAddCard.fold((l) {
        // Get Failure and catch exception then show erro message.
        final error =
            ErrorMessage.fromJson(l.props.single as Map<String, dynamic>);

        Get.snackbar("Error!", error.message.toString());

        // Navigator.pop(context);
      }, (receivedData) {
        _items.clear();
        _findItems();
        Get.toNamed("/cards_screen");
      });

      _isLoadingSave.value = false;

      update();
    }
    return;

// final _stripePayment = FlutterStripePayment();

// _stripePayment.setStripeSettings("pk_test_51LlXuFJg3mWJNbfM4ccLssXcp2E3Mtwy65cbwcvPgo1Mcm0UeCcEJuiw5Vy7OHLXKdWnosSFwIFvsDtGpkQEmHTx008ifr3Afg");

// var paymentResponse = await _stripePayment.addPaymentMethod();
// if(paymentResponse.status == PaymentResponseStatus.succeeded)
//   {
//     print(paymentResponse.paymentMethodId);

//     // return paymentResponse.paymentMethodId;
//   }

// StripePayment.setOptions(
//   StripeOptions(
//     publishableKey: "pk_test_51LlXuFJg3mWJNbfM4ccLssXcp2E3Mtwy65cbwcvPgo1Mcm0UeCcEJuiw5Vy7OHLXKdWnosSFwIFvsDtGpkQEmHTx008ifr3Afg",
//     merchantId: "any data",
//     androidPayMode: 'test',
//   ),
// );

// final result = await StripePayment.paymentRequestWithCardForm(
//   CardFormPaymentRequest(),
// );

// print(result);

// PaymentMethod paymentMethod = PaymentMethod();
//   paymentMethod = await StripePayment.paymentRequestWithCardForm(
//     CardFormPaymentRequest(),
//   ).then((PaymentMethod paymentMethod) {
//     return paymentMethod;
//   }).catchError((e) {
//     print('Errore Card: ${e.toString()}');
//   });

// Stripe.instance.createPlatformPayPaymentMethod(params: PlatformPayPaymentMethodParams.applePay(applePayParams: ApplePayParams(merchantCountryCode: "SA", currencyCode: "SAR", cartItems: [])));
// final yyt = Stripe.instance.createPaymentMethod(params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData(shippingDetails: ShippingDetails(
//     phone: '+48888000888',
//     address: Address(
//       city: 'Houston',
//       country: 'US',
//       line1: '1459  Circle Drive',
//       line2: '',
//       state: 'Texas',
//       postalCode: '77063',
//     ),
//   ))));

    // print(yyt.toString());

    // return;
// try {
//       //STEP 1: Create Payment Intent
//      var  paymentIntent = await createPaymentIntent('100', 'USD');

//      print(paymentIntent);

// // return paymentIntent;
//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(

//               paymentSheetParameters: SetupPaymentSheetParameters(
//                   paymentIntentClientSecret: paymentIntent!['client_secret'], //Gotten from payment intent
//                   style: ThemeMode.light,
//                   merchantDisplayName: 'Ikay'))
//           .then((value) {

//             print("HHAHHAHAHAHHAHAHHA");
//           });

//       //STEP 3: Display Payment sheet
//       displayPaymentSheet(context);
//     } catch (err) {
//       throw Exception(err);
//     }
  }

  Future<Map<String, dynamic>> _createPaymentMethod(
      {required String number,
      required String expMonth,
      required String expYear,
      required String cvc}) async {
    final String url = 'https://api.stripe.com/v1/payment_methods';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer sk_test_51LlXuFJg3mWJNbfMeNLp6Zm5AxNRMykyH0TfrkP1gfYyySQGOox4SrxgjJgrmF8AhkOIw5k4o9Ylix5pv9IZsCSb00TDCocRTN',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {
        'type': 'card',
        'card[number]': '$number',
        'card[exp_month]': '$expMonth',
        'card[exp_year]': '$expYear',
        'card[cvc]': '$cvc',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
      print(json.decode(response.body));
      // throw 'Failed to create PaymentMethod.';
    }
  }

  displayPaymentSheet(context) async {
    // try {
    //   await Stripe.instance.presentPaymentSheet().then((value) {
    //     showDialog(
    //         context: context,
    //         builder: (_) => AlertDialog(
    //               content: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: const [
    //                    Icon(
    //                     Icons.check_circle,
    //                     color: Colors.green,
    //                     size: 100.0,
    //                   ),
    //                   SizedBox(height: 10.0),
    //                   Text("Payment Successful!"),
    //                 ],
    //               ),
    //             ));

    //     // paymentIntent = null;
    //   }).onError((error, stackTrace) {
    //     throw Exception(error);
    //   });
    // } on StripeException catch (e) {
    //   print('Error is:---> $e');
    //   AlertDialog(
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Row(
    //           children: const [
    //             Icon(
    //               Icons.cancel,
    //               color: Colors.red,
    //             ),
    //             Text("Payment Failed"),
    //           ],
    //         ),
    //       ],
    //     ),
    //   );
    // } catch (e) {
    //   print('$e');
    // }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': "2000",
        'currency': "USD",
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51LlXuFJg3mWJNbfMeNLp6Zm5AxNRMykyH0TfrkP1gfYyySQGOox4SrxgjJgrmF8AhkOIw5k4o9Ylix5pv9IZsCSb00TDCocRTN',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      print("😂😂😂😂😂😂😂😂😂😂");
      print(json.decode(response.body));
      print("😂😂😂😂😂😂😂😂😂😂");

      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}

class ErrorMessage {
  final int? code;
  final String? error;
  final String? message;
  final Map<String, dynamic>? errors;

  const ErrorMessage({this.code, this.error, this.message, this.errors});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
        code: json['code'],
        error: json['error'],
        message: json['message'],
        errors: json['errors']);
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'error': error, 'message': message, 'errors': errors};
  }
}
