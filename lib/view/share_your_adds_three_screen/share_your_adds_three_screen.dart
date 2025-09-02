import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/share_your_adds_seven_screen/share_your_adds_seven_screen.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class ShareYourAddsThreeScreen extends StatelessWidget {
  ShareYourAddsThreeScreen({Key? key})
      : super(
          key: key,
        );

   String radioGroup = "";

   String radioGroup1 = "";
  final int activeStep = 3; // Initial step set to 5.

  final int upperBound = 6; //
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
       
        body: Container(
          // color: PURPLE_COLOR,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // IconStepper(
                //   icons: [
                //     Icon(Icons.supervised_user_circle),
                //     Icon(Icons.flag),
                //     Icon(Icons.access_alarm),
                //     Icon(Icons.supervised_user_circle),
                //     Icon(Icons.flag),
                //     Icon(Icons.access_alarm),
                //     Icon(Icons.supervised_user_circle),
                //   ],

                //   // activeStep property set to activeStep variable defined above.
                //   activeStep: activeStep,

                //   // This ensures step-tapping updates the activeStep.
                //   onStepReached: (index) {
                //     // setState(() {
                //     //   activeStep = index;
                //     // });
                //   },
                // ),
                // header(),
                // Expanded(
                //   child: FittedBox(
                //     child: Center(
                //       child: Text('$activeStep'),
                //     ),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     previousButton(),
                //     nextButton(),
                //   ],
                // ),

                // Expanded(
                //   child: Stepper(
                //     type: StepperType.horizontal,
                //     physics: ScrollPhysics(),
                //     currentStep: 1,
                //     onStepTapped: (step) => print(step),
                //     onStepContinue: () {},
                //     onStepCancel: () {},
                //     steps: <Step>[
                //       Step(
                //         title: new Text(''),
                //         content: Column(
                //           children: <Widget>[
                //             TextFormField(
                //               decoration:
                //                   InputDecoration(labelText: 'Email Address'),
                //             ),
                //             TextFormField(
                //               decoration: InputDecoration(labelText: 'Password'),
                //             ),
                //           ],
                //         ),
                //         // isActive: _currentStep >= 0,
                //         // state: _currentStep >= 0 ?
                //         // StepState.complete : StepState.disabled,
                //       ),
                //       Step(
                //         title: new Text(''),
                //         content: Column(
                //           children: <Widget>[
                //             TextFormField(
                //               decoration:
                //                   InputDecoration(labelText: 'Home Address'),
                //             ),
                //             TextFormField(
                //               decoration: InputDecoration(labelText: 'Postcode'),
                //             ),
                //           ],
                //         ),
                //         // isActive: _currentStep >= 0,
                //         // state: _currentStep >= 1 ?
                //         // StepState.complete : StepState.disabled,
                //       ),
                //       Step(
                //         title: new Text(''),
                //         content: Column(
                //           children: <Widget>[
                //             TextFormField(
                //               decoration:
                //                   InputDecoration(labelText: 'Mobile Number'),
                //             ),
                //           ],
                //         ),
                //         // isActive:_currentStep >= 0,
                //         // state: _currentStep >= 2 ?
                //         // StepState.complete : StepState.disabled,
                //       ),
                //       Step(
                //         title: new Text(''),
                //         content: Column(
                //           children: <Widget>[
                //             TextFormField(
                //               decoration:
                //                   InputDecoration(labelText: 'Mobile Number'),
                //             ),
                //           ],
                //         ),
                //         // isActive:_currentStep >= 0,
                //         // state: _currentStep >= 3 ?
                //         // StepState.complete : StepState.disabled,
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: Column(
                  children: [
                    _buildTap(context),
                    Container(
                      height: 6.v,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: appTheme.yellow50,
                        borderRadius: BorderRadius.circular(
                          3.h,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          3.h,
                        ),
                        child: LinearProgressIndicator(
                          value: 0.15,
                          backgroundColor: appTheme.yellow50,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            appTheme.orange400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.v),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.h),
                      padding: EdgeInsets.all(12.h),
                      decoration: AppDecoration.fillOnPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder12,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upload attachments ",
                            style: CustomTextStyles.titleMediumBluegray90001_1,
                          ),
                          Text(
                            "You can add maximum 20 images or 5 videos.",
                            style: theme.textTheme.bodySmall,
                          ),
                          SizedBox(height: 10.v),
                          _buildFrame(context),
                          SizedBox(height: 16.v),
                          _buildFrame1(context),
                          SizedBox(height: 16.v),

                          // EasyStepper(
                          //     activeStep: 2,
                          //     activeStepTextColor: Colors.black87,
                          //     finishedStepTextColor: Colors.black87,
                          //     internalPadding: 0,
                          //     showLoadingAnimation: true,
                          //     stepRadius: 8,
                          //     showStepBorder: false,
                          //     steps: [
                          //       EasyStep(
                          //         customStep: CircleAvatar(
                          //           radius: 8,
                          //           backgroundColor: Colors.white,
                          //         ),
                          //         title: 'Waiting',
                          //       ),
                          //       EasyStep(
                          //         customStep: CircleAvatar(
                          //           radius: 8,
                          //           backgroundColor: Colors.white,
                          //           child: CircleAvatar(
                          //             radius: 7,
                          //           ),
                          //         ),
                          //         title: 'Order Received',
                          //         topTitle: true,
                          //       ),
                          //       EasyStep(
                          //         customStep: CircleAvatar(
                          //           radius: 8,
                          //           backgroundColor: Colors.white,
                          //           child: CircleAvatar(
                          //             radius: 7,
                          //           ),
                          //         ),
                          //         title: 'Preparing',
                          //       ),
                          //       EasyStep(
                          //         customStep: CircleAvatar(
                          //           radius: 8,
                          //           backgroundColor: Colors.white,
                          //           child: CircleAvatar(
                          //             radius: 7,
                          //           ),
                          //         ),
                          //         title: 'On Way',
                          //         topTitle: true,
                          //       ),
                          //       EasyStep(
                          //         customStep: CircleAvatar(
                          //           radius: 8,
                          //           backgroundColor: Colors.white,
                          //           child: CircleAvatar(
                          //             radius: 7,
                          //           ),
                          //         ),
                          //         title: 'Delivered',
                          //       ),
                          //     ]),
                        ],
                      ),
                    ),
                  ],
                )),
                Container(
                  color: WHITE_COLOR,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: _buildShareYourAdds(context),
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildTap(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.v,
      ),
      decoration: AppDecoration.fillOnPrimary,
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgArrowDown,
            height: 24.v,
            width: 23.h,
            margin: EdgeInsets.symmetric(vertical: 3.v),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16.h,
              top: 2.v,
            ),
            child: Text(
              "Share your adds",
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildMainImg(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Add image ",
                  style: CustomTextStyles.bodyMediumff363333,
                ),
                TextSpan(
                  text: "( optional ) ",
                  style: CustomTextStyles.bodySmallff828282,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 6.v),
          Row(
            children: [
              Container(
                height: 88.adaptSize,
                width: 88.adaptSize,
                padding: EdgeInsets.all(31.h),
                decoration: AppDecoration.outlinePrimary2.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder8,
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgPlus,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  alignment: Alignment.center,
                ),
              ),
              Container(
                height: 88.v,
                width: 96.h,
                margin: EdgeInsets.only(left: 8.h),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 100.adaptSize,
                        width: 100.adaptSize,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgRectangle2,
                              height: 100.adaptSize,
                              width: 100.adaptSize,
                              radius: BorderRadius.circular(
                                8.h,
                              ),
                              alignment: Alignment.center,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 4.h,
                                  bottom: 4.v,
                                ),

                                child:  Row(
                                                children: [
                                                  Icon(Icons.radio_button_checked, size: 20, color: ZAHRA_ORANGE, fill: 0.5, ),
                                                    SizedBox(width: 2,),
                                                  Text("Main Img", style: TextStyle(fontSize: 12, color: WHITE_COLOR),)
                                                ],
                                              ),
                                // child: CustomRadioButton(
                                //   decoration:
                                //       BoxDecoration(color: Colors.transparent),

                                //   text: "Main img",
                                //   textStyle: TextStyle(
                                //       color: WHITE_COLOR, fontSize: 12),
                                //   // value: "Main img",
                                //   groupValue: radioGroup,
                                //   // padding: EdgeInsets.symmetric(vertical: 1.v),
                                //   // textStyle:
                                //   //     CustomTextStyles.bodySmallOnPrimary,
                                //   onChange: (value) {
                                //     radioGroup = value;
                                //   },
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomIconButton(
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                      alignment: Alignment.topRight,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgCloseOnerror,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 88.v,
                width: 96.h,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 100.adaptSize,
                        width: 100.adaptSize,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgRectangle288x88,
                              height: 100.adaptSize,
                              width: 88.adaptSize,
                              radius: BorderRadius.circular(
                                8.h,
                              ),
                              alignment: Alignment.center,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 8.h,
                                  bottom: 4.v,
                                ),

                                child:  Row(
                                                children: [
                                                  Icon(Icons.radio_button_checked, size: 20, color: ZAHRA_ORANGE, fill: 0.5, ),
                                                    SizedBox(width: 2,),
                                                  Text("Main Img", style: TextStyle(fontSize: 12, color: WHITE_COLOR),)
                                                ],
                                              ),
                                // child: CustomRadioButton(
                                //   // text: "Main img",
                                //   // value: "Main img",
                                //   decoration:
                                //       BoxDecoration(color: Colors.transparent),

                                //   text: "Main img",
                                //   textStyle: TextStyle(
                                //       color: WHITE_COLOR, fontSize: 12),
                                //   groupValue: radioGroup1,
                                //   padding: EdgeInsets.symmetric(vertical: 1.v),

                                //   onChange: (value) {
                                //     radioGroup1 = value;
                                //   },
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomIconButton(
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                      alignment: Alignment.topRight,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgCloseOnerror,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainImg(context),
        Padding(
          padding: EdgeInsets.only(
            left: 0.h,
            bottom: 94.v,
          ),
          child: Text(
            "(0/20)",
            style: CustomTextStyles.bodyMediumBluegray900,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildProductVideo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Product Video ",
                style: CustomTextStyles.bodyMediumff363333,
              ),
              TextSpan(
                text: "( optional ) ",
                style: CustomTextStyles.bodySmallff828282,
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 6.v),
        SizedBox(
          width: 192.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 88.adaptSize,
                width: 88.adaptSize,
                padding: EdgeInsets.all(31.h),
                decoration: AppDecoration.outlinePrimary2.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder8,
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgPlus,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(
                height: 88.v,
                width: 96.h,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 88.adaptSize,
                        width: 88.adaptSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgRectangle2,
                              height: 88.adaptSize,
                              width: 88.adaptSize,
                              radius: BorderRadius.circular(
                                8.h,
                              ),
                              alignment: Alignment.center,
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgClockOnprimary,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomIconButton(
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                      alignment: Alignment.topRight,
                      child: CustomImageView(
                        imagePath: ImageConstant.imgCloseOnerror,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildFrame1(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductVideo(context),
        Padding(
          padding: EdgeInsets.only(bottom: 94.v),
          child: Text(
            "(0/5)",
            style: CustomTextStyles.bodyMediumBluegray900,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildShareYourAdds(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.v),
      decoration: AppDecoration.fillOnPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomElevatedButton(
              height: 42.h,
              text: "Previous",
              margin: EdgeInsets.only(right: 6.h),
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles
                  .gradientSecondaryContainerToOrangeTL12Decoration,
              buttonTextStyle: theme.textTheme.titleMedium!,
            ),
          ),
          Expanded(
            child: CustomElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShareYourAddsSevenScreen())),
              height: 42.h,
              text: "Next",
              margin: EdgeInsets.only(left: 6.h),
              buttonStyle: CustomButtonStyles.none,
              decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
            ),
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
        // case BottomBarEnum.Message:
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

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          // setState(() {
          //   activeStep++;
          // });
        }
      },
      child: Text('Next'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          // setState(() {
          //   activeStep--;
          // });
        }
      },
      child: Text('Prev'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Preface';

      case 2:
        return 'Table of Contents';

      case 3:
        return 'About the Author';

      case 4:
        return 'Publisher Information';

      case 5:
        return 'Reviews';

      case 6:
        return 'Chapters #1';

      default:
        return 'Introduction';
    }
  }
}
