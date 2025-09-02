import 'package:flutter/material.dart';
import 'package:sagr/app/view_model/auth/account_controller.dart';
import 'package:sagr/data/colors.dart';
import 'package:get/get.dart';
import 'package:sagr/widgets/custom_image_view.dart';
import '../../app/view_model/settings/setting_controller.dart';
import '../../core/utils/image_constant.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({Key? key}) : super(key: key);

  final _controller = Get.put(AccountController(Get.find()));

  @override
  Widget build(BuildContext context) {
    var ourIndex = 0;

    if (Get.currentRoute == '/ads') {
      ourIndex = 1;
    } else if (Get.currentRoute == '/home') {
      ourIndex = 0;
    } else if (Get.currentRoute == '/chat') {
      ourIndex = 2;
    } else if (Get.currentRoute == '/more') {
      ourIndex = 3;
    }

    return Container(
        padding: EdgeInsets.only(right: 5.0, left: 5.0, top: 5, bottom: 4),
        margin: EdgeInsets.only(right: 5.0, left: 5.0, top: 0, bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          // border: Border.all(width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 2.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: (i) {
            // Get.nestedKey(1).currentState.popUntil((route) => route.isFirst);
            // DefaultTabController.of(context).index = i;
            // controller.changeCurrentIndex(i);

            switch (i) {
              case 0:
                if (Get.currentRoute == "/home") return;
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (_) => false);

                break;
              case 1:
                if (Get.currentRoute == "/category_screen") return;
                Navigator.pushNamedAndRemoveUntil(
                    context, '/ads', (_) => false);
                break;
              case 2:

                // conversations_list

                if (Get.currentRoute == "/chat") return;
                Navigator.pushNamedAndRemoveUntil(
                    context, '/chat_home', (_) => false);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => MessgeTwoScreen()));

                break;
              case 3:
                _controller.userInfo();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/more', (_) => false);

                // Navigator.pushReplacement(context,
                // MaterialPageRoute(builder: (context) => MoreOneScreen()));

                break;
            }
          },

          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          selectedItemColor: AMBER_COLOR,
          selectedIconTheme:
              IconThemeData(color: Color.fromARGB(255, 245, 214, 38)),
          unselectedFontSize: 14,
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.w600, color: PURPLE_COLOR),
          unselectedItemColor: Color.fromARGB(255, 146, 146, 146),

          items: [
            new BottomNavigationBarItem(
                // icon: CustomImageView(
                //   color: PURPLE_COLOR,
                //   imagePath: Get.currentRoute == '/home'
                //       ? ImageConstant.imgVuesaxTwotoneHome2
                //       : ImageConstant.imgSettings,
                // ),
                icon: Icon(Icons.home),
                label: "Home".tr),
            new BottomNavigationBarItem(
                backgroundColor: AMBER_COLOR,
                // icon: CustomImageView(
                //   color: WHITE_COLOR,
                //   imagePath: ImageConstant.imgNavCategory,
                // ),

                icon: Icon(Icons.ads_click_outlined),
                label: "Advertisements".tr),
            // new BottomNavigationBarItem(
            //     icon: Container(
            //       margin: EdgeInsets.only(top: 10),
            //       padding: EdgeInsets.all(0),
            //       decoration: BoxDecoration(
            //           color: RED_COLOR,
            //           borderRadius: BorderRadius.circular(20)),
            //       child: Icon(
            //         Icons.celebration_outlined,
            //         size: 30,
            //       ),
            //     ),
            //     label: ""),
            new BottomNavigationBarItem(
                // icon: CustomImageView(
                //   imagePath: ImageConstant.imgNavMessage,
                // ),

                icon: Icon(Icons.chat),
                label: "Chat".tr),
            new BottomNavigationBarItem(
                // icon: CustomImageView(
                //   imagePath: ImageConstant.imgSettingsGray60001,
                // ),

                icon: Icon(Icons.more_horiz),
                label: "More".tr),
          ],

          // currentIndex: controller.currentIndex.value,
          currentIndex: ourIndex,
        ));
  }
}
