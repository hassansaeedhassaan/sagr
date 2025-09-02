import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../core/utils/image_constant.dart';
import '../theme/app_decoration.dart';
import '../theme/custom_button_style.dart';
import '../theme/custom_text_style.dart';
import '../theme/theme_helper.dart';
import '../widgets/custom_drop_down.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_floating_text_field.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/custom_image_view.dart';
import '../widgets/custom_text_form_field.dart';

class CreateAd extends StatefulWidget {
  const CreateAd({super.key});

  @override
  State<CreateAd> createState() => _CreateAdState();
}

class _CreateAdState extends State<CreateAd> {
  
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Create Ad."),
        ),
      
        body: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Column(
              // mainAxisSize: MainAxisSize.max,
              //  crossAxisAlignment: CrosssAxisAlignment.stretch,
              children: [
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
                      value: _currentStep / 3,
                      backgroundColor: appTheme.yellow50,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        appTheme.orange400,
                      ),
                    ),
                  ),
                ),
                //  SizedBox(
      
                //    child:  Container(
      
                //      child: AnotherStepper(
      
                //       scrollPhysics: NeverScrollableScrollPhysics(),
                //       stepperList: stepperData,
                //       stepperDirection: Axis.horizontal,
                //       iconWidth: 0,
                //       iconHeight: 0,
                //       // activeBarColor: Colors.green,
                //       // inActiveBarColor: Colors.grey,
                //       inverted: true,
                //       // verticalGap: 30,
                //       activeIndex: _currentStep,
                //       barThickness: 6,
                //                      ),
                //    ),
                //  ),
                _currentStep == 1
                    ? FadedSlideAnimation(
                        beginOffset: Offset(0.0, 50),
                        endOffset: Offset(0.0, 0),
                        slideDuration: Duration(milliseconds: 500),
                        fadeDuration: Duration(milliseconds: 1000),
                        child: Container(
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
                                style:
                                    CustomTextStyles.titleMediumBluegray90001_1,
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
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
      
                SizedBox(height: 12.v),
      
                _currentStep == 2
                    ? FadedSlideAnimation(
                        beginOffset: Offset(0.0, 50),
                        endOffset: Offset(0.0, 0),
                        slideDuration: Duration(milliseconds: 500),
                        fadeDuration: Duration(milliseconds: 1000),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 400,
                          margin: EdgeInsets.symmetric(horizontal: 16.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.h,
                            vertical: 11.v,
                          ),
                          decoration: AppDecoration.fillOnPrimary.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder12,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Add info",
                                  style:
                                      CustomTextStyles.titleMediumBluegray90001_1,
                                ),
                                SizedBox(height: 12.v),
                                CustomDropDown(
                                  icon: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.h, 15.v, 16.h, 15.v),
                                    child: CustomImageView(
                                      imagePath:
                                          ImageConstant.imgCheckmarkGray50001,
                                      height: 20.adaptSize,
                                      width: 20.adaptSize,
                                    ),
                                  ),
                                  hintText: "Category",
                                  items: [],
                                  contentPadding: EdgeInsets.only(
                                    left: 16.h,
                                    top: 15.v,
                                    bottom: 15.v,
                                  ),
                                  onChanged: (value) {},
                                ),
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                SizedBox(height: 12.v),
                                _buildAddTitleSection(context),
      
                                // SizedBox(height: 12.v),
                                // _buildAddDescriptionSection(context),
                                // SizedBox(height: 4.v),
                                // _buildAddPriceSection(context),
                                // SizedBox(height: 12.v),
                                // _buildAddFrameSection(context),
                                // SizedBox(height: 12.v),
                                // _buildPhoneNumberSection(context),
                                // SizedBox(height: 12.v),
                                // _buildWhatsNumberSection(context),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
      
                _currentStep == 3
                    ? FadedSlideAnimation(
                        beginOffset: Offset(0.5, 50),
                        endOffset: Offset(0.5, 0),
                        slideDuration: Duration(milliseconds: 500),
                        fadeDuration: Duration(milliseconds: 1000),
                        child: Container(
                          child: Text("Tab 02 ${_currentStep}"),
                        ),
                      )
                    : SizedBox(),
              ],
            )),
      
            
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
      
            //     if (_currentStep != 0)
            //       GestureDetector(
            //         onTap: () => setState(() {
            //           if (_currentStep > 1) {
            //                                   _currentStep = _currentStep - 1;
      
            //           }
      
            //         }),
            //         child: Text("Back"),
            //       ),
      
            //         if (_currentStep < 3)
            //     GestureDetector(
            //       onTap: () => setState(() {
            //         _currentStep = _currentStep + 1;
            //       }),
            //       child: Text("Next"),
            //     ),
            //     if (_currentStep  == 3 )
            //       GestureDetector(
            //       onTap: () => setState(() {
            //         _currentStep = _currentStep;
            //       }),
            //       child: Text("SEND >>"),
            //     )
      
            //   ],
            // )
          ],
        ),
      bottomNavigationBar: Container(
              color: WHITE_COLOR,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 16.v),
                decoration: AppDecoration.fillOnPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentStep > 1)
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () => setState(() {
                            if (_currentStep > 1) {
                              _currentStep = _currentStep - 1;
                            }
                          }),
                          height: 42.h,
                          text: "Previous",
                          margin: EdgeInsets.only(right: 6.h),
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles
                              .gradientSecondaryContainerToOrangeTL12Decoration,
                          buttonTextStyle: theme.textTheme.titleMedium!,
                        ),
                      ),
                    if (_currentStep < 3)
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () => setState(() {
                            _currentStep = _currentStep + 1;
                          }),
                          // onPressed: () => Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ShareYourAddsSevenScreen())),
                          height: 42.h,
                          text: "Next",
                          margin: EdgeInsets.only(left: 6.h),
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles
                              .gradientPrimaryToOrangeDecoration,
                        ),
                      ),
                    if (_currentStep == 3)
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () => print("as k"),
                          height: 42.h,
                          text: "Send",
                          margin: EdgeInsets.only(left: 6.h),
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles
                              .gradientPrimaryToOrangeDecoration,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        // body: Stepper(
      
        //     type: StepperType.horizontal,
        //     currentStep: _currentStep ,
        //     onStepTapped: (int step) => setState(() => _currentStep = step),
        //     onStepContinue: _currentStep < 2 ? () => setState(() => _currentStep += 1) : null,
        //     onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
        //     controlsBuilder: (BuildContext context, ControlsDetails details) {
        //       final _isLastStep = _currentStep == 2;
        //       return Container(
        //           margin: const EdgeInsets.only(top: 50),
        //           child: Row(children: [
        //              if (_currentStep != 0 )
        //               Expanded(
        //                   child: ElevatedButton(
        //                       child: Text('Back'),
        //                       onPressed: details.onStepCancel)),
        //             Expanded(
        //                 child: ElevatedButton(
        //                     child: Text(_isLastStep ? 'Send' : 'Next'),
        //                     onPressed: _currentStep == 2 ? () => print("Submit"): details.onStepContinue)),
        //             const SizedBox(
        //               width: 12,
        //             ),
      
        //           ]));
        //     },
        //     steps: <Step>[
        //       new Step(
        //         title: new Text(''),
        //         content: new Text('This is the first step. ${_currentStep}'),
        //         isActive: _currentStep == 0,
        //         state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
        //         // label: Text("Media")
        //       ),
        //       new Step(
        //         title: new Text(''),
        //         content: new Text('This is the second step. ${_currentStep}'),
        //         isActive: _currentStep >= 0,
        //         state: _currentStep == 1 ? StepState.editing : StepState.disabled,
        //               //  label: Text("Address")
        //       ),
        //       new Step(
        //         title: new Text(''),
        //         content: new Text('This is the third step. ${_currentStep}'),
        //         isActive: _currentStep >= 0,
        //         state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
        //               //  label: Text("Confirm")
        //       ),
        //     ],
        //   ),
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
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_checked,
                                      size: 20,
                                      color: ZAHRA_ORANGE,
                                      fill: 0.5,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Main Img",
                                      style: TextStyle(
                                          fontSize: 12, color: WHITE_COLOR),
                                    )
                                  ],
                                ),
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

                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_checked,
                                      size: 20,
                                      color: ZAHRA_ORANGE,
                                      fill: 0.5,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Main Img",
                                      style: TextStyle(
                                          fontSize: 12, color: WHITE_COLOR),
                                    )
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
  Widget _buildTapSection(BuildContext context) {
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
  Widget _buildAddTitleSection(BuildContext context) {
    return CustomTextFormField(
      hintText: "Title",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
    );
  }

  /// Section Widget
  Widget _buildAddDescriptionSection(BuildContext context) {
    return CustomTextFormField(
      hintText: "Description",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      maxLines: 8,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 14.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildAddPriceSection(BuildContext context) {
    return CustomFloatingTextField(
      labelText: "Price Type",
      labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
      hintText: "Price Type",
      contentPadding: EdgeInsets.only(
        left: 16.h,
        right: 16.h,
        bottom: 12.v,
      ),
      borderDecoration: FloatingTextFormFieldStyleHelper.underLine,
      filled: false,
    );
  }

  /// Section Widget
  Widget _buildMaxPriceSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 6.h),
        child: CustomTextFormField(
          hintText: "Min Price",
          hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAddFrameSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMaxPriceSection(context),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 6.h),
            padding: EdgeInsets.symmetric(
              horizontal: 7.h,
              vertical: 5.v,
            ),
            decoration: AppDecoration.outlineGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.h,
                    top: 0.v,
                    bottom: 0.v,
                  ),
                  child: SizedBox(
                    width: 78,
                    child: CustomFloatingTextField(
                      labelText: "Max Price",
                      labelStyle:
                          CustomTextStyles.titleMediumBluegray90001Medium,
                      hintText: "Price Type",
                      contentPadding: EdgeInsets.only(
                        left: 0.h,
                        right: 0.h,
                        bottom: 12.v,
                      ),
                      borderDecoration:
                          FloatingTextFormFieldStyleHelper.underLine,
                      filled: false,
                    ),
                  ),
                ),
                SizedBox(
                  child: CustomDropDown(
                    width: 69.h,
                    icon: Container(
                      decoration: BoxDecoration(
                        color: RED_COLOR,
                        gradient: LinearGradient(
                          //  begin: Alignment(-0.11, -0.23),
                          end: Alignment(1.0, 1.0),
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.3),
                            appTheme.orange400.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),

                      // margin: EdgeInsets.fromLTRB(4.h, 6.v, 8.h, 6.v),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "SR",
                            style:
                                TextStyle(color: Color(0XFFD20653), height: 1),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgArrowdownPrimary,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                          )
                        ],
                      ),
                    ),
                    // hintText: "SR",
                    hintStyle: CustomTextStyles.bodySmallPrimary,
                    items: [],
                    borderDecoration:
                        DropDownStyleHelper.gradientSecondaryContainerToOrange,
                    filled: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildPhoneNumberSection(BuildContext context) {
    return CustomTextFormField(
      hintText: "Phone number",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      textInputType: TextInputType.phone,
    );
  }

  /// Section Widget
  Widget _buildWhatsNumberSection(BuildContext context) {
    return CustomTextFormField(
      hintText: "What's number",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.number,
    );
  }
}
