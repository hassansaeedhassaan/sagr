import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/cards/presentation/controllers/cards_controller.dart';
import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/custom_text_form_field.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../core/utils/size_utils.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/appbar/basic_app_bar.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_image_view.dart';

class CreateNewCardScreen extends StatelessWidget {
  final CardsController _controller;

  CreateNewCardScreen(this._controller, {Key? key})
      : super(
          key: key,
        );

  final TextEditingController cardNumberEditTextController =
      TextEditingController();

  final TextEditingController nameEditTextController = TextEditingController();

  final TextEditingController ccvCodeEditTextController =
      TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(66),
          child: BasicAppBar(title: "Add new card")),
      // appBar: AppBar(
      //   title: Text("Add new card"),
      // ),
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
                  SizedBox(height: 16.v),
                  _buildFrame(context),
                  // Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(context),
    );
  }

  /// Section Widget
  Widget _buildCardNumberEditText(BuildContext context) {
    return EasyAppTextFormField(
      inputFormatters: [CreditCardFormatter(separator: '-')],
      labelText: "Card Number".tr,
      hintText: "Card Number".tr,
      suffixIcon: Container(
        margin: EdgeInsets.fromLTRB(30.h, 14.v, 12.h, 14.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgThumbsUpGray6000124x24,
          height: 22.adaptSize,
          width: 22.adaptSize,
        ),
      ),
      onSave: (value) => _controller.card_number = value,
      onValidate: (value) {
        if (value?.length == 0) {
          return "field_required";
        } else {
          return null;
        }
      },
    );
  }

  /// Section Widget
  Widget _buildNameEditText(BuildContext context) {
    return EasyAppTextFormField(
      labelText: "Name",
      hintText: "Name",
      onSave: (value) => _controller.card_name = value,
      onValidate: (value) {
        if (value?.length == 0) {
          return "field_required";
        } else {
          return null;
        }
      },
    );
  }

  /// Section Widget
  Widget _buildCcvCodeEditText(BuildContext context) {
    return Expanded(
        child: EasyAppTextFormField(
      maxLength: 3,
      labelText: "CCV Code".tr,
      hintText: "CCV Code".tr,
      suffixIcon: Container(
        margin: EdgeInsets.fromLTRB(30.h, 14.v, 12.h, 14.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgVideocameraGray60001,
          height: 22.adaptSize,
          width: 22.adaptSize,
        ),
      ),
      onSave: (value) => _controller.card_ccv = value,
      onValidate: (value) {
        if (value?.length == 0) {
          return "field_required";
        } else {
          return null;
        }
      },
    ));
  }

  /// Section Widget
  Widget _buildExpireDateEditText(BuildContext context) {
    return Expanded(
        child: EasyAppTextFormField(
      maxLength: 5,
      labelText: "Expire date",
      hintText: "Expire date",
      suffixIcon: Container(
        margin: EdgeInsets.fromLTRB(30.h, 14.v, 12.h, 14.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgCalendar,
          height: 22.adaptSize,
          width: 22.adaptSize,
        ),
      ),
      onSave: (value) => _controller.card_expire_date = value,
      onValidate: (value) {
        if (value?.length == 0) {
          return "field_required";
        } else {
          return null;
        }
      },
      inputFormatters: [ValidityDateFormatter(separator: '/')],
    ));
  }

  /// Section Widget
  Widget _buildSaveYourDataButton(BuildContext context) {
    return Obx(() => _controller.isLoadingSave
        ? Stack(
            children: <Widget>[
              // Container(
              //   decoration:
              //       BoxDecoration(borderRadius: BorderRadius.circular(8.h)),
              //   height: 50.h,
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(8.h),
              //     child: GradientProgressIndicator(
              //       gradient: LinearGradient(
              //         // begin: Alignment(0.0, 1),
              //         end: Alignment(1.0, 1),
              //         colors: [
              //           theme.colorScheme.primary,
              //           appTheme.orange400,
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
     
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Saving Card data",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: WHITE_COLOR),
                ),
                alignment: Alignment.bottomCenter,
              ),
            ],
          )

    

        : CustomElevatedButton(
            onPressed: () {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                _controller.saveCard(context);
              }
            },
            text: "Save your data",
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
          ));
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardNumberEditText(context),
          SizedBox(height: 12.v),
          _buildNameEditText(context),
          SizedBox(height: 12.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildExpireDateEditText(context),
              SizedBox(width: 10.v),
              _buildCcvCodeEditText(context),
            ],
          ),
          SizedBox(height: 12.v),
          Obx(() => Padding(
            padding: EdgeInsets.only(right: 15.h),
            child: GestureDetector(
              onTap: () => _controller.setAgreeTermsAndConditions(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Container(
                   height: 21.adaptSize,
                    width: 21.adaptSize,
                    margin: EdgeInsets.only(bottom: 18.v, top: 2),
                    child: _controller.agree != true  ? SizedBox.shrink() : Center(child: Icon(Icons.check, size: 16,color: Color(0XFFD20653), weight: 10, opticalSize: 20,)),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.4, color: Color(0XFFD20653),),
                      borderRadius: BorderRadius.circular(6)
                    ),
                  ),
                  
                  // CustomImageView(
                  //   imagePath: ImageConstant.imgCheckmark,
                  //   height: 24.adaptSize,
                  //   width: 24.adaptSize,
                  //   margin: EdgeInsets.only(bottom: 18.v),
                  // ),
                  Expanded(
                    child: Container(
                      width: 322.h,
                      margin: EdgeInsets.only(left: 12.h),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "By ",
                              style: CustomTextStyles.titleSmallff333333,
                            ),
                            TextSpan(
                              text: "adding a new card, I agree with the",
                              style: CustomTextStyles.titleSmallff333333,
                            ),
                            TextSpan(
                              text: " ",
                            ),
                            TextSpan(
                              text: "Terms ",
                              style: CustomTextStyles.titleSmallffd20653.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: "of Use",
                              style: CustomTextStyles.titleSmallffd20653.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: " ",
                            ),
                            TextSpan(
                              text: "& ",
                              style: CustomTextStyles.titleSmallff333333,
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style: CustomTextStyles.titleSmallffd20653.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
          SizedBox(height: 23.v),
          _buildSaveYourDataButton(context),
        ],
      ),
    );
  }
}

class ExpireDateFormatter extends TextInputFormatter {
  final String separator;

  ExpireDateFormatter({required this.separator});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var text = nextValue.text;
    if (text.length == 1 && int.parse(text) > 1) {
      // Ensure the first digit (month) is not greater than 1
      text = '0$text$separator';
    } else if (text.length == 2 && int.parse(text) > 12) {
      // Ensure the entered month is valid (not greater than 12)
      text = '12$separator';
    } else if (text.length > 2) {
      text = '${text.substring(0, 2)}$separator${text.substring(2)}';
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class ValidityDateFormatter extends TextInputFormatter {
  final String separator;

  ValidityDateFormatter({required this.separator});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var oldS = oldValue.text;
    var newS = newValue.text;
    var endsWithSeparator = false;

    // if you add text
    if (newS.length > oldS.length) {
      for (var char in separator.characters) {
        if (newS.substring(0, newS.length - 1).endsWith(char)) {
          endsWithSeparator = true;
        }
      }
      print(
          'Ends with separator: $endsWithSeparator, so we will add it with next digit.');

      var clean = newS.replaceAll(separator, '');
      print('CLEAN add: $clean');

      // enter only digits
      var isDigit = int.tryParse(newS.characters.last);
      if (isDigit == null) {
        return oldValue;
      }

      // check that the month is not greater than 12
      if (clean.length == 2) {
        var month = int.parse(clean.substring(0, 2));
        if (month > 12) {
          return oldValue;
        }
      }

      if (!endsWithSeparator && clean.length > 1 && clean.length % 2 == 1) {
        print('object $clean');

        return newValue.copyWith(
          text: newS.substring(0, newS.length - 1) +
              separator +
              newS.characters.last,
          selection: TextSelection.collapsed(
            offset: newValue.selection.end + separator.length,
          ),
        );
      }
    }

    // if you delete text
    if (newS.length < oldS.length) {
      for (var char in separator.characters) {
        if (oldS.substring(0, oldS.length - 1).endsWith(char)) {
          endsWithSeparator = true;
        }
      }
      print('Ends with separator: $endsWithSeparator, so we removed it');

      var clean = oldS.substring(0, oldS.length - 1).replaceAll(separator, '');
      print('CLEAN remove: $clean');
      if (endsWithSeparator && clean.isNotEmpty && clean.length % 2 == 0) {
        return newValue.copyWith(
          text: newS.substring(0, newS.length - separator.length),
          selection: TextSelection.collapsed(
            offset: newValue.selection.end - separator.length,
          ),
        );
      }
    }

    return newValue;
  }
}
