
import 'package:get/get.dart';

import '../../../../exceptions/rest_exception.dart';

class ForgotPasswordController extends GetxController {
   ForgotPasswordController();


  late String phone, password, code;
  RxBool isLoading = false.obs;



  RxString _confim_code = "".obs;


  String get confirm_code => _confim_code.value;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setConfirmCode(code) {
    _confim_code.value = code;
    update();
  }

  Future<dynamic> forgot() async {
    isLoading.value = true;
    try {



   
      // await _forgotPasswordService.forgot(phone).then((data) {
      //   if (data['status'] == 200) {
      //     Get.snackbar("Success", data['message']);
      //     // Future.delayed(Duration(milliseconds: 1000)).then((value) {
      //     //   Get.toNamed('/verification/code?phone=$phone');
      //     // });

      //   }
       
      // });

      

      isLoading.value = false;

      return true;



    } catch (e) {
      Get.snackbar("Error!", 'wrong'.tr);
      isLoading.value = false;
    }
  }

  checkVerificationCode() async {
    isLoading.value = true;

    // print("From Forgot Password Controller: " + phone);
    try {
      // await _forgotPasswordService.verify(confirm_code).then((response) {

      //   if (response['status'] == 200) {
      //     Get.snackbar("Success", response['message']);
      //     Future.delayed(Duration(milliseconds: 2000)).then((value) {
      //       Get.toNamed('/reset/password?phone='+response['data']['active_phone'],
      //           arguments: response['data']['active_phone']);
      //     });
      //   }
      // });
      isLoading.value = false;
    } on RestException catch (e) {
      isLoading.value = false;
      Get.snackbar("Error!", e.message);
      // } catch (e) {
      //   Get.snackbar("Error!", 'wrong'.tr);
    }
    // } catch (e) {
    //   Get.snackbar("Error!", e);
    //   isLoading.value = false;
    // }

    // on RestException catch (e) {
    //   Get.snackbar("Error!", e.message);
    //   // } catch (e) {
    //   //   Get.snackbar("Error!", 'wrong'.tr);
    // }
  }

  // Future<void> login() async {
  //   isLoading.value = true;
  //   try {
  //     await _authService.login(phone, password).then((data) {
  //       if (data) {
  //         Get.snackbar("Success", "Success Login");
  //         Future.delayed(Duration(milliseconds: 1000)).then((value) {
  //           Get.offAllNamed('/');
  //         });
  //       }
  //     });
  //     isLoading.value = false;
  //   } catch (e) {
  //     Get.snackbar("Error!", 'wrong'.tr);
  //     isLoading.value = false;
  //   }

  //  isLoading.value = true;
  // try {
  //   final user = await _authRepository.login(phone, password);
  //   GetStorage().write('user', user.toJson());
  //   isLoading.value = false;
  // } on RestException catch (e) {
  //   Get.snackbar("Error!", e.message);
  //   isLoading.value = false;
  // } catch (e) {
  //   Get.snackbar("Error!", 'wrong'.tr);
  //   isLoading.value = false;
  // }
}

// Future<void> login() async {
// isLoading.value = true;
// if (await AuthService.login(phone, password) == true) {
//   await AuthService.fetchUserProfile();
//   isLoading.value = false;
//   Get.offAllNamed('/');
// } else
//   isLoading.value = false;

// var options = await DioOptions.initDioOptions();
// dioPc.Dio dio = new dioPc.Dio(options);
// final Map<String, dynamic> body = {'phone': phone, 'password': password};
// try {
//   dioPc.Response response = await dio
//       .post("https://admin.easy-app.co/api/v1/auth/user/login", data: body);
//   final responseData = new Map<String, dynamic>.from(response.data);

//   if (response.statusCode == 200) {
//     if (responseData['data']['token'] != "") {
//       await GetStorage()
//           .write('accessToken', responseData['data']['token']);

//       await AuthService.fetchUserProfile();

//       isLoading.value = false;

//       Get.offAll(HomeScreen());
//     }
//   }

//   // if (response.data['status'] == 200) {
//   // } else if (response.data['status'] == 400) {
//   //   final String errorMessage = response.data['message'];
//   //   // _showErrorSnack(errorMessage);
//   // } else {
//   //   final String errorMessage = response.data['message'];
//   //   // _showErrorSnack(errorMessage);
//   // }
// } on dioPc.DioError catch (e) {
//   Get.snackbar("Error!", e.response.data['error']);
//   print(e.response.data);
//   print(e.response.headers);
//   print(e.response.request);

//   // Something happened in setting up or sending the request that triggered an Error
//   print(e.request);
//   print(e.message);
// }
// }
