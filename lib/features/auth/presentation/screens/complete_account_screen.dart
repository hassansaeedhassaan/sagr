import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/auth/presentation/controllers/create_account_controller.dart';
import 'package:sagr/features/education/data/models/education_model.dart';
import 'package:sagr/features/education/presentation/controllers/education_status_controller.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import 'package:sagr/features/jobs/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/features/language/data/models/language_model.dart';
import 'package:sagr/features/language/presentation/controllers/languages_controller.dart';
import 'package:sagr/features/marital_status/data/models/marital_status_model.dart';
import 'package:sagr/features/marital_status/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/features/nationalities/data/models/nationality_model.dart';

import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/Common/custom_dropdown.dart';
import '../../../regions/data/models/region_model.dart';
import '/../core/utils/size_utils.dart';

import 'package:sagr/features/nationalities/presentation/controllers/nationalities_controller.dart';
import 'package:sagr/features/regions/presentation/controllers/regions_controller.dart';

class CompleteAccountScreen extends StatefulWidget {
  CompleteAccountScreen({Key? key}) : super(key: key);

  @override
  _CompleteAccountScreenState createState() => _CompleteAccountScreenState();
}

class _CompleteAccountScreenState extends State<CompleteAccountScreen>
    with TickerProviderStateMixin {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateAccountController _accountController =
      Get.put(CreateAccountController(Get.find()));

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedField({
    required Widget child,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (delay * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  NationalitiesController nationalitiesController =
      Get.put(NationalitiesController(Get.find()));

  RegionsController regionsController = Get.put(RegionsController(Get.find()));

  Widget _buildModernGenderSelector(CreateAccountController accountController) {
    return _buildAnimatedField(
      delay: 6,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "النوع",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildGenderOption(
                    accountController,
                    'male',
                    'ذكر',
                    Icons.male,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildGenderOption(
                    accountController,
                    'female',
                    'انثي',
                    Icons.female,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(
    CreateAccountController accountController,
    String gender,
    String label,
    IconData icon,
  ) {
    final isSelected = accountController.gender == gender;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => accountController.setGender(gender),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [SAGR_PRIMARY, SAGR_PRIMARY],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    key: ValueKey(isSelected),
                    color: isSelected ? Colors.white : Colors.grey[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFileUpload(
    String title,
    Widget icon,
    VoidCallback onTap,
    int delay,
  ) {
    return _buildAnimatedField(
      delay: delay,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade50, Colors.grey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: SAGR_PRIMARY,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        icon,
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        )
                      ],
                    ),
                  ),
                  // const SizedBox(height: 12),
                  // Text(
                  //   title,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.grey[800],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernImageUpload(CreateAccountController accountController) {
    return _buildAnimatedField(
      delay: 10,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => accountController.pickImage(),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: accountController.imagePath != '' ? 10 : 40,
                  horizontal: accountController.imagePath != '' ? 10 : 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: accountController.imagePath != ''
                  ? Image.file(File(accountController.imagePath))
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 40,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "التقط صورة شخصية",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCheckbox(CreateAccountController accountController) {
    return _buildAnimatedField(
      delay: 11,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => accountController.acceptAgree(),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 24,
                  width: 24,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    gradient: accountController.agree
                        ? LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600
                            ],
                          )
                        : null,
                    color: accountController.agree ? null : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 2,
                      color: accountController.agree
                          ? Colors.green.shade600
                          : Colors.grey.shade400,
                    ),
                  ),
                  child: accountController.agree
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "By signing up, I agree with the ".tr,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: "Terms of Use & Privacy Policy".tr,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: GetBuilder<CreateAccountController>(
        init: CreateAccountController(Get.find()),
        builder: (CreateAccountController accountController) {
          return SizedBox(
            width: SizeUtils.width,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16.h, 40.v, 16.h, 30.v),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.h,
                          vertical: 40.v,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildAnimatedField(
                              delay: 0,
                              child: Column(
                                children: [
                                  // Container(
                                  //   padding: const EdgeInsets.all(15),
                                  //   decoration: BoxDecoration(
                                  //     gradient: LinearGradient(
                                  //       colors: [Colors.blue.shade400, Colors.blue.shade600],
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(50),
                                  //   ),
                                  //   child: Icon(
                                  //     Icons.person_3_rounded,
                                  //     size: 30,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 20),
                                  Text(
                                    "Complete Account".tr,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Enter your information to register".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),

                            _buildAnimatedField(
                              delay: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: EasyAppTextFormField(
                                  onSave: (value) =>
                                      accountController.firstName = value!,
                                  labelText: "First Name".tr,
                                  hintText: "",
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: SAGR_PRIMARY,
                                  ),
                                  onValidate: (value) {
                                    if (value?.length == 0) {
                                      return "First Name Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            _buildAnimatedField(
                              delay: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: EasyAppTextFormField(
                                  onSave: (value) =>
                                      accountController.middleName = value!,
                                  labelText: "Middle Name".tr,
                                  hintText: "Middle Name".tr,
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: SAGR_PRIMARY,
                                  ),
                                  onValidate: (value) {
                                    if (value?.length == 0) {
                                      return "Middle Name Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            _buildAnimatedField(
                              delay: 3,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: EasyAppTextFormField(
                                  onSave: (value) =>
                                      accountController.lastName = value!,
                                  labelText: "Family Name".tr,
                                  hintText: "",
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: SAGR_PRIMARY,
                                  ),
                                  onValidate: (value) {
                                    if (value?.isEmpty == true) {
                                      return "Family Name Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            _buildAnimatedField(
                              delay: 5,
                              child: EasyAppTextFormField(
                                onSave: (value) =>
                                    accountController.nationalNo = value!,
                                labelText: "National Number".tr,
                                hintText: "",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: SAGR_PRIMARY,
                                ),
                                onValidate: (value) {
                                  if (value?.length == 0) {
                                    return "National Number Required!".tr;
                                  }
                                  if (value?.length != 10) {
                                    return "National ID Should be 10 Digits!"
                                        .tr;
                                  }
                              
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Educations
                            SizedBox(
                              height: 50,
                              child: _buildAnimatedField(
                                  delay: 3,
                                  child: Container(
                                    // margin:
                                    //     EdgeInsetsDirectional.fromSTEB(3, 0, 3, 0),
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                        // color: const Color.fromARGB(255, 219, 48, 48),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                            width: 1,
                                            color: const Color.fromARGB(
                                                255, 192, 192, 192))),
                                    child: GetBuilder<EducationsController>(
                                        init: EducationsController(
                                            Get.find()),
                                        builder: (educationController) {
                                          return CustomDropdownV2<
                                              EducationModel?>(
                                            leadingIcon: true,
                                            onChange: (int index) =>
                                                accountController
                                                    .setSelectedEducation(
                                                        educationController
                                                                .educations[
                                                            index]),
                                            dropdownButtonStyle: DropdownButtonStyle(
                                                width: double.infinity,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(200)),
                                                height: 50,
                                                elevation: 0,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                primaryColor:
                                                    const Color.fromARGB(
                                                        221, 205, 205, 205),
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween),
                                            dropdownStyle: DropdownStyle(
                                                // width: 340,
                                                color: WHITE_COLOR,
                                                elevation: 0,
                                                padding: EdgeInsets.all(0),
                                                shape:
                                                    RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color:
                                                              Colors.grey,
                                                          width: 0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    8))),
                                            items: educationController
                                                .educations
                                                .asMap()
                                                .entries
                                                .map(
                                                  (item) => DropdownItem<
                                                      EducationModel?>(
                                                    value: item.value,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                      child: Text(
                                                          item.value.name!),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            child: Text(accountController
                                                        .selectedEducation
                                                        .id !=
                                                    null
                                                ? accountController
                                                    .selectedEducation.name!
                                                : "Education Level".tr),
                                          );
                                        }),
                                  )),
                            ),
                            const SizedBox(height: 16),
// Jobs
                            Container(
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  3, 0, 3, 0),
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  3, 0, 3, 0),
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
                                      dropdownButtonStyle:
                                          DropdownButtonStyle(
                                              width: double.infinity,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(200)),
                                              height: 50,
                                              elevation: 0,
                                              backgroundColor:
                                                  const Color
                                                      .fromARGB(255, 255,
                                                      255, 255),
                                              primaryColor:
                                                  const Color.fromARGB(221,
                                                      205, 205, 205),
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween),
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
                                                  BorderRadius.circular(
                                                      8))),
                                      items: jobsController.jobs
                                          .asMap()
                                          .entries
                                          .map(
                                            (item) =>
                                                DropdownItem<JobModel?>(
                                              value: item.value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(
                                                        8.0),
                                                child:
                                                    Text(item.value.name!),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      child: Text(accountController
                                                  .selectedJob.id !=
                                              null
                                          ? accountController
                                              .selectedJob.name!
                                          : "Job Status".tr),
                                    );
                                  }),
                            ),
                            const SizedBox(height: 15),
//MaritalStatus
                            Container(
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  3, 0, 3, 0),
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10, 0, 3, 0),
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
                                      onChange: (int index) =>
                                          accountController
                                              .setSelectedMaritalStatus(
                                                  maritalStatusController
                                                          .maritalStatus[
                                                      index]),
                                      dropdownButtonStyle:
                                          DropdownButtonStyle(
                                              width: double.infinity,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(200)),
                                              height: 50,
                                              elevation: 0,
                                              backgroundColor:
                                                  const Color
                                                      .fromARGB(255, 255,
                                                      255, 255),
                                              primaryColor:
                                                  const Color.fromARGB(221,
                                                      205, 205, 205),
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween),
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
                                                  BorderRadius.circular(
                                                      8))),
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
                                                    const EdgeInsets.all(
                                                        8.0),
                                                child:
                                                    Text(item.value.name!),
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
                                                  .selectedMaritalStatus
                                                  .name!
                                              : "Marital Status".tr)
                                        ],
                                      ),
                                    );
                                  }),
                            ),

// Languages
                            SizedBox(
                              child: Container(
                                // height: 50,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    3, 15, 3, 10),
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 0),
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
                                          decoration:
                                              CustomDropdownDecoration(),
                                          hintText: 'Languages'.tr,
                                          items: languageController
                                              .languages
                                              .toList(),
                                          initialItems: languageController
                                              .languages
                                              .where((lang) =>
                                                  accountController
                                                      .languages!
                                                      .contains(lang.id))
                                              .toList(),
                                          onListChanged: (value) {
                                            // accountController.setSelectedLanguages(value);
                                            print(value);
                                            print(
                                                'SimpleDropdown onChanged value: $value');
                                          },
                                        ),
                                      );
                                    }),
                              ),
                            ),

                            // Exist Before But Commented
                            // const SizedBox(height: 20),
                            // _buildAnimatedField(
                            //   delay: 4,
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 10),
                            //     child: Directionality(
                            //       textDirection: TextDirection.rtl,
                            //       child: IntlPhoneField(
                            //         languageCode: "ar",
                            //         textAlign: TextAlign.right,
                            //         textAlignVertical: TextAlignVertical.center,
                            //         disableAutoFillHints: true,
                            //         dropdownIconPosition: IconPosition.trailing,
                            //         searchText: "Search Country".tr,
                            //         decoration: InputDecoration(
                            //           suffixIcon: Icon(
                            //             Icons.phone_rounded,
                            //             color: Colors.blue.shade600,
                            //           ),
                            //           contentPadding: EdgeInsets.symmetric(horizontal: 15),
                            //           labelText: "Phone Number".tr,
                            //           hintText: ''.tr,
                            //           alignLabelWithHint: true,
                            //           floatingLabelAlignment: FloatingLabelAlignment.start,
                            //           border: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(12),
                            //             borderSide: BorderSide(color: Colors.grey.shade300),
                            //           ),
                            //           enabledBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(12),
                            //             borderSide: BorderSide(color: Colors.grey.shade300),
                            //           ),
                            //           focusedBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(12),
                            //             borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                            //           ),
                            //         ),
                            //         initialCountryCode: 'SA',
                            //         onChanged: (phone) => accountController.phone = phone.completeNumber,
                            //         onCountryChanged: (country) {
                            //           accountController.selectedCountryCode(country.code);
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            SizedBox(height: 15),

                            EasyAppTextFormField(
                              onSave: (value) =>
                                  accountController.ibanNumber = value!,
                              labelText: "Iban Number".tr,
                              hintText: "",
                              prefixIcon: Icon(
                                Icons.add_card_rounded,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              onValidate: (value) {
                                if (value?.isEmpty == true) {
                                  return "Iban Number Required!".tr;
                                }
                                
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Obx(() => nationalitiesController.isLoading
                                ? CircularProgressIndicator()
                                : ProDropdown<NationalityModel>(
                                    selectedValue:
                                        accountController.selectedNationality,
                                    hint: 'Select your nationality'.tr,
                                    searchHint: 'Search nationalities...'.tr,
                                    onChanged: (value) => accountController
                                        .setSelectedNationality(value!),
                                    // onChanged: (value) {
                                    //   setState(() {
                                    //     selectedNationality = value;
                                    //   });
                                    //   print(
                                    //       'Selected: ${value?.name} (ID: ${value?.id})');
                                    // },
                                    items: nationalitiesController
                                        .nationalityItems)),

                            SizedBox(height: 20),
                            Obx(() => regionsController.isLoading
                                ? CircularProgressIndicator()
                                : ProDropdown<RegionModel>(
                                    selectedValue:
                                        accountController.selectedRegion,
                                    hint: 'Select your region'.tr,
                                    searchHint: 'Search regions...'.tr,
                                    onChanged: (region) => accountController
                                        .setSelectedRegion(region!),
                                    // onChanged: (value) {
                                    //   // setState(() {
                                    //   //   selectedNationality = value;
                                    //   // });
                                    //   print(
                                    //       'Selected: ${value?.name} (ID: ${value?.id})');
                                    // },
                                    items: regionsController.regionsItems)),

                            const SizedBox(height: 16),
                            Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Day and Year Row
                                          Row(
                                            children: [
                                              // Day Dropdown
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton<int>(
                                                      isExpanded: true,
                                                      hint: Text(
                                                        'Day'.tr,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      value: accountController
                                                          .selectedDay,
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down),
                                                      items: accountController
                                                          .getDaysInMonth()
                                                          .map((day) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: day,
                                                          child: Text('$day'),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          accountController
                                                                  .selectedDay =
                                                              value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),

                                              Expanded(
                                                  child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<int>(
                                                    isExpanded: true,
                                                    hint: Text(
                                                      'Month'.tr,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    value: accountController
                                                        .selectedMonth,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    items: List.generate(12,
                                                        (index) {
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: index + 1,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                accountController
                                                                    .months[
                                                                        index]
                                                                    .tr),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        accountController
                                                                .selectedMonth =
                                                            value;
                                                        // Reset day if it's invalid for new month
                                                        if (accountController
                                                                    .selectedDay !=
                                                                null &&
                                                            accountController
                                                                    .selectedYear !=
                                                                null) {
                                                          final daysInMonth =
                                                              accountController
                                                                  .getDaysInMonth();
                                                          if (!daysInMonth.contains(
                                                              accountController
                                                                  .selectedDay)) {
                                                            accountController
                                                                    .selectedDay =
                                                                null;
                                                          }
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              )),

                                              const SizedBox(width: 16),

                                              // Year Dropdown
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton<int>(
                                                      isExpanded: true,
                                                      hint: Text(
                                                        'Year'.tr,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      value: accountController
                                                          .selectedYear,
                                                      icon: const Icon(Icons
                                                          .arrow_drop_down),
                                                      items: accountController
                                                          .getYears()
                                                          .map((year) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: year,
                                                          child: Text('$year'),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          accountController
                                                                  .selectedYear =
                                                              value;
                                                          // Reset day if it's invalid for new year
                                                          if (accountController
                                                                      .selectedDay !=
                                                                  null &&
                                                              accountController
                                                                      .selectedMonth !=
                                                                  null) {
                                                            final daysInMonth =
                                                                accountController
                                                                    .getDaysInMonth();
                                                            if (!daysInMonth.contains(
                                                                accountController
                                                                    .selectedDay)) {
                                                              accountController
                                                                      .selectedDay =
                                                                  null;
                                                            }
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]))),

                            const SizedBox(height: 16),

                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 0, 10, 0),
                              child: EasyAppTextFormField(
                                onSave: (value) =>
                                    accountController.bankAccountName = value!,
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

                            // Exist Before But Commented
                            // const SizedBox(height: 25),
                            // _buildModernGenderSelector(accountController),

                            const SizedBox(height: 25),
                            _buildAnimatedField(
                              delay: 7,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: EasyAppTextFormField(
                                  enable: false,
                                  required: false,
                                  multiline: 3,
                                  onSave: (value) =>
                                      accountController.experts = value!,
                                  labelText: "Experts".tr,
                                  hintText: "",
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            _buildAnimatedField(
                              delay: 8,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: EasyAppTextFormField(
                                  required: false,
                                  textInputType: TextInputType.number,
                                  onSave: (value) =>
                                      accountController.previousEvents = value!,
                                  labelText: "Previous Events Past".tr,
                                  hintText: "",
                                  // onValidate: (value) {
                                  //   if (value?.length == 0) {
                                  //     return "Previous Events Past Required!".tr;
                                  //   }
                                  //   return null;
                                  // },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            _buildAnimatedField(
                              delay: 9,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: EasyAppTextFormField(
                                  required: false,
                                  multiline: 3,
                                  onSave: (value) => accountController
                                      .chronicDiseases = value!,
                                  labelText: "Chronic diseases".tr,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),
                            _buildAnimatedField(
                              delay: 8,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // border: Border.all(width: 1, color:accountController.ibanFilePath =='' ? RED_COLOR: Colors.transparent),
                                          // borderRadius: BorderRadius.circular(16)
                                          ),
                                      child: Column(
                                        children: [
                                          _buildModernFileUpload(
                                            "إرفاق مستند الايبان",
                                            accountController.ibanFilePath == ''
                                                ? Icon(
                                                    Icons
                                                        .picture_as_pdf_rounded,
                                                    size: 20,
                                                    color: SAGR_SECONDARY,
                                                  )
                                                : Container(),
                                            () => accountController
                                                .handleFileSelectionForIban(),
                                            8,
                                          ),
                                          accountController.ibanFilePath != ''
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                      "Iban Uploaded".tr,
                                                      style: TextStyle(
                                                          color: WHITE_COLOR),
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.star_border,
                                                      color: RED_COLOR,
                                                      size: 12,
                                                    ),
                                                    Text(
                                                      "Iban File Required".tr,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildModernFileUpload(
                                          "إرفاق السيرة الذاتية",
                                          accountController.ibanFilePath == ''
                                              ? Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  size: 20,
                                                  color: SAGR_SECONDARY)
                                              : Container(),
                                          () => accountController
                                              .handleFileSelection(),
                                          9,
                                        ),
                                        accountController.ibanFilePath != ''
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  ),
                                                  Text("Cv File Uploaded".tr)
                                                ],
                                              )
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.star_border,
                                                    color: RED_COLOR,
                                                    size: 12,
                                                  ),
                                                  Text(
                                                    "Iban File Required".tr,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),
                            _buildModernImageUpload(accountController),

                            accountController.profileImageRequired == true
                                ? Text("a s")
                                : SizedBox(),

                            const SizedBox(height: 30),
                            _buildAnimatedCheckbox(accountController),

                            if (accountController.agreeErrorMessage)
                              _buildAnimatedField(
                                delay: 12,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Please, agree on terms of Use & Privacy Policy."
                                        .tr,
                                    style: TextStyle(
                                      color: Colors.red.shade600,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 35),
                            _buildAnimatedField(
                              delay: 13,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: accountController.isLoading
                                        ? null
                                        : () {
                                            _formKey.currentState!.save();
                                            if (_formKey.currentState!
                                                .validate()) {
                                              accountController
                                                  .completeAccount();
                                            }
                                          },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: accountController.isLoading
                                            ? LinearGradient(
                                                colors: [
                                                  Colors.grey.shade400,
                                                  Colors.grey.shade500
                                                ],
                                              )
                                            : LinearGradient(
                                                colors: [
                                                  SAGR_PRIMARY,
                                                  SAGR_PRIMARY
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                SAGR_PRIMARY.withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (accountController.isLoading)
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                          Text(
                                            accountController.isLoading
                                                ? "Creating Account...".tr
                                                : "Create Account".tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // const SizedBox(height: 30),
                            // _buildAnimatedField(
                            //   delay: 14,
                            //   child: GestureDetector(
                            //     onTap: () => Get.toNamed('/login'),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text(
                            //           "Already have an account?".tr,
                            //           style: TextStyle(
                            //             fontSize: 16,
                            //             color: Colors.grey[600],
                            //           ),
                            //         ),
                            //         const SizedBox(width: 8),
                            //         Text(
                            //           "Login".tr,
                            //           style: TextStyle(
                            //             fontSize: 16,
                            //             color: Colors.blue.shade700,
                            //             fontWeight: FontWeight.bold,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Professional dropdown widget supporting single/multi-select with filtering
class ProDropdown<T> extends StatefulWidget {
  final List<ProDropdownOption<T>> items;
  final List<T>? selectedValues;
  final T? selectedValue;
  final bool multiSelect;
  final String? hint;
  final String? searchHint;
  final Function(List<T>)? onMultiChanged;
  final Function(T?)? onChanged;
  final bool showSearch;
  final double maxHeight;
  final String Function(T)? itemLabelBuilder;
  final Widget Function(T)? itemBuilder;
  final InputDecoration? decoration;
  final bool enabled;

  const ProDropdown({
    Key? key,
    required this.items,
    this.selectedValues,
    this.selectedValue,
    this.multiSelect = false,
    this.hint,
    this.searchHint,
    this.onMultiChanged,
    this.onChanged,
    this.showSearch = true,
    this.maxHeight = 300,
    this.itemLabelBuilder,
    this.itemBuilder,
    this.decoration,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<ProDropdown<T>> createState() => _ProDropdownState<T>();
}

class _ProDropdownState<T> extends State<ProDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<ProDropdownOption<T>> _filteredItems = [];
  List<T> _tempSelectedValues = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _tempSelectedValues = widget.selectedValues ?? [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;

    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: _buildDropdownList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.clear();
    _filteredItems = widget.items;
  }

  Widget _buildDropdownList() {
    return Container(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSearch) _buildSearchField(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = widget.multiSelect
                    ? _tempSelectedValues.contains(item.value)
                    : widget.selectedValue == item.value;

                return InkWell(
                  onTap: () => _handleItemTap(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.blue.shade50 : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        if (widget.multiSelect)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              isSelected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade400,
                              size: 20,
                            ),
                          ),
                        Expanded(
                          child: widget.itemBuilder != null
                              ? widget.itemBuilder!(item.value)
                              : Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.blue.shade700
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.multiSelect) _buildMultiSelectActions(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.searchHint ?? 'Search...',
          prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade600),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _filterItems('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          isDense: true,
        ),
        onChanged: _filterItems,
      ),
    );
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) =>
                item.label.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _handleItemTap(ProDropdownOption<T> item) {
    if (widget.multiSelect) {
      setState(() {
        if (_tempSelectedValues.contains(item.value)) {
          _tempSelectedValues.remove(item.value);
        } else {
          _tempSelectedValues.add(item.value);
        }
      });
      _overlayEntry?.markNeedsBuild();
    } else {
      widget.onChanged?.call(item.value);
      _removeOverlay();
      setState(() {});
    }
  }

  Widget _buildMultiSelectActions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _tempSelectedValues.clear();
              });
              _overlayEntry?.markNeedsBuild();
            },
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onMultiChanged?.call(_tempSelectedValues);
              _removeOverlay();
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  String _getDisplayText() {
    if (widget.multiSelect) {
      if (_tempSelectedValues.isEmpty) {
        return widget.hint ?? 'Select items';
      }
      return '${_tempSelectedValues.length} selected';
    } else {
      if (widget.selectedValue == null) {
        return widget.hint ?? 'Select an item';
      }
      final item = widget.items.firstWhere(
        (item) => item.value == widget.selectedValue,
        orElse: () => ProDropdownOption(
            value: widget.selectedValue as T, label: widget.hint!),
      );
      return item.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InputDecorator(
        decoration: widget.decoration ??
            InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
        child: InkWell(
          onTap: _toggleDropdown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _getDisplayText(),
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.enabled ? Colors.black87 : Colors.grey,
                  ),
                ),
              ),
              Icon(
                _overlayEntry == null
                    ? Icons.arrow_drop_down
                    : Icons.arrow_drop_up,
                color: widget.enabled ? Colors.grey.shade700 : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Model for dropdown options
class ProDropdownOption<T> {
  final T value;
  final String label;

  ProDropdownOption({required this.value, required this.label});
}
