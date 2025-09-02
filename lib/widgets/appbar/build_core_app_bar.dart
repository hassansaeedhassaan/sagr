import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/app/view_model/settings/setting_controller.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:sagr/utilities/local_storage/locale_storage.dart';
import 'package:sagr/view/feature_ads_page/feature_ads_page.dart';

import '../../core/utils/image_constant.dart';
import '../../data/colors.dart';
import '../../theme/custom_button_style.dart';
import '../Common/custom_dropdown.dart';
import '../custom_elevated_button.dart';
import '../custom_image_view.dart';

class BuildCoreAppBar extends StatelessWidget {
  const BuildCoreAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 77,
      automaticallyImplyLeading: false,
      leadingWidth: 100,
      scrolledUnderElevation: 0,
      backgroundColor: WHITE_COLOR,
      leading: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                            contentPadding: EdgeInsets.zero,
                            insetPadding: const EdgeInsets.all(15),
                            content: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      right: 10,
                                      top: -15,
                                      child: GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: WHITE_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: SizedBox(
                                            width: 22,
                                            child: CustomImageView(
                                              imagePath: ImageConstant
                                                  .imgVuesaxLinearUserRemove,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Center(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 20),
                                              Text(
                                                "Preferences",
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              GetBuilder<SettingController>(
                                                init: SettingController(),
                                                builder: (SettingController _controller){
                                                return Column(
                                                  children: [
                                                    Container(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                        margin: EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 0),
                                                  decoration: BoxDecoration(
                                                      color: WHITE_COLOR,
                                                      border: Border.all(width: 1, color: GREY_COLOR.withOpacity(0.4)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child:
                                                      CustomDropdownV2<String?>(
                                                    leadingIcon: false,
                                                    onChange: (int index) => _controller.setLang([
                                                      "en",
                                                      "ar",
                                                      
                                                    ][index]),
                                                    dropdownButtonStyle:
                                                        DropdownButtonStyle(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0)),
                                                      height: 38,
                                                width: MediaQuery.of(context).size.width - 70,
                                                      elevation: 0,
                                                      
                                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      // backgroundColor: Colors.white,
                                                      // primaryColor:
                                                      //     Colors.black87,
                                                    ),
                                                    dropdownStyle:
                                                        DropdownStyle(
                                                              width: MediaQuery.of(context).size.width - 70,
                                                            color: WHITE_COLOR,
                                                            elevation: 2,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    side:
                                                                        BorderSide(
                                                                      color: const Color.fromARGB(255, 194, 194, 194),
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8))),
                                                    items: [
                                                      "en",
                                                      "ar",
                                                    ]
                                                        .asMap()
                                                        .entries
                                                        .map(
                                                          (item) =>
                                                              DropdownItem<
                                                                  String?>(
                                                            value: item.value,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(item
                                                                  .value
                                                                  .capitalize!),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    child: Text(_controller.language == "" ? "${GetStorage().read("lang")}" : _controller.language.tr),
                                                  )),

                                                  Container(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                        margin: EdgeInsetsDirectional
                                                      .fromSTEB(0, 10, 0, 0),
                                                  decoration: BoxDecoration(
                                                      color: WHITE_COLOR,
                                                      border: Border.all(width: 1, color: GREY_COLOR.withOpacity(0.4)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child:
                                                      CustomDropdownV2<String?>(
                                                    leadingIcon: false,
                                                    onChange: (int index) => _controller.setLang([
                                                      "en",
                                                      "ar",
                                                      
                                                    ][index]),
                                                    dropdownButtonStyle:
                                                        DropdownButtonStyle(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0)),
                                                      height: 38,
                                                      width: MediaQuery.of(context).size.width - 70,
                                                      elevation: 0,
                                                      
                                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      // backgroundColor: Colors.white,
                                                      // primaryColor:
                                                      //     Colors.black87,
                                                    ),
                                                    dropdownStyle:
                                                        DropdownStyle(
                                                         width: MediaQuery.of(context).size.width - 70,
                                                            color: WHITE_COLOR,
                                                            elevation: 2,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    side:
                                                                        BorderSide(
                                                                      color: const Color.fromARGB(255, 194, 194, 194),
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8))),
                                                    items: [
                                                      "en",
                                                      "ar",
                                                    ]
                                                        .asMap()
                                                        .entries
                                                        .map(
                                                          (item) =>
                                                              DropdownItem<
                                                                  String?>(
                                                            value: item.value,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(item
                                                                  .value
                                                                  .capitalize!),
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                                    child: Text(_controller.language == "" ? "${GetStorage().read("lang")}" : _controller.language.tr),
                                                  )),

                                                  Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 42.h,
                                                        child:
                                                            CustomElevatedButton(
                                                          text:
                                                              "Show Results".tr,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 6.h),
                                                          buttonStyle:
                                                              CustomButtonStyles
                                                                  .none,
                                                          decoration:
                                                              CustomButtonStyles
                                                                  .gradientPrimaryToOrangeDecoration,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                                  ],
                                                );
                                              }),




                                                
                                              // Padding(
                                              //   padding:
                                              //       const EdgeInsets.all(8.0),
                                              //   child: Text(
                                              //     "Are you sure you want to delete your account? If you delete your account, you may not be able to sign in again.",
                                              //     textAlign: TextAlign.center,
                                              //     style:
                                              //         TextStyle(fontSize: 15),
                                              //   ),
                                              // ),
                                              
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                },
                child: badges.Badge(
                    badgeStyle:
                        badges.BadgeStyle(badgeColor: Color(0XFFD20653)),
                    badgeContent: Center(
                      child: Text(
                        'ع',
                        style: TextStyle(
                            color: WHITE_COLOR,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                    ),
                    position: badges.BadgePosition.topEnd(top: -5, end: -2),
                    child: Container(
                      margin: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: GREY_COLOR.withOpacity(0.1)),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgGlobe,
                      ),
                    ))),
            GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeatureAdsPage())),
                child: Container(
                  margin: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: GREY_COLOR.withOpacity(0.1)),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgSearch141BlueGray90001,
                  ),
                )),
          ],
        ),
      ),
      centerTitle: true,
      title: Container(
        margin: EdgeInsets.only(top: 10),
        // width: double.infinity,
        // height: 10,
        child: Image.asset('assets/images/sagr-logo.png', width: 77),
      ),
      actions: [
        GestureDetector(

          onTap: () => Get.toNamed("/notifications"),
            // onTap: () => Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => NotificationScreen())),
            child: badges.Badge(
                badgeStyle: badges.BadgeStyle(
                    badgeColor: Color(0XFFD20653), elevation: 0),
                badgeContent: Padding(
                    padding: EdgeInsets.zero,
                    child:GetBuilder<NotificationsController>(
                      init: NotificationsController(Get.find()),
                      builder: (NotificationsController _notificationController){
                      return  Text(
                      _notificationController.notifications.length.toString(),
                      style: TextStyle(
                          color: WHITE_COLOR,
                          fontSize: 10,
                          fontWeight: FontWeight.w800),
                    );
                    })),
                position: badges.BadgePosition.topEnd(top: -7, end: 10),
                child: Container(
                  margin: EdgeInsetsDirectional.fromSTEB(6, 0, 12, 0),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: GREY_COLOR.withOpacity(0.1)),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVuesaxTwotoneNotification,
                  ),
                ))),

        FutureBuilder(
          future: LocaleStorage().getAccessToken,
          builder: (_, snapshot) {
            if (snapshot.hasError) return Text('Error = ${snapshot.error}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            if (snapshot.data != '') {
              return GestureDetector(
                onTap: () {
                  GetStorage().remove('access_token');
                  GetStorage().remove('userData');
                  Get.offAndToNamed("/login");
                },
                child: Container(
                  margin: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: GREY_COLOR.withOpacity(0.1)),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgClockPrimary,
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }

            // return SizedBox.shrink();
            // return Text(snapshot.data.toString()); //👈 Your valid data here
          },
        ),

        // Text(LocaleStorage().getAccessTolken.then((value) => value.toString())),
      ],
    );
  }
}
