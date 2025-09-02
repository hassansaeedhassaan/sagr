import 'package:get/get.dart';


class BottomNavController extends GetxController {
var selectedIndex = 0.obs;
  
  // Define your routes here
  final List<String> routes = [
    '/home',
    '/search', 
    '/favorites',
    '/profile',
  ];

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    Get.offAllNamed(routes[index]);
  }

  void setCurrentIndex(int index) {
    selectedIndex.value = index;
  }
}