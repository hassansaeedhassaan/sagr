import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sagr/features/auth/presentation/controllers/create_account_controller.dart';
import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../../../view/widgets/Forms/easy_app_password_form_field.dart';
import '../../../../widgets/phone_number_input.dart';
import '/../core/utils/size_utils.dart';


class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with TickerProviderStateMixin {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
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

  Widget _buildModernGenderSelector(CreateAccountController accountController) {
    return _buildAnimatedField(
      delay: 6,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: BoxDecoration(
          // color: Colors.white,
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
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
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
    IconData icon,
    VoidCallback onTap,
    int delay,
  ) {
    return _buildAnimatedField(
      delay: delay,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(25),
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
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      icon,
                      size: 30,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
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
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
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
              child: Column(
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
                            colors: [Colors.green.shade400, Colors.green.shade600],
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
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.person_add_rounded,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Create Account".tr,
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
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: EasyAppTextFormField(
                                  onSave: (value) => accountController.firstName = value!,
                                  labelText: "Full Name".tr,
                                  hintText: "",
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: Colors.blue.shade600,
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
                             Container(
                              child: _buildAnimatedField(
                              delay: 4,
                              child:SizedBox(
                                height: 50,
                                child: PhoneNumberInput(
                                  isRTL: true, // or false for LTR
                                  initialCountryCode: '+966', // Egypt
                                  hintText: 'رقم الجوال', // or 'Phone number'
                                  onChanged: (phone, code) => accountController.phone = phone,
                                  onCountryChanged: (code, name, flag, iso) {

                                    accountController.selectedCountryCode(code);
                                    // Called when country changes
                                    print('Country changed to: $name ($code)');
                                    // You can update your UI, save to database, etc.
                                  },
                                ),
                              )),
                             ),
                            // const SizedBox(height: 20),
                            // _buildAnimatedField(
                            //   delay: 4,
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 10),
                            //     child: Directionality(
                            //       textDirection: TextDirection.ltr,
                            //       child: IntlPhoneField(
                            //         languageCode: "en",
                            //         textAlign: TextAlign.left,
                            //         textAlignVertical: TextAlignVertical.center,
                            //         disableAutoFillHints: true,
                                    
                            //         // dropdownIconPosition: IconPosition.trailing,
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


                            // const SizedBox(height: 20),
                            // _buildAnimatedField(
                            //   delay: 5,
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 0),
                            //     child: EasyAppTextFormField(
                            //       onSave: (value) => accountController.nationalNo = value!,
                            //       labelText: "National Number".tr,
                            //       hintText: "",
                            //       prefixIcon: Icon(
                            //         Icons.badge_outlined,
                            //         color: Colors.blue.shade600,
                            //       ),
                            //       onValidate: (value) {
                            //         if (value?.length == 0) {
                            //           return "National Number Required!".tr;
                            //         }
                            //         return null;
                            //       },
                            //     ),
                            //   ),
                            // ),

                            const SizedBox(height: 25),
                            _buildModernGenderSelector(accountController),

                            // const SizedBox(height: 25),
                            // _buildAnimatedField(
                            //   delay: 7,
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 10),
                            //     child: EasyAppTextFormField(
                            //       enable: false,
                            //       required: false,
                            //       multiline: 3,
                            //       onSave: (value) => accountController.experts = value!,
                            //       labelText: "Experts".tr,
                            //       hintText: "",
                            //     ),
                            //   ),
                            // ),

                            // const SizedBox(height: 20),
                            // _buildAnimatedField(
                            //   delay: 8,
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 10),
                            //     child: EasyAppTextFormField(
                            //       required: false,
                            //       textInputType: TextInputType.number,
                            //       onSave: (value) => accountController.previousEvents = value!,
                            //       labelText: "Previous Events Past".tr,
                            //       hintText: "",
                            //       onValidate: (value) {
                            //         if (value?.length == 0) {
                            //           return "Previous Events Past Required!".tr;
                            //         }
                            //         return null;
                            //       },
                            //     ),
                            //   ),
                            // ),

                            // const SizedBox(height: 20),
                            // _buildAnimatedField(
                            //   delay: 9,
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 10),
                            //     child: EasyAppTextFormField(
                            //       required: false,
                            //       multiline: 3,
                            //       onSave: (value) => accountController.chronicDiseases = value!,
                            //       labelText: "Chronic diseases".tr,
                            //     ),
                            //   ),
                            // ),

                            const SizedBox(height: 25),
                            _buildAnimatedField(
                              delay: 10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: EasyAppPasswordFormField(
                                  onSave: (value) => accountController.password = value!,
                                  labelText: "Password",
                                  hintText: "",
                                  onValidate: (value) {
                                    if (value?.length == 0) {
                                      return "Password Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            _buildAnimatedField(
                              delay: 11,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: EasyAppPasswordFormField(
                                  onSave: (value) => accountController.confirmationPassword = value!,
                                  labelText: "Confirm Password",
                                  hintText: "",
                                  onValidate: (value) {
                                    if (value?.length == 0) {
                                      return "Confirm Password Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            // const SizedBox(height: 30),
                            // _buildAnimatedField(
                            //   delay: 8,
                            //   child: Row(
                            //     children: [
                            //       Expanded(
                            //         child: _buildModernFileUpload(
                            //           "إرفاق مستند الايبان",
                            //           Icons.picture_as_pdf_rounded,
                            //           () => accountController.handleFileSelectionForIban(),
                            //           8,
                            //         ),
                            //       ),
                            //       const SizedBox(width: 15),
                            //       Expanded(
                            //         child: _buildModernFileUpload(
                            //           "إرفاق السيرة الذاتية",
                            //           Icons.description_rounded,
                            //           () => accountController.handleFileSelection(),
                            //           9,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            // const SizedBox(height: 25),
                            // _buildModernImageUpload(accountController),

                            const SizedBox(height: 30),
                            _buildAnimatedCheckbox(accountController),

                            if (accountController.agree_error_message)
                              _buildAnimatedField(
                                delay: 12,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Please, agree on terms of Use & Privacy Policy.",
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
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: accountController.isLoading
                                        ? null
                                        : () {
                                            _formKey.currentState!.save();
                                            if (_formKey.currentState!.validate()) {
                                              accountController.register();
                                            }
                                          },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(
                                        gradient: accountController.isLoading
                                            ? LinearGradient(
                                                colors: [Colors.grey.shade400, Colors.grey.shade500],
                                              )
                                            : LinearGradient(
                                                colors: [Colors.blue.shade500, Colors.blue.shade700],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.3),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (accountController.isLoading)
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                          if (accountController.isLoading)
                                            const SizedBox(width: 15),
                                          Text(
                                            accountController.isLoading
                                                ? "Creating Account..."
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

                            const SizedBox(height: 30),
                            _buildAnimatedField(
                              delay: 14,
                              child: GestureDetector(
                                onTap: () => Get.toNamed('/login'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Login".tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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