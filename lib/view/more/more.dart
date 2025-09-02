
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/colors.dart';
import '../widgets/fixed_app_bottom_bars.dart';

class MoreScreen extends StatelessWidget {
  // Widget button(Function function, IconData icon) {
  //   return FloatingActionButton(
  //     onPressed: function,
  //     materialTapTargetSize: MaterialTapTargetSize.padded,
  //     backgroundColor: Colors.blue,
  //     child: Icon(
  //       icon,
  //       size: 36.0,
  //     ),
  //   );
  // }

  

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // toolbarHeight: 80,
        title: Text(
          "الاعدادات",
          style:
              TextStyle(fontSize: 20, height: 1.6, fontWeight: FontWeight.bold),
        ),
        backgroundColor: WHITE_COLOR,
        foregroundColor: BLACK_COLOR,
        elevation: 0,
        // actions: <Widget>[
        //   new ShoppingCartButtonWidget(
        //       iconColor: Theme.of(context).primaryColor,
        //       labelColor: Theme.of(context).colorScheme.primary),
        // ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: ()=> Get.toNamed("/account_edit"),
              child: Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.5, color: GREY_COLOR.withOpacity(0.3)))),
                height: 46,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/profile.svg'),
                        SizedBox(width: 10),
                        Text(
                          "تعديل حسابى",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GREY_COLOR),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: GREY_COLOR,
                    )
                  ],
                ),
              ),
            ),
            
            
            // InkWell(
            //   onTap: () => Get.toNamed('/lang'),
            //   child: Container(
            //     padding: EdgeInsets.only(bottom: 10, top: 10),
            //     decoration: BoxDecoration(
            //         border: Border(
            //             bottom: BorderSide(
            //                 width: 0.5, color: GREY_COLOR.withOpacity(0.3)))),
            //     height: 46,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             SvgPicture.asset('assets/icons/lang.svg'),
            //             SizedBox(width: 10),
            //             Text(
            //               " لغة التطبيق",
            //               style: TextStyle(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w500,
            //                   color: GREY_COLOR),
            //             )
            //           ],
            //         ),
            //         Icon(
            //           Icons.arrow_forward_ios,
            //           size: 12,
            //           color: GREY_COLOR,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            
            
            
            GestureDetector(
              onTap: () => Get.toNamed('/points'),
              child: Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.5, color: GREY_COLOR.withOpacity(0.3)))),
                height: 46,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/about.svg'),
                        SizedBox(width: 10),
                        Text(
                          "إعدادات النقاط",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GREY_COLOR),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: GREY_COLOR,
                    )
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: () => Get.toNamed('/sliders'),
              child: Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.5, color: GREY_COLOR.withOpacity(0.3)))),
                height: 46,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/about.svg'),
                        SizedBox(width: 10),
                        Text(
                          "إدارة المعرض ",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GREY_COLOR),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: GREY_COLOR,
                    )
                  ],
                ),
              ),
            ),

            
            GestureDetector(
              onTap: () => Get.toNamed('/dashboard_about'),
              child: Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.5, color: GREY_COLOR.withOpacity(0.3)))),
                height: 46,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/about.svg'),
                        SizedBox(width: 10),
                        Text(
                          "من نحن",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GREY_COLOR),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: GREY_COLOR,
                    )
                  ],
                ),
              ),
            ),
            
            GestureDetector(
                  onTap: () => Get.toNamed('/dashboard_contactus'),
              child: Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 0.5, color: GREY_COLOR.withOpacity(0.3)))),
                height: 46,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/contactus.svg'),
                        SizedBox(width: 10),
                        Text(
                          "تواصل معنا",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GREY_COLOR),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: GREY_COLOR,
                    )
                  ],
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () => Get.toNamed('/terms'),
            //   child: Container(
            //     padding: EdgeInsets.only(bottom: 10, top: 10),
            //     decoration: BoxDecoration(
            //         border: Border(
            //             bottom: BorderSide(
            //                 width: 0.5, color: GREY_COLOR.withOpacity(0.3)))),
            //     height: 46,
            //     // color: Colors.red,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             SvgPicture.asset('assets/icons/terms.svg'),
            //             SizedBox(width: 10),
            //             Text(
            //               "الشروط والاحكام",
            //               style: TextStyle(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w500,
            //                   color: GREY_COLOR),
            //             )
            //           ],
            //         ),
            //         Icon(
            //           Icons.arrow_forward_ios,
            //           size: 12,
            //           color: GREY_COLOR,
            //         )
            //       ],
            //     ),
            //   ),
            // ),

            // GestureDetector(
            //   onTap: () => Get.toNamed('/init_view'),
            //   child: Container(
            //     padding: EdgeInsets.only(bottom: 10, top: 10),
            //     decoration: BoxDecoration(
            //         border: Border(
            //             bottom: BorderSide(
            //                 width: 0.5, color: GREY_COLOR.withOpacity(0.3)))),
            //     height: 46,
            //     // color: Colors.red,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             SvgPicture.asset('assets/icons/lang.svg'),
            //             SizedBox(width: 10),
            //             Text(
            //               "تغيير المتجر",
            //               style: TextStyle(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w500,
            //                   color: GREY_COLOR),
            //             )
            //           ],
            //         ),
            //         Icon(
            //           Icons.arrow_forward_ios,
            //           size: 12,
            //           color: GREY_COLOR,
            //         )
            //       ],
            //     ),
            //   ),
            // ),

            GestureDetector(
              onTap: (){
               GetStorage().remove ('access_token');
                GetStorage().remove('userData');
                GetStorage().remove('loggedInUserName');
                GetStorage().remove('loggedInUserPhone');
                Get.offAndToNamed("/login");
              },
              child: Container(
                height: 46,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/logout.png',
                          width: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "تسجيل خروج",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GREY_COLOR),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: GREY_COLOR,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: WHITE_COLOR, borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
