import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/app/view_model/profile/profile_controller.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/contact_us_one_screen/contact_us_one_screen.dart';
import 'package:sagr/view/contact_us_two_screen/contact_us_two_screen.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';




class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({Key? key})
      : super(
          key: key,
        );


  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: AppBar(
          title: Text("Personal Info "),
        ),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(16.h),
          child: GetBuilder<ProfileController>(
              init: ProfileController(Get.find()),
            builder: (_controller){
              return Column(
            children: [
              _buildFrameRow(context, _controller.authenticatedUser!),
              SizedBox(height: 12.v),
              _buildFrameRow1(context),
              SizedBox(height: 8.v),
              _buildFrameRow2(context),
              SizedBox(height: 8.v),
              _buildFrameRow3(context),
              SizedBox(height: 5.v)
            ],
          );
            },
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 39.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 16.v,
          bottom: 16.v,
        ),
      ),
      title: AppbarSubtitle(
        text: "Personal info",
        margin: EdgeInsets.only(left: 16.h),
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildFrameRow(BuildContext context, Map<String, dynamic> map) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.linear.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        children: [

            

          CustomImageView(
            imagePath: ImageConstant.imgRectangle121,
            height: 48.adaptSize,
            width: 48.adaptSize,
            radius: BorderRadius.circular(
              24.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.h,
              top: 2.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                
                Text(
                  map['name'],
                  style: CustomTextStyles.titleMediumOnPrimarySemiBold,
                ),
                Text(
                  map['email'],
                  style: CustomTextStyles.titleSmallOnPrimary,
                ),

             
       
              ],

              
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFrameRow1(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 160.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 48.adaptSize,
                  width: 48.adaptSize,
                  padding: EdgeInsets.all(12.h),
                  decoration: AppDecoration.fillGray50.copyWith(
                    borderRadius: BorderRadiusStyle.circleBorder24,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgLock,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    alignment: Alignment.center,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactUsOneScreen())),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 11.v),
                    child: Text(
                      "General Info",
                      style: CustomTextStyles.titleMediumOnErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRightGray50001,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.symmetric(vertical: 14.v),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFrameRow2(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 48.adaptSize,
                width: 48.adaptSize,
                padding: EdgeInsets.all(12.h),
                decoration: AppDecoration.fillGray50.copyWith(
                  borderRadius: BorderRadiusStyle.circleBorder24,
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgLocation,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  alignment: Alignment.center,
                ),
              ),
              GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactUsTwoScreen())),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12.h,
                      top: 12.v,
                      bottom: 10.v,
                    ),
                    child: Text(
                      "Change Password",
                      style: CustomTextStyles.titleMediumOnErrorContainer,
                    ),
                  )),
            ],
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRightGray50001,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.symmetric(vertical: 14.v),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFrameRow3(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 187.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 48.adaptSize,
                  width: 48.adaptSize,
                  padding: EdgeInsets.all(12.h),
                  decoration: AppDecoration.fillSecondaryContainer.copyWith(
                    borderRadius: BorderRadiusStyle.circleBorder24,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgThumbsUpPrimary,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    alignment: Alignment.center,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                contentPadding: EdgeInsets.zero,
                                insetPadding: const EdgeInsets.all(15),
                                content: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
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
                                                      BorderRadius.circular(
                                                          50)),
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
                                            SizedBox(
                                              height: 80,
                                              child: Image.asset(
                                                  "assets/images/zahra-logo.png"),
                                            ),
                                            Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Delete Account",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Are you sure you want to delete your account? If you delete your account, you may not be able to sign in again.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 42.h,
                                                            child:
                                                                GetBuilder<ProfileController>(
                                                                  init: ProfileController(Get.find()),
                                                                  builder: (ProfileController _cntr){
                                                                  return CustomElevatedButton(

                                                                  onPressed: ()=>  _cntr.deleteAccount(context),
                                                              text:
                                                                  "Yes, i'm sure"
                                                                      .tr,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          6.h),
                                                              buttonStyle:
                                                                  CustomButtonStyles
                                                                      .none,
                                                              decoration:
                                                                  CustomButtonStyles
                                                                      .gradientPrimaryToOrangeDecoration,
                                                            );
                                                                }),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              CustomOutlinedButton(
                                                            buttonStyle:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              side: BorderSide(
                                                                  width: 1.0,
                                                                  color: Color(
                                                                      0XFFD20653)),
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            height: 42.v,
                                                            text: "Cancle",
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 6.h),
                                                            buttonTextStyle:
                                                                CustomTextStyles
                                                                    .titleMediumPink60001_1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
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

                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return Dialog(
                      //         backgroundColor: WHITE_COLOR,
                      //         // insetPadding: EdgeInsets.all(10),
                      //         child: SizedBox(
                      //           height: 119.v,
                      //           width: 118.h,
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               color: WHITE_COLOR,
                      //             ),
                      //             child: Stack(
                      //               children: [
                      //                 Positioned(
                      //                     bottom: -10, child: Text("Hassan")),
                      //                 Container(
                      //                   child: Text("askdj "),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     });

                      // showDialog(

                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         contentPadding: EdgeInsets.zero,
                      //         scrollable: true,
                      //         title: Text('Login'),
                      //         content: Padding(
                      //           padding: const EdgeInsets.all(0.0),
                      //           child: Form(
                      //             child: Column(
                      //               children: <Widget>[
                      //                 TextFormField(
                      //                   decoration: InputDecoration(
                      //                     labelText: 'Name',
                      //                     icon: Icon(Icons.account_box),
                      //                   ),
                      //                 ),
                      //                 TextFormField(
                      //                   decoration: InputDecoration(
                      //                     labelText: 'Email',
                      //                     icon: Icon(Icons.email),
                      //                   ),
                      //                 ),
                      //                 TextFormField(
                      //                   decoration: InputDecoration(
                      //                     labelText: 'Message',
                      //                     icon: Icon(Icons.message ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //          actions: [
                      //           ElevatedButton(
                      //               child: Text("Submit"),
                      //               onPressed: () {
                      //                 Navigator.pop(context);
                      //                 // your code
                      //               })
                      //         ],
                      //       );
                      //     });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 11.v),
                      child: Text(
                        "Delete Account",
                        style: CustomTextStyles.titleMediumSemiBold,
                      ),
                    )),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRightPrimary,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.symmetric(vertical: 14.v),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        Navigator.pushNamed(
            navigatorKey.currentContext!, getCurrentRoute(type));
      },
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
      //   return AppRoutes.featureAdsPage;
      // case BottomBarEnum.Category:
      //   return AppRoutes.categoryPage;
      case BottomBarEnum.Message:
        return "/";
      case BottomBarEnum.More:
        return "/";
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      // case AppRoutes.featureAdsPage:
      //   return FeatureAdsPage();
      // case AppRoutes.categoryPage:
      //   return CategoryPage();
      default:
        return DefaultWidget();
    }
  }
}
