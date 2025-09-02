import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/app/view_model/profile/profile_controller.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/models/country_model.dart';
import 'package:sagr/view/widgets/Forms/custom_email_form_field.dart';
import 'package:sagr/view/widgets/Forms/custom_phone_form_field.dart';
import 'package:sagr/view/widgets/Forms/custom_text_form_field.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/appbar/basic_app_bar.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

class ContactUsOneScreen extends StatelessWidget {
  ContactUsOneScreen({Key? key})
      : super(
          key: key,
        );

  final TextEditingController floatingTextFieldNameController =
      TextEditingController();

  final TextEditingController floatingTextFieldEmailController =
      TextEditingController();

  final TextEditingController floatingTextFieldPhoneController =
      TextEditingController();

  final TextEditingController floatingTextFieldCountryController =
      TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(66),
          child: BasicAppBar(
            title: 'General Info',
          )),
      body: GetBuilder<ProfileController>(
        init: ProfileController(Get.find()),
        builder: (_controller) {
          return SizedBox(
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
                      SizedBox(height: 16.v),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.h),
                        padding: EdgeInsets.all(12.h),
                        decoration: AppDecoration.fillOnPrimary.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 119.v,
                              width: 118.h,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(56.h),
                                    ),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(56.h),
                                        child: _controller.imagePath == ''
                                            ? Image.network(
                                                _controller.authenticatedUser![
                                                    'image'],
                                                fit: BoxFit.cover,
                                                height: 113.adaptSize,
                                                width: 113.adaptSize,
                                              )
                                            : Image.file(
                                                File(_controller.imagePath),
                                                fit: BoxFit.cover,
                                                height: 113.adaptSize,
                                                width: 113.adaptSize,
                                              )),
                                  ),
                                  CustomIconButton(
                                    onTap: () => _controller.pickImage(),
                                    height: 40.v,
                                    width: 41.h,
                                    padding: EdgeInsets.all(8.h),
                                    decoration:
                                        IconButtonStyleHelper.fillOnPrimaryTL20,
                                    alignment: Alignment.bottomRight,
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgUserPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.v),
                            CustomTextFormField(
                              initialValue:
                                  _controller.authenticatedUser!['name'],
                              labelText: "Name",
                              hintText: "Name",
                              onSave: (value) => _controller.name = value!,
                            ),
                            SizedBox(height: 15.v),
                            CustomEmailFormField(
                              hintText: "Email",
                              labelText: "Email",
                              onSave: (value) => _controller.email = value!,
                              initialValue:
                                  _controller.authenticatedUser!['email'],
                            ),
                            SizedBox(height: 15.v),
                            CustomPhoneFormField(
                              initialValue: _controller
                                  .authenticatedUser!['phone_number'],
                              onSave: (value) => _controller.phone = value!,
                            ),
                            // _buildFloatingTextFieldPhone(context),
                            // SizedBox(height: 15.v),
                            // _buildFloatingTextFieldCountry(context),
                            SizedBox(height: 15.v),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: GREY_COLOR.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(8)),
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButton<CountryModel>(
                                  underline: SizedBox.shrink(),
                                  dropdownColor: WHITE_COLOR,
                                  isDense: true,
                                  isExpanded: true,
                                  value: _controller.countries.firstWhereOrNull(
                                      (element) =>
                                          element.id ==
                                          _controller.selectedCountry),
                                  // dropdownColor: Colors.green,
                                  icon: CustomImageView(
                                    imagePath:
                                        ImageConstant.imgCheckmarkGray50001,
                                    height: 20.adaptSize,
                                    width: 20.adaptSize,
                                  ),
                                  elevation: 10,
                                  items: _controller.countries
                                      .map((CountryModel value) =>
                                          DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value.name!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (newmenu) {
                                    _controller
                                        .changeSelectedCountry(newmenu?.id);
                                    // setState(() {
                                    //   drodownvalues = newmenu!;
                                    // });
                                  }),
                            ),

                            SizedBox(height: 24.v),
                            CustomElevatedButton(
                              onPressed: () {
                                _formKey.currentState!.save();
                                if (_formKey.currentState!.validate()) {
                                  _controller.updateProfile(context);
                                }
                              },
                              text: "Update ",
                              buttonStyle: CustomButtonStyles.none,
                              decoration: CustomButtonStyles
                                  .gradientPrimaryToOrangeDecoration,
                            )
                            // _buildButtonUpdate(context),
                          ],
                        ),
                      )

                      // SizedBox(

                      //   child: DropdownMenu<ColorLabel>(

                      //     enableFilter: false,
                      //     enableSearch: false,
                      //   // initialSelection: ColorLabel.green,
                      //   // controller: colorController,
                      //   // requestFocusOnTap is enabled/disabled by platforms when it is null.
                      //   // On mobile platforms, this is false by default. Setting this to true will
                      //   // trigger focus request on the text field and virtual keyboard will appear
                      //   // afterward. On desktop platforms however, this defaults to true.
                      //   // requestFocusOnTap: true,
                      //   label: const Text('Color qw' ),
                      //   onSelected: (ColorLabel? color) {
                      //     // setState(() {
                      //     //   selectedColor = color;
                      //     // });
                      //   },
                      //   dropdownMenuEntries: ColorLabel.values
                      //       .map<DropdownMenuEntry<ColorLabel>>(
                      //           (ColorLabel color) {
                      //     return DropdownMenuEntry<ColorLabel>(
                      //       value: color,
                      //       label: color.label,
                      //       enabled: color.label != 'Grey',
                      //       style: MenuItemButton.styleFrom(
                      //         foregroundColor: color.color,
                      //       ),
                      //     );
                      //   }).toList(),
                      //                       ),
                      // ),
                      // Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildFloatingTextFieldName(BuildContext context, String? name) {
    return CustomFloatingTextField(
      controller: floatingTextFieldNameController,
      labelText: "Name",
      labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
      hintText: "Name",
    );
  }

  /// Section Widget
  Widget _buildFloatingTextFieldEmail(BuildContext context) {
    return CustomFloatingTextField(
      controller: floatingTextFieldEmailController,
      labelText: "Email",
      labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
      hintText: "Email",
      textInputType: TextInputType.emailAddress,
    );
  }

  /// Section Widget
  Widget _buildFloatingTextFieldPhone(BuildContext context) {
    return CustomFloatingTextField(
      controller: floatingTextFieldPhoneController,
      labelText: "Phone",
      labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
      hintText: "Phone",
      textInputType: TextInputType.phone,
    );
  }

  /// Section Widget
  Widget _buildFloatingTextFieldCountry(BuildContext context) {
    return CustomFloatingTextField(
      controller: floatingTextFieldCountryController,
      labelText: "Country",
      labelStyle: CustomTextStyles.titleMediumBluegray90001Medium,
      hintText: "Country",
      textInputAction: TextInputAction.done,
      suffix: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCheckmarkGray50001,
          height: 20.adaptSize,
          width: 20.adaptSize,
        ),
      ),
      suffixConstraints: BoxConstraints(
        maxHeight: 57.v,
      ),
    );
  }

  /// Section Widget
  Widget _buildButtonUpdate(BuildContext context) {
    return CustomElevatedButton(
      text: "Update",
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
