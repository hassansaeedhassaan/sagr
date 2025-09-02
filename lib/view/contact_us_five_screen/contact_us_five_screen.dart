
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class ContactUsFormScreen extends StatelessWidget {
  ContactUsFormScreen({Key? key})
      : super(
          key: key,
        );

  final TextEditingController tellUsHowWeCanController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  MasterWrapper(
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Contact us"),
          scrolledUnderElevation: 0,
        ),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(height: 16.v),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 11.h,
                        vertical: 12.v,
                      ),
                      decoration: AppDecoration.fillOnPrimary.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Tell ",
                                  style: CustomTextStyles.titleLargeff333333,
                                ),
                                TextSpan(
                                  text: "us how we can help you ? ",
                                  style: CustomTextStyles.titleLargeff333333,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "we will respond as soon as possible",
                            style: CustomTextStyles.bodyMediumGray50001,
                          ),
                          SizedBox(height: 22.v),
                          _buildTellUsHowWeCan(context),
                          SizedBox(height: 12.v),
                          _buildPhoneNumber(context),
                          SizedBox(height: 12.v),
                          _buildEmail(context),
                          SizedBox(height: 12.v),
                          _buildMessage(context),
                          SizedBox(height: 24.v),
                          _buildSubmit(context),
                        ],
                      ),
                    ),
                    // Spacer(),
                  ],
                ),
              ),
            ),
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
        text: "Contact us",
        margin: EdgeInsets.only(left: 16.h),
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildTellUsHowWeCan(BuildContext context) {
    return CustomTextFormField(
      controller: tellUsHowWeCanController,
      hintText: "Name",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
    );
  }

  /// Section Widget
  Widget _buildPhoneNumber(BuildContext context) {
    return CustomTextFormField(
      controller: phoneNumberController,
      hintText: "Phone Number",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      textInputType: TextInputType.phone,
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: "Email ",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      textInputType: TextInputType.emailAddress,
    );
  }

  /// Section Widget
  Widget _buildMessage(BuildContext context) {
    return CustomTextFormField(
      controller: messageController,
      hintText: "Message",
      hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      textInputAction: TextInputAction.done,
      maxLines: 8,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 14.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildSubmit(BuildContext context) {
    return CustomElevatedButton(
      text: "Submit",
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
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
}
