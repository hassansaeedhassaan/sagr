// import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/widgets/sagr_bottom_navigation/bottom_navigation_controller.dart';

class GetXBottomNavWidget extends StatelessWidget {
  const GetXBottomNavWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();
    return Text("");
    // return Obx(() => DotNavigationBar(
    //   currentIndex: controller.selectedIndex.value,
    //   onTap: (index) {
    //     controller.changeTabIndex(index);
    //   },
    //   // Customize the appearance
    //   backgroundColor: Colors.white,
    //   borderRadius: 50,
    //   paddingR: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    //   marginR: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    //   itemPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.grey.withOpacity(0.3),
    //       spreadRadius: 2,
    //       blurRadius: 10,
    //       offset: const Offset(0, 3),
    //     ),
    //   ],
    //   // Navigation items
    //   items: [
    //     /// Home
    //     DotNavigationBarItem(
    //       icon: const Icon(Icons.home),
    //       selectedColor: Colors.blue,
    //       unselectedColor: Colors.grey,
    //     ),
        
    //     /// Search
    //     DotNavigationBarItem(
    //       icon: const Column(
    //         children: [
    //           Icon(Icons.search),
    //           Text("Search")
    //         ],
    //       ),
    //       selectedColor: Colors.green,
    //       unselectedColor: Colors.grey,
    //     ),
        
    //     /// Favorites
    //     DotNavigationBarItem(
    //       icon: const Icon(Icons.favorite),
    //       selectedColor: Colors.red,
    //       unselectedColor: Colors.grey,
    //     ),
        
    //     /// Profile
    //     DotNavigationBarItem(
    //       icon: const Icon(Icons.person),
    //       selectedColor: Colors.purple,
    //       unselectedColor: Colors.grey,
    //     ),
    //   ],
    // ));
  }
}