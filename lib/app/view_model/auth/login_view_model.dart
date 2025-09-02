import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  
  late String phone, password, email;

  RxBool isLoading = false.obs;

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

  authUserLogin() async {
    isLoading.value = true;
    // if (await AuthService.userLogin(phone, password) == true) {
    //   await AuthService.fetchUserProfile();
    //   isLoading.value = false;
    //   Get.offAllNamed('/');
    // } else {
    //   isLoading.value = false;
    // }

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
  }
}
