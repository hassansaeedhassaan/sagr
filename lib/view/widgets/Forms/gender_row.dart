
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/colors.dart';
import '../../../data/constants.dart';
import '../../../utilities/localizations/app_language.dart';

class GenderRow extends StatelessWidget {

    final Function(String? val)? onChangeGender;
    final Function(String? val)? onSave;
  // final Function(dynamic val)? onValidate;
  String? Function(String? val)? onValidate;
  final String? labelText;
  final String? hintText;
  final String? genderValue;
  final bool obscureText;

   GenderRow(
      {Key? key,
      this.onSave,
      this.onValidate,
      this.labelText,
      this.hintText,
      this.genderValue,
      this.obscureText = true,
      this.onChangeGender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppLanguage>(
        init: AppLanguage(),
        builder: (controller) {
          return Container(
            height: 48.0,
            decoration: BoxDecoration(
                border: controller.appLocale == "en"
                    ? Border(left: BorderSide(width: 4, color: PRIMARY_COLOR))
                    : Border(
                        right: BorderSide(width: 4, color: PRIMARY_COLOR))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    color: FILL_COLOR,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'gender'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FONT_FAMILY,
                            fontSize: 20.0,
                            color: LABEL_COLOR),
                      ),
                    ),
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChangeGender!('male'),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10.0),
                      color: FILL_COLOR,
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Icon(
                              genderValue == 'male'
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: LABEL_COLOR,
                              size: 26.0,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              "male".tr,
                              style: TextStyle(
                                  height: 2,
                                  fontFamily: FONT_FAMILY,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: BLACK_COLOR),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onChangeGender!('female'),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10.0),
                      color: FILL_COLOR,
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Icon(
                              genderValue == 'female'
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: LABEL_COLOR,
                              size: 26.0,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              "female".tr,
                              style: TextStyle(
                                  height: 2,
                                  fontFamily: FONT_FAMILY,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0,
                                  color: BLACK_COLOR),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
