
import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/share_your_adds_one_screen/share_your_adds_one_screen.dart';
import 'package:sagr/view/share_your_adds_three_screen/share_your_adds_three_screen.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';

class ShareYourAddsSevenScreen extends StatelessWidget {
  ShareYourAddsSevenScreen({Key? key})
      : super(
          key: key,
        );

  List<String> dropdownItemList = [
    "Item One",
    "Item Two",
    "Item Three",
  ];

  TextEditingController addTitleSectionController = TextEditingController();

  TextEditingController addDescriptionSectionController =
      TextEditingController();

  TextEditingController addPriceSectionController = TextEditingController();

  TextEditingController maxPriceSectionController = TextEditingController();

  List<String> dropdownItemList1 = [
    "SR",
    "SR",
    "SR",
  ];

  TextEditingController phoneNumberSectionController = TextEditingController();

  TextEditingController whatsNumberSectionController = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper (
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  
                  children: [
                  SizedBox(height: 20,),
                    _buildTapSection(context),
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
                          value: 0.66,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.h,
                        vertical: 11.v,
                      ),
                      decoration: AppDecoration.fillOnPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder12,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add info",
                            style: CustomTextStyles.titleMediumBluegray90001_1,
                          ),
                          SizedBox(height: 12.v),
                          CustomDropDown(
                            icon: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 15.v, 16.h, 15.v),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgCheckmarkGray50001,
                                height: 20.adaptSize,
                                width: 20.adaptSize,
                              ),
                            ),
                            hintText: "Category",
                            items: dropdownItemList,
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
                          _buildAddDescriptionSection(context),
                          SizedBox(height: 4.v),
                          _buildAddPriceSection(context),
                          SizedBox(height: 12.v),
                          _buildAddFrameSection(context),
                          SizedBox(height: 12.v),
                          _buildPhoneNumberSection(context),
                          SizedBox(height: 12.v),
                          _buildWhatsNumberSection(context),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.v),
               
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildFrame(context),
      ),
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
      controller: addTitleSectionController,
      hintText: "Title",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
    );
  }

  /// Section Widget
  Widget _buildAddDescriptionSection(BuildContext context) {
    return CustomTextFormField(
      controller: addDescriptionSectionController,
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
      controller: addPriceSectionController,
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
          controller: maxPriceSectionController,
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
                          controller: addPriceSectionController,
                          labelText: "Max Price",
                          labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
                          hintText: "Price Type",
                          contentPadding: EdgeInsets.only(
                            left: 0.h,
                            right: 0.h,
                            bottom: 12.v,
                          ),
                          borderDecoration: FloatingTextFormFieldStyleHelper.underLine,
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

                          Text("SR", style: TextStyle(color: Color(0XFFD20653),height: 1),),
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
                    items: dropdownItemList1,
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
      controller: phoneNumberSectionController,
      hintText: "Phone number",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      textInputType: TextInputType.phone,
    );
  }

  /// Section Widget
  Widget _buildWhatsNumberSection(BuildContext context) {
    return CustomTextFormField(
      controller: whatsNumberSectionController,
      hintText: "What's number",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.number,
    );
  }

  /// Section Widget
  Widget _buildPreviousButtonSection(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
         onPressed: ()=>  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShareYourAddsThreeScreen())),
        text: "Previous",
        margin: EdgeInsets.only(right: 6.h),
        buttonStyle: CustomButtonStyles.none,
        decoration:
            CustomButtonStyles.gradientSecondaryContainerToOrangeTL12Decoration,
        buttonTextStyle: theme.textTheme.titleMedium!,
      ),
    );
  }

  /// Section Widget
  Widget _buildNextButtonSection(BuildContext context) {
    return Expanded(
      child: CustomElevatedButton(
        onPressed: () =>  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShareYourAddsOneScreen())),
        text: "Next",
        margin: EdgeInsets.only(left: 6.h),
        buttonStyle: CustomButtonStyles.none,
        decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
      ),
    );
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 16.v, horizontal: 20),
      decoration: AppDecoration.fillOnPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPreviousButtonSection(context),
          _buildNextButtonSection(context),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBottomBarSection(BuildContext context) {
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
}
