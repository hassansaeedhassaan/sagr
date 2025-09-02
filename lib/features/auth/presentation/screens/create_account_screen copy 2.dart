import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/auth/presentation/controllers/create_account_controller.dart';
import 'package:sagr/features/education/data/models/education_model.dart';
import 'package:sagr/features/education/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import 'package:sagr/features/jobs/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/features/language/data/models/language_model.dart';
import 'package:sagr/features/language/presentation/controllers/languages_controller.dart';
import 'package:sagr/features/marital_status/data/models/marital_status_model.dart';
import 'package:sagr/features/marital_status/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/features/regions/data/models/region_model.dart';
import 'package:sagr/features/regions/presentation/controllers/regions_controller.dart';
import 'package:sagr/view/home_three_screen/home_three_screen.dart';
import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';
import 'package:sagr/widgets/app_bar/appbar_leading_image.dart';
import 'package:sagr/widgets/app_bar/appbar_title_image.dart';
import 'package:sagr/widgets/app_bar/custom_app_bar.dart';
import 'package:sagr/widgets/custom_elevated_button.dart';
import 'package:sagr/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../../../view/widgets/Forms/easy_app_password_form_field.dart';
import '../../../../widgets/Common/custom_dropdown.dart';
import '../../../../widgets/custom_outlined_button.dart';
import '/../core/utils/image_constant.dart';
import '/../core/utils/size_utils.dart';

import '/../theme/app_decoration.dart';
import '/../theme/custom_button_style.dart';
import '/../theme/custom_text_style.dart';
import '/../theme/theme_helper.dart';
import '/../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController passwordController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController passwordController1 = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE_COLOR,
      // appBar: PreferredSize(
      //     preferredSize: Size.fromHeight(100), child: UnAuthenticatedAppBar()),
      body: GetBuilder<CreateAccountController>(
          init: CreateAccountController(Get.find()),
          builder: (CreateAccountController accountController) {
            return SizedBox(
              width: SizeUtils.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: 398.h,
                    margin: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 30.v),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.h,
                      vertical: 30.v,
                    ),
                    decoration: AppDecoration.fillOnPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.h, top: 20),
                            child: Text(
                              "Create Account".tr,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.v),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Text(
                              "Enter your information to register".tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: GREY_COLOR),
                            ),
                          ),
                        ),
                        SizedBox(height: 23.v),
                        // _buildPassword(context),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                            onSave: (value) => accountController.firstName = value!,
                            labelText: "${"First Name".tr}",
                            hintText: "",
                            prefixIcon: Icon(
                              Icons.contact_emergency_outlined,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            onValidate: (value) {
                              if (value?.length == 0) {
                                return "First Name Required!".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                            onSave: (value) => accountController.middleName = value!,
                            labelText: "Middle Name".tr,
                            hintText: "Middle Name".tr,
                            prefixIcon: Icon(
                              Icons.contact_emergency_outlined,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            onValidate: (value) {
                              if (value?.length == 0) {
                                return "Middle Name Required!".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                            onSave: (value) => accountController.lastName = value!,
                            labelText: "Family Name".tr,
                            hintText: "",
                            prefixIcon: Icon(
                              Icons.contact_emergency_outlined,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            onValidate: (value) {
                              if (value?.isEmpty == true) {
                                return "Family Name Required!".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: IntlPhoneField(
                                languageCode: "ar",
                                textAlign: TextAlign.right,
                                textAlignVertical: TextAlignVertical.center,
                                disableAutoFillHints: true,
                                dropdownIconPosition: IconPosition.leading,
                                searchText: "Search Country".tr,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.phone),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintTextDirection: TextDirection.rtl,

                                  label: Text("Phone Number".tr),
                                  hintText: ''.tr,

                                  // label: RichText(
                                  // text: TextSpan(
                                  //     text: 'Phone Number'.tr,
                                  //     style: const TextStyle(
                                  //         fontFamily: "URWD",
                                  //         color: Color.fromARGB(255, 141, 141, 141)),
                                  //     children: [
                                  //   TextSpan(
                                  //       text: ' *',
                                  //       style: TextStyle(
                                  //         color: Colors.red,
                                  //       ))
                                  // ])),

                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                initialCountryCode: 'SA',
                                onChanged: (phone)  => accountController.phone = phone.completeNumber,
                                onCountryChanged: (country) {
                                
                                  accountController
                                      .selectedCountryCode(country.code);
                                }),
                          ),
                        ),

                        SizedBox(height: 15),
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: Container(
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 3, 0),
                              decoration: BoxDecoration(
                                  // color: const Color.fromARGB(255, 219, 48, 48),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromARGB(
                                          255, 192, 192, 192))),
                              child: GetBuilder<RegionsController>(
                                  init: RegionsController(Get.find()),
                                  builder: (regionsController) {
                                    return CustomDropdownV2<RegionModel?>(
                                      leadingIcon: true,
                                      onChange: (int index) =>
                                          accountController.setSelectedRegion(
                                              regionsController.regions[index]),
                                      dropdownButtonStyle: DropdownButtonStyle(
                                          width: double.infinity,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(200)),
                                          height: 50,
                                          elevation: 0,
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          primaryColor: const Color.fromARGB(
                                              221, 205, 205, 205),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween),
                                      dropdownStyle: DropdownStyle(
                                          // width: 340,
                                          color: WHITE_COLOR,
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.grey,
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      items: regionsController.regions
                                          .asMap()
                                          .entries
                                          .map(
                                            (item) =>
                                                DropdownItem<RegionModel?>(
                                              value: item.value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(item.value.name!),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      child: Text(
                                          accountController.selectedRegion.id !=
                                                  null
                                              ? accountController
                                                  .selectedRegion.name!
                                              : "Region".tr),
                                    );
                                  }),
                            )),
                        SizedBox(height: 15),

                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                            onSave: (value) => accountController.nationalNo = value!,
                            labelText: "National Number".tr,
                            hintText: "",
                            prefixIcon: Icon(
                              Icons.contact_page_outlined,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            onValidate: (value) {
                              if (value?.length == 0) {
                                return "National Number Required!".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 15),

                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: Container(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
                              decoration: BoxDecoration(
                                  color: WHITE_COLOR,
                                  border: Border.all(
                                      width: 1,
                                      color: GREY_COLOR.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(8)),
                              child: GestureDetector(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      color: BLACK_COLOR,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Select Birth Date".tr,
                                      style: TextStyle(color: GREY_COLOR),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0))),
                                            contentPadding: EdgeInsets.zero,
                                            insetPadding:
                                                const EdgeInsets.all(15),
                                            content: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Positioned(
                                                      right: 10,
                                                      top: -15,
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  WHITE_COLOR,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: SizedBox(
                                                            width: 22,
                                                            child:
                                                                CustomImageView(
                                                              imagePath:
                                                                  ImageConstant
                                                                      .imgVuesaxLinearUserRemove,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          // width: 300,
                                                          // height: 400,
                                                          child: DatePicker(
                                                            minDate: DateTime(
                                                                1980, 1, 1),
                                                            maxDate: DateTime(
                                                                2023, 12, 31),
                                                            onDateSelected:
                                                                (value) {
                                                              print(value);
                                                              // Handle selected date
                                                            },
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        12),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            42.h,
                                                                        child:
                                                                            CustomElevatedButton(
                                                                          onPressed: () =>
                                                                              Get.back,
                                                                          text:
                                                                              "Agree".tr,
                                                                          margin:
                                                                              EdgeInsets.only(right: 6.h),
                                                                          buttonStyle:
                                                                              CustomButtonStyles.none,
                                                                          decoration:
                                                                              CustomButtonStyles.gradientPrimaryToOrangeDecoration,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10),
                                                                    Expanded(
                                                                      child:
                                                                          CustomOutlinedButton(
                                                                        buttonStyle:
                                                                            OutlinedButton.styleFrom(
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12.0),
                                                                          ),
                                                                          side: BorderSide(
                                                                              width: 1.0,
                                                                              color: Color(0XFFD20653)),
                                                                        ),
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        height:
                                                                            42.v,
                                                                        text: "Cancle"
                                                                            .tr,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                6.h),
                                                                        buttonTextStyle:
                                                                            CustomTextStyles.titleMediumPink60001_1,
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
                                },
                              ),
                            )),

                        SizedBox(height: 15),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                            onSave: (value) => accountController.ibanNumber = value!,
                            labelText: "Iban Number".tr,
                            hintText: "",
                            prefixIcon: Icon(
                              Icons.add_card_rounded,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            onValidate: (value) {
                              if (value?.isEmpty == true) {
                                return "Iban Number Required!".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                            onSave: (value) => accountController.bankAccountName = value!,
                            labelText: "Bank Account Name".tr,
                            hintText: "",
                            prefixIcon: Icon(
                              Icons.add_card_rounded,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            onValidate: (value) {
                              if (value?.length == 0) {
                                return "Bank Account Name Required!".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: Row(
                            children: [
                              Text("النوع"),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(

                                onTap: () => accountController.setGender('male'),
                                child: Row(
                                  children: [
                                    Text("ذكر"),
                                    Container(
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 0, 0),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              width: 2, color: BLACK_COLOR)),
                                      child: accountController.gender == 'male' ? Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: BLACK_COLOR,
                                      ) : null, 
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                   onTap: () => accountController.setGender('female'),
                                child: Row(
                                  children: [
                                    Text("انثي"),
                                    Container(
                                      margin: EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 0, 0),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              width: 2, color: BLACK_COLOR)),
                                       child: accountController.gender == 'female' ? Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: BLACK_COLOR,
                                      ) : null,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),

// InternationalPhoneNumberInput(
//   onInputChanged: (phone){
//     print(phone);
//   },
// ),

                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: Container(
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 3, 0),
                              decoration: BoxDecoration(
                                  // color: const Color.fromARGB(255, 219, 48, 48),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromARGB(
                                          255, 192, 192, 192))),
                              child: GetBuilder<MaritalStatusController>(
                                  init: MaritalStatusController(Get.find()),
                                  builder: (maritalStatusController) {
                                    return CustomDropdownV2<
                                        MaritalStatusModel?>(
                                      leadingIcon: true,
                                      onChange: (int index) => accountController
                                          .setSelectedMaritalStatus(
                                              maritalStatusController
                                                  .maritalStatus[index]),
                                      dropdownButtonStyle: DropdownButtonStyle(
                                          width: double.infinity,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(200)),
                                          height: 50,
                                          elevation: 0,
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          primaryColor: const Color.fromARGB(
                                              221, 205, 205, 205),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween),
                                      dropdownStyle: DropdownStyle(
                                          // width: 340,
                                          color: WHITE_COLOR,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.grey,
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      items: maritalStatusController
                                          .maritalStatus
                                          .asMap()
                                          .entries
                                          .map(
                                            (item) => DropdownItem<
                                                MaritalStatusModel?>(
                                              value: item.value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(item.value.name!),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      child: Row(
                                        children: [
                                          // Icon(Icons.signal_wifi_statusbar_4_bar_outlined),
                                          SizedBox(width: 2),
                                          Text(accountController
                                                      .selectedMaritalStatus
                                                      .id !=
                                                  null
                                              ? accountController
                                                  .selectedMaritalStatus.name!
                                              : "Marital Status".tr)
                                        ],
                                      ),
                                    );
                                  }),
                            )),
                        SizedBox(height: 15),
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: Container(
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                              decoration: BoxDecoration(
                                  // color: const Color.fromARGB(255, 219, 48, 48),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromARGB(
                                          255, 192, 192, 192))),
                              child: GetBuilder<JobsController>(
                                  init: JobsController(Get.find()),
                                  builder: (jobsController) {
                                    return CustomDropdownV2<JobModel?>(
                                      leadingIcon: true,
                                      onChange: (int index) =>
                                          accountController.setSelectedJob(
                                              jobsController.jobs[index]),
                                      dropdownButtonStyle: DropdownButtonStyle(
                                          width: double.infinity,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(200)),
                                          height: 50,
                                          elevation: 0,
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          primaryColor: const Color.fromARGB(
                                              221, 205, 205, 205),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween),
                                      dropdownStyle: DropdownStyle(
                                          // width: 340,
                                          color: WHITE_COLOR,
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.grey,
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      items: jobsController.jobs
                                          .asMap()
                                          .entries
                                          .map(
                                            (item) => DropdownItem<JobModel?>(
                                              value: item.value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(item.value.name!),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      child: Text(accountController
                                                  .selectedJob.id !=
                                              null
                                          ? accountController.selectedJob.name!
                                          : "Job Status".tr),
                                    );
                                  }),
                            )),

                        SizedBox(height: 15),
//                         SizedBox(
//   width: 300,
//   height: 400,
//   child: DatePicker(
//   minDate: DateTime(2021, 1, 1),
//   maxDate: DateTime(2023, 12, 31),
//   onDateSelected: (value) {
//     // Handle selected date
//   },
//  ),
// ),

                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: Container(
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                              decoration: BoxDecoration(
                                  // color: const Color.fromARGB(255, 219, 48, 48),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromARGB(
                                          255, 192, 192, 192))),
                              child: GetBuilder<EducationsController>(
                                  init: EducationsController(Get.find()),
                                  builder: (educationController) {
                                    return CustomDropdownV2<EducationModel?>(
                                      leadingIcon: true,
                                      onChange: (int index) => accountController
                                          .setSelectedEducation(
                                              educationController
                                                  .educations[index]),
                                      dropdownButtonStyle: DropdownButtonStyle(
                                          width: double.infinity,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(200)),
                                          height: 50,
                                          elevation: 0,
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          primaryColor: const Color.fromARGB(
                                              221, 205, 205, 205),
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween),
                                      dropdownStyle: DropdownStyle(
                                          // width: 340,
                                          color: WHITE_COLOR,
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.grey,
                                                width: 0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      items: educationController.educations
                                          .asMap()
                                          .entries
                                          .map(
                                            (item) =>
                                                DropdownItem<EducationModel?>(
                                              value: item.value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(item.value.name!),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      child: Text(accountController
                                                  .selectedEducation.id !=
                                              null
                                          ? accountController
                                              .selectedEducation.name!
                                          : "Education Level".tr),
                                    );
                                  }),
                            )),

                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: Container(
                              // height: 50,
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(3, 15, 3, 10),
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                              decoration: BoxDecoration(
                                  // color: const Color.fromARGB(255, 219, 48, 48),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1,
                                      color: const Color.fromARGB(
                                          255, 192, 192, 192))),
                              child: GetBuilder<LanguagesController>(
                                  init: LanguagesController(Get.find()),
                                  builder: (languageController) {
                                    return SizedBox(
                                      child: CustomDropdown<
                                          LanguageModel>.multiSelect(
                                        decoration: CustomDropdownDecoration(),
                                        hintText: 'Languages',
                                        items: languageController.languages
                                            .toList(),
                                        initialItems: [],
                                        onListChanged: (value) {
                                          print(value);
                                          // log('SimpleDropdown onChanged value: $value');
                                        },
                                      ),
                                    );

                                    // return CustomDropdownV2<EducationModel?>(
                                    //   leadingIcon: true,
                                    //   onChange: (int index) => accountController
                                    //       .setSelectedEducation(
                                    //           educationController
                                    //               .educations[index]),
                                    //   dropdownButtonStyle: DropdownButtonStyle(
                                    //       width: double.infinity,
                                    //       shape: RoundedRectangleBorder(
                                    //           borderRadius:
                                    //               BorderRadius.circular(200)),
                                    //       height: 50,
                                    //       elevation: 0,
                                    //       backgroundColor: const Color.fromARGB(
                                    //           255, 255, 255, 255),
                                    //       primaryColor: const Color.fromARGB(
                                    //           221, 205, 205, 205),
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.spaceBetween),
                                    //   dropdownStyle: DropdownStyle(
                                    //       // width: 340,
                                    //       color: WHITE_COLOR,
                                    //       elevation: 0,
                                    //       padding: EdgeInsets.all(0),
                                    //       shape: RoundedRectangleBorder(
                                    //           side: BorderSide(
                                    //             color: Colors.grey,
                                    //             width: 0,
                                    //           ),
                                    //           borderRadius:
                                    //               BorderRadius.circular(8))),
                                    //   items: educationController.educations
                                    //       .asMap()
                                    //       .entries
                                    //       .map(
                                    //         (item) =>
                                    //             DropdownItem<EducationModel?>(
                                    //           value: item.value,
                                    //           child: Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(8.0),
                                    //             child: Text(item.value.name!),
                                    //           ),
                                    //         ),
                                    //       )
                                    //       .toList(),
                                    //   child: Text(accountController
                                    //               .selectedEducation.id !=
                                    //           null
                                    //       ? accountController
                                    //           .selectedEducation.name!
                                    //       : "Job Status".tr),
                                    // );
                                  }),
                            )),

                        SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                            enable: false,
                            required: false,
                            multiline: 3,
                            onSave: (value) => accountController.experts = value!,
                            labelText: "Experts".tr,
                            hintText: "",
                          ),
                        ),

                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                            required: false,
                            textInputType: TextInputType.number,
                            onSave: (value) => accountController.previousEvents = value!,
                            labelText: "Previous Events Past".tr,
                            hintText: "",
                            onValidate: (value) {
                              if (value?.length == 0) {
                                return "Previous Events Past Required!".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 10, 0),
                          child: EasyAppTextFormField(
                              required: false,
                              multiline: 3,
                              onSave: (value) =>
                                  accountController.chronicDiseases = value!,
                              labelText: "Chronic diseases".tr),
                        ),

                        SizedBox(height: 12.v),

                        // Password
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: EasyAppPasswordFormField(
                              onSave: (value) =>
                                  accountController.password = value!,
                              labelText: "Password",
                              hintText: "",
                              onValidate: (value) {
                                if (value?.length == 0) {
                                  return "Password Required!".tr;
                                } else {
                                  return null;
                                }
                              },
                            )),
                        SizedBox(height: 12.v),
                        // _buildConfirmPassword(context),
                        // Password Confirmation
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 10, 0),
                            child: EasyAppPasswordFormField(
                              onSave: (value) => accountController
                                  .confirmationPassword = value!,
                              labelText: "Confirm Password",
                              hintText: "",
                              onValidate: (value) {
                                if (value?.length == 0) {
                                  return "Confirm Password Required!".tr;
                                } else {
                                  return null;
                                }
                              },
                            )),

                        SizedBox(height: 15),
                        /*Pick FIles */
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                          child: Container(
                            // decoration: BoxDecoration(
                            //   color: const Color.fromARGB(255, 183, 183, 183)
                            // ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 20, 10, 20),
                                      decoration: BoxDecoration(
                                          // color: ZAHRA_ORANGE,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 1,
                                              color: BLACK_COLOR,
                                              style: BorderStyle.solid)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf,
                                            size: 40,
                                            color: BLACK_COLOR,
                                          ),
                                          Text("إرفاق مستند الايبان")
                                        ],
                                      ),
                                    ),
                                    onTap: () =>
                                        accountController.handleFileSelectionForIban(),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    child: Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 20, 10, 20),
                                      decoration: BoxDecoration(
                                          // color: ZAHRA_ORANGE,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 1,
                                              color: BLACK_COLOR.withValues(
                                                  alpha: 2),
                                              style: BorderStyle.solid)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.picture_as_pdf,
                                            size: 40,
                                            color: BLACK_COLOR,
                                          ),
                                          Text("إرفاق السيرة الذاتية")
                                        ],
                                      ),
                                    ),
                                    onTap: () =>
                                        accountController.handleFileSelection(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        /*Pick Image */
                        GestureDetector(
                          onTap: () => accountController.pickImage(),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 60,
                            padding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 40),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.camera_enhance,
                                  size: 60,
                                  color: BLACK_COLOR,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("التقط صورة شخصية")
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 12.v),
                        _buildFrame(context),
                        SizedBox(height: 23.v),

                        CustomElevatedButton(
                          onPressed: accountController.isLoading
                              ? null
                              : () {
                                  _formKey.currentState!.save();
                                  if (_formKey.currentState!.validate()) {
                                    accountController.register();
                                  }
                                },
                          text: accountController.isLoading
                              ? "Creating Account..."
                              : "Create Account".tr,
                          margin: EdgeInsets.symmetric(horizontal: 8.h),
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles
                              .gradientPrimaryToOrangeDecoration,
                        ),

                        // _buildCreateAccountButton(context),
                        SizedBox(height: 23.v),
                        // _buildFrame1(context),
                        // SizedBox(height: 16.v),
                        // _buildLogInByGmailButton(context),
                        // SizedBox(height: 12.v),
                        // _buildLogInByAppleButton(context),
                        // SizedBox(height: 16.v),

                        GestureDetector(
                          onTap: () => Get.toNamed('/login'),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Already have an account?".tr,
                                  style:
                                      CustomTextStyles.titleMedium16!.copyWith(
                                    fontSize: 14.fSize,
                                    color: Color.fromARGB(255, 110, 110, 110),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Login".tr,
                                  style: CustomTextStyles.titleMedium14
                                      .copyWith(color: BLACK_COLOR),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 64.v,
      leadingWidth: 47.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(
          left: 24.h,
          top: 20.v,
          bottom: 19.v,
        ),
      ),
      centerTitle: true,
      title: AppbarTitleImage(
        imagePath: ImageConstant.imgLayer1,
      ),
      styleType: Style.bgFill,
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        autofocus: false,
        controller: passwordController,
        hintText: "Name",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        controller: emailController,
        autofocus: false,
        hintText: "Email",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        textInputType: TextInputType.emailAddress,
      ),
    );
  }

  /// Section Widget
  Widget _buildPhoneNumber(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        controller: phoneNumberController,
        hintText: "Phone Number",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        textInputType: TextInputType.phone,
      ),
    );
  }

  /// Section Widget
  Widget _buildPassword1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        controller: passwordController1,
        hintText: "Password",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        textInputType: TextInputType.visiblePassword,
        suffix: Container(
          margin: EdgeInsets.fromLTRB(30.h, 13.v, 16.h, 13.v),
          child: CustomImageView(
            imagePath: ImageConstant.imgEye,
            height: 24.adaptSize,
            width: 24.adaptSize,
          ),
        ),
        suffixConstraints: BoxConstraints(
          maxHeight: 50.v,
        ),
        obscureText: true,
        contentPadding: EdgeInsets.only(
          left: 16.h,
          top: 15.v,
          bottom: 15.v,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: CustomTextFormField(
        controller: confirmPasswordController,
        hintText: "Confirm Password",
        hintStyle: CustomTextStyles.bodyMediumErrorContainer,
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,
        suffix: Container(
          margin: EdgeInsets.fromLTRB(30.h, 13.v, 16.h, 13.v),
          child: CustomImageView(
            imagePath: ImageConstant.imgEyeGray50001,
            height: 24.adaptSize,
            width: 24.adaptSize,
          ),
        ),
        suffixConstraints: BoxConstraints(
          maxHeight: 50.v,
        ),
        obscureText: true,
        contentPadding: EdgeInsets.only(
          left: 16.h,
          top: 15.v,
          bottom: 15.v,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return GetBuilder<CreateAccountController>(
        init: CreateAccountController(Get.find()),
        builder: (CreateAccountController accountController) {
          return Align(
            // alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.h,
                    right: 24.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => accountController.acceptAgree(),
                        child: Container(
                          height: 21.adaptSize,
                          width: 21.adaptSize,
                          margin: EdgeInsets.only(bottom: 18.v, top: 2),
                          child: accountController.agree != true
                              ? SizedBox.shrink()
                              : Center(
                                  child: Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  weight: 10,
                                  opticalSize: 20,
                                )),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.4,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              borderRadius: BorderRadius.circular(6)),
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
                          margin: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "By signing up, I agree with the ".tr,
                                  style: CustomTextStyles.titleSmallff333333,
                                ),
                                TextSpan(
                                  text: "Terms of Use  & Privacy Policy".tr,
                                  style: CustomTextStyles.titleSmallffd20653
                                      .copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                accountController.agree_error_message
                    ? Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          "Please, agree on terms of Use & Privacy Policy.",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 17, 0),
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          );
        });
  }

  /// Section Widget
  Widget _buildCreateAccountButton(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeThreeScreen())),
      text: "Cteate Account",
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
    );
  }

  /// Section Widget
  Widget _buildFrame1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 11.v,
                bottom: 9.v,
              ),
              child: SizedBox(
                width: 169.h,
                child: Divider(
                  color: appTheme.gray300,
                ),
              ),
            ),
          ),
          Text(
            "OR",
            style: CustomTextStyles.titleMediumBluegray9000116,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 11.v,
                bottom: 9.v,
              ),
              child: SizedBox(
                width: 169.h,
                child: Divider(
                  color: appTheme.gray300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLogInByGmailButton(BuildContext context) {
    return CustomElevatedButton(
      height: 48.v,
      text: "Log in by gmail",
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 30.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgGoogle,
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
      ),
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: Color(0xfffff4e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      ),
      buttonTextStyle: CustomTextStyles.titleSmallBold,
    );
  }

  /// Section Widget
  Widget _buildLogInByAppleButton(BuildContext context) {
    return CustomElevatedButton(
      height: 48.v,
      text: "Log in by Apple",
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 30.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgApplelogo,
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillGray,
      buttonTextStyle: CustomTextStyles.titleSmallBold,
    );
  }
}
