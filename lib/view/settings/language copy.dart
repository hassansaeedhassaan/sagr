import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/utilities/localizations/app_language.dart';
import 'package:get/get.dart';

import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 243, 243, 243),
        appBar: AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
    
      toolbarHeight: 77, // Set this height
      title: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Image.asset("assets/images/logo.png", width: 120),
      ),
      backgroundColor: WHITE_COLOR,
      foregroundColor: BLACK_COLOR,
    ),
        body: GetBuilder<AppLanguage>(
            init: AppLanguage(),
            builder: (controller) {
              return Column(
                children: [

                  
                  // AppLocaleSwitcher(),
                  Container(
                                

                                 decoration: BoxDecoration(
                                    color: WHITE_COLOR, 
                                   borderRadius: BorderRadius.circular(8)
                                 ),      
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Choose Language".tr,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: BLACK_COLOR)),
                        // SizedBox(height: 10),
                        // Text("Please select the language you want".tr),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () => controller.saveSelectLocale('ar'),
                          child: Container(
                            height: 48,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.selectLocale == 'ar'? WHITE_COLOR:WHITE_COLOR,
                                border:
                                    Border.all(width: 1, color: controller.selectLocale == 'ar'? Color(0xffd50e50):GREY_COLOR.withOpacity(0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "اللغة العربية",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: BLACK_COLOR),
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  // padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: controller.selectLocale == 'ar'? WHITE_COLOR: WHITE_COLOR,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon( controller.selectLocale == 'ar' ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: controller.selectLocale == 'ar' ? Color(0xffd50e50) : DARK_PURPLE_COLOR,size: 20,),
                                )
                               
                                
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () => controller.saveSelectLocale('en'),
                          child: Container(
                            height: 48,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: controller.selectLocale == 'en'? WHITE_COLOR:WHITE_COLOR,
                                border:
                            
                                    Border.all(width: 1, color: controller.selectLocale == 'en'?Color(0xffd50e50):GREY_COLOR.withOpacity(0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                  
                                Text(
                                  "English",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: BLACK_COLOR),
                                ),
                  
                  
                  
                                Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: controller.selectLocale == 'en'? WHITE_COLOR: WHITE_COLOR,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Icon(controller.selectLocale == 'en' ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: controller.selectLocale == 'en' ? Color(0xffd50e50) : DARK_PURPLE_COLOR, size: 20,),
                                ),
                                
                                
                              ],
                            ),
                          ),
                        ),
                  
                  
                  SizedBox(height: 20),                          CustomElevatedButton(
                          onPressed: (){
                       controller.changeLanguage(controller.selectLocale.toString());
                  
                       Get.toNamed('/login');
                    },
                                  text: "Choose",
                                  buttonStyle: CustomButtonStyles.none,
                                  decoration:
                  CustomButtonStyles.gradientPrimaryToOrangeDecoration,
                                ),
                      ],
                    ),
                  ),

                  
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 100,
                  //   color: WHITE_COLOR,
                  //   padding: EdgeInsets.symmetric(vertical: 27, horizontal: 20),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         // primary: GetStorage().read('app_type') == 'tools' ? Color(0xffd32026): Color(0xff0A458B),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //         ),
                  //         textStyle: TextStyle(
                  //             fontSize: 16, fontWeight: FontWeight.bold)),
                  //     onPressed: (){
                  //        controller.changeLanguage(controller.selectLocale.toString());

                  //        Get.toNamed('/login');
                  //     },
                  //     child: Text(
                  //       "Save Changes".tr,
                  //       style: TextStyle(fontFamily: 'URW'),
                  //     ),
                  //   ),
                  // )
                ],
              );
            }));
  }
}
