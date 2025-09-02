
import 'package:get/get.dart';

import '../../../repositories/auth_repository.dart';

class RegisterPhoneController extends GetxController {
  final AuthRepository _authRepository;
  RegisterPhoneController(this._authRepository);

  RxBool obscureText = true.obs;
  RxBool isLoading = false.obs;

  String? name, password, phone, confirmationPassword;

  


  RxString _confim_code = "".obs;

  RxBool _open_confirm_dialog = false.obs;

  bool get open_confirm_dialog => _open_confirm_dialog.value;

  String get confirm_code => _confim_code.value;


 changeObscureText() {
    obscureText.value = !obscureText.value;
  }

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


void reg(){
   Get.snackbar("Error!", 'wrong'.tr);
}
  Future<void> verificationCode() async {
    final Map<String, dynamic> body = {'verify_code': confirm_code};
    try {
      isLoading.value = true;
      await _authRepository.verificationCode(body).then((data) {

        final response = new Map<String, dynamic>.from(data);

        Get.toNamed('/register_complete', arguments: response);

        // return response;
        // Future.delayed(Duration(milliseconds: 1000)).then((value) {
        //   Get.offAllNamed('/');
        // });

      });
      isLoading.value = false;
    } catch (e) {
      Get.snackbar("Error!", 'wrong'.tr);
      isLoading.value = false;
    }
  }

    Future<dynamic> register() async {


    final Map<String, dynamic> body = {'name': name,'phone': phone, 'password': password,'password_confirmation':confirmationPassword};


    try {
      isLoading.value = true;
      await _authRepository.registerphone(body).then((data) {
        final response = new Map<String, dynamic>.from(data);


        print(response);
        if (response['status'] == 200) {
          // _open_confirm_dialog.value = true;


            Get.snackbar("Success", response['message']);

       
        }

        // return response;
        Future.delayed(Duration(milliseconds: 1000)).then((value) {
          Get.offAllNamed('/login');
        });
        
      });

      isLoading.value = false;

      // if(open_confirm_dialog){
      //     return true;
      // }


          update();
    } catch (e) {
      Get.snackbar("Error!", 'wrong'.tr);
      isLoading.value = false;
    }
  }
}
