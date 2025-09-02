import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/models/setting.dart';
import 'package:sagr/repositories/setting_repository.dart';

class SettingController extends GetxController {

  // final SettingRepository _settingRepository;

  // SettingController(this._settingRepository);


  SettingController();


  RxInt currentIndex = 0.obs;

  RxBool _isLoading = false.obs;

  RxString _language = ''.obs; 

  final _setting = Setting().obs;

  Setting get setting => _setting.value;

  bool get isLoading => _isLoading.value;
  String get language => _language.value;

// Points Settings
  String pointsPerIraqDinar = '';

  String pointsLimitReservedRgift = '';

// Contact us Settings
  String contactPhone = "";
  String contactEmail = "";
  String facebook = "";
  String twitter = "";
  String instagram = "";

// About us Settings
  String aboutus = "";

  @override
  void onInit() {


    // _getSetting();

    print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥");
    super.onInit();
  }

  // Sliders Settings

  final ImagePicker _picker = ImagePicker();

  final _imagePath = "".obs;
  final _imageFile = XFile("").obs;

  String get imagePath => _imagePath.value;
  XFile get imageFile => _imageFile.value;

  Future<void> pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      _imagePath.value = image!.path;

      _imageFile.value = image;

      update();
    } catch (e) {}
  }

  // Future<void> printImage() async {
  //   try {
  //     final settingData = await _settingRepository.uploadSlide(imagePath);

  //     print(settingData);
  //     _imagePath.value = "";
  //     // catch exc
  //     //eption here...
  //     _getSetting();
  //   } catch (e) {}
  // }

  changeCurrentIndex(index) {


//    if(Get.currentRoute == '/category_screen'){
//      index = 1;
//    }


// if(Get.currentRoute == '/home_screen'){
//      index = 0;
//    }


    currentIndex.value = index;
    update();
  }

  // Future<void> _getSetting() async {
  //   _isLoading.value = true;

  //   final settingData = await _settingRepository.getSettings('about-us');

  //   print("🔥");
  //   print(settingData);
  //   print("🔥");
  //   _setting.value = settingData;

  //   _isLoading.value = false;

  //   update();
  // }

  // Future<void> saveSettings() async {
  //   _isLoading.value = true;

  //   final Map<String, dynamic> body = {
  //     'points_per_iraq_dinar': pointsPerIraqDinar,
  //     'points_limit_reserved_gift': pointsLimitReservedRgift
  //   };

  //   final settingData = await _settingRepository.saveSettings(body);

  //   if (settingData.data['status'] == 200) {
  //     Get.snackbar("تم حفظ البيانات بنجاح", "", backgroundColor: BLACK_COLOR);
  //   }
  //   _getSetting();
  //   _isLoading.value = false;
  //   update();
  // }

  // Future<void> saveContactSettings() async {
  //   _isLoading.value = true;

  //   final Map<String, dynamic> body = {
  //     'contact_phone': contactPhone,
  //     'contact_email': contactEmail,
  //     'facebook': facebook,
  //     'twitter': twitter,
  //     'instagram': instagram,
  //   };

  //   final settingData = await _settingRepository.saveSettings(body);

  //   if (settingData.data['status'] == 200) {
  //     Get.snackbar("تم الحفظ بنجاح", '', backgroundColor: BLACK_COLOR);
  //   }

  //   _getSetting();
  //   _isLoading.value = false;
  //   update();
  // }

  // Future<void> saveAboutusSettings() async {
  //   _isLoading.value = true;

  //   final Map<String, dynamic> body = {
  //     'aboutus': aboutus,
  //   };

  //   final settingData = await _settingRepository.saveSettings(body);

  //   if (settingData.data['status'] == 200) {
  //     Get.snackbar("تم الحفظ بنجاح", "", backgroundColor: BLACK_COLOR);
  //   }
  //   _getSetting();
  //   _isLoading.value = false;
  //   update();
  // }

  // Future<void> deleteImage(imageId) async {
  //   _isLoading.value = true;

  //   final Map<String, dynamic> body = {
  //     'sliderID': imageId,
  //   };

  //   final settingData = await _settingRepository.deleteSlider(body);

  //   if (settingData.data['status'] == 200) {
  //     Get.snackbar("تمت العمليه بنجاح", "", backgroundColor: BLACK_COLOR);
  //   }
  //   _getSetting();
  //   _isLoading.value = false;
  //   update();
  // }

    void setLang(language){
     _language.value = language;

     update();
    }


}
