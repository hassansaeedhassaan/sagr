import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/Common/custom_dropdown.dart';
import '/../core/utils/size_utils.dart';

class UpdateAccountScreen extends StatefulWidget {
  UpdateAccountScreen({Key? key}) : super(key: key);

  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen>
    with TickerProviderStateMixin {
  
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CreateAccountController _accountController = Get.put(CreateAccountController(Get.find()));

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  final storage = GetStorage();
  Map<String, dynamic>? userData;
  bool isLoadingData = true;

  @override
  void initState() {
    super.initState();
    
    // Load stored user data
    _loadUserData();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.05),
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
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }


 List<LanguageModel> selectedLanguages = [];
  List<LanguageModel> availableLanguages = [
    LanguageModel(id: 1, name: 'English', code: 'en'),
    LanguageModel(id: 2, name: 'Spanish', code: 'es'),
    LanguageModel(id: 3, name: 'French', code: 'fr'),
    LanguageModel(id: 4, name: 'German', code: 'de'),
    LanguageModel(id: 5, name: 'Italian', code: 'it'),
    LanguageModel(id: 6, name: 'Portuguese', code: 'pt'),
    LanguageModel(id: 7, name: 'Japanese', code: 'ja'),
    LanguageModel(id: 8, name: 'Korean', code: 'ko'),
    LanguageModel(id: 9, name: 'Chinese', code: 'zh'),
    LanguageModel(id: 10, name: 'Arabic', code: 'ar'),
  ];

  void _loadUserData() async {
    setState(() {
      isLoadingData = true;
    });
    
    try {
      await Future.delayed(Duration(milliseconds: 500)); // Small delay for smooth transition
      userData = storage.read('userData');



      
      if (userData != null) {

        print("😋");
      print(userData!['ibanNo']);
      print("😋");

        // Pre-populate controller with stored data
        _accountController.firstName = userData!['firstName'] ?? '';
        _accountController.middleName = userData!['middleName'] ?? '';
        _accountController.lastName = userData!['lastName'] ?? '';
        _accountController.nationalNo = userData!['nationalID'] ?? '';
        _accountController.ibanNumber = userData!['ibanNo'] ?? '';
        _accountController.bankAccountName = userData!['bankAccountName'] ?? '';
        _accountController.experts = userData!['experts'] ?? '';
        _accountController.previousEvents = userData!['previous_events_past'] ?? '';
        _accountController.chronicDiseases = userData!['chronic_diseases'] ?? '';
        _accountController.setGender(userData!['gender'] ?? 'male');
        
        // Handle dropdown selections
        if (userData!['selectedEducation'] != null) {
          // Set education if stored
          var educationData = userData!['selectedEducation'];
          // _accountController.selectedEducation = EducationModel(
          //   id: educationData['id'],
          //   name: educationData['name'],
          // );
        }
        
        if (userData!['job'] != null) {
          // Set job if stored
          var jobData = userData!['selectedJob'];
          // _accountController = JobModel(
          //   id: jobData['id'],
          //   name: jobData['name'],
          // );
        }
        
        if (userData!['selectedMaritalStatus'] != null) {
          // Set marital status if stored
          var maritalStatusData = userData!['selectedMaritalStatus'];
          _accountController.setSelectedMaritalStatus(maritalStatusData);
        }
        
        if (userData!['languages'] != null) {

          

          // Set languages if stored
          // _accountController.languages = List<int>.from(userData!['languages']);
        }

        



        
        print('Loaded user data: $userData');
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        isLoadingData = false;
      });
    }
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _fadeController.forward();
    _slideController.forward();
  }

  void _saveUpdatedData() {
    try {
      // Update the userData map with new values
      Map<String, dynamic> updatedData = {
        'firstName': _accountController.firstName,
        'middleName': _accountController.middleName,
        'lastName': _accountController.lastName,
        'nationalNo': _accountController.nationalNo,
        'ibanNumber': _accountController.ibanNumber,
        'bankAccountName': _accountController.bankAccountName,
        'experts': _accountController.experts,
        'previousEvents': _accountController.previousEvents,
        'chronicDiseases': _accountController.chronicDiseases,
        'gender': _accountController.gender,
        'selectedEducation': _accountController.selectedEducation.id != null ? {
          'id': _accountController.selectedEducation.id,
          'name': _accountController.selectedEducation.name,
        } : null,
        'selectedJob': _accountController.selectedJob.id != null ? {
          'id': _accountController.selectedJob.id,
          'name': _accountController.selectedJob.name,
        } : null,
        'selectedMaritalStatus': _accountController.selectedMaritalStatus.id != null ? {
          'id': _accountController.selectedMaritalStatus.id,
          'name': _accountController.selectedMaritalStatus.name,
        } : null,
        'languages': _accountController.languages,
      };
      
      // Save updated data to storage
      storage.write('userData', updatedData);
      print('Updated user data saved: $updatedData');
      
      // Show success message
      Get.snackbar(
        'نجح التحديث',
        'تم تحديث بياناتك بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
    } catch (e) {
      print('Error saving updated data: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حفظ البيانات',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedField({
    required Widget child,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (delay * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 15 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildGenderSelector(CreateAccountController accountController) {
    return _buildSectionCard(
      children: [
        Row(
          children: [
            Icon(Icons.person_outline, color: Colors.blue.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              "النوع",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(accountController, 'male', 'ذكر', Icons.male),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderOption(accountController, 'female', 'انثي', Icons.female),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    CreateAccountController accountController,
    String gender,
    String label,
    IconData icon,
  ) {
    final isSelected = accountController.gender == gender;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => accountController.setGender(gender),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  )
                : null,
            color: isSelected ? null : Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadRow(CreateAccountController accountController) {
    return _buildSectionCard(
      children: [
        Row(
          children: [
            Icon(Icons.attach_file, color: Colors.blue.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              "المرفقات",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFileUploadButton(
                "إرفاق مستند الايبان",
                Icons.picture_as_pdf,
                () => accountController.handleFileSelectionForIban(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFileUploadButton(
                "إرفاق السيرة الذاتية",
                Icons.description,
                () => accountController.handleFileSelection(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFileUploadButton(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.blue.shade600, size: 24),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUpload(CreateAccountController accountController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => accountController.pickImage(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade200, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 12),
                Text(
                  "تحديث الصورة الشخصية",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "تحديث الحساب",
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700]),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<CreateAccountController>(
        init: CreateAccountController(Get.find()),
        builder: (CreateAccountController accountController) {
          // Show loading indicator while data is loading
          if (isLoadingData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'جاري تحميل البيانات...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        
                        // Personal Information
                        _buildAnimatedField(
                          delay: 0,
                          child: _buildSectionCard(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['firstName'] ?? '',
                                  onSave: (value) => accountController.firstName = value!,
                                  labelText: "First Name".tr,
                                  hintText: "",
                                  prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade600),
                                  onValidate: (value) {
                                    if (value?.isEmpty == true) {
                                      return "First Name Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['middleName'] ?? '',
                                  onSave: (value) => accountController.middleName = value!,
                                  labelText: "Middle Name".tr,
                                  hintText: "",
                                  prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade600),
                                  onValidate: (value) {
                                    if (value?.isEmpty == true) {
                                      return "Middle Name Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['lastName'] ?? '',
                                  onSave: (value) => accountController.lastName = value!,
                                  labelText: "Family Name".tr,
                                  hintText: "",
                                  prefixIcon: Icon(Icons.person_outline, color: Colors.blue.shade600),
                                  onValidate: (value) {
                                    if (value?.isEmpty == true) {
                                      return "Family Name Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Contact Information
                        _buildAnimatedField(
                          delay: 1,
                          child: _buildSectionCard(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['nationalID'] ?? '',
                                  onSave: (value) => accountController.nationalNo = value!,
                                  labelText: "National Number".tr,
                                  hintText: "",
                                  prefixIcon: Icon(Icons.badge_outlined, color: Colors.blue.shade600),
                                  onValidate: (value) {
                                    if (value?.isEmpty == true) {
                                      return "National Number Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['ibanNo'] ?? '',
                                  onSave: (value) => accountController.ibanNumber = value!,
                                  labelText: "Iban Number".tr,
                                  hintText: "",
                                  prefixIcon: Icon(Icons.credit_card, color: Colors.blue.shade600),
                                  onValidate: (value) {
                                    if (value?.isEmpty == true) {
                                      return "Iban Number Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['bankAccountName'] ?? '',
                                  onSave: (value) => accountController.bankAccountName = value!,
                                  labelText: "Bank Account Name".tr,
                                  hintText: "",
                                  prefixIcon: Icon(Icons.account_balance, color: Colors.blue.shade600),
                                  onValidate: (value) {
                                    if (value?.isEmpty == true) {
                                      return "Bank Account Name Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Dropdowns Section
                        _buildAnimatedField(
                          delay: 2,
                          child: _buildSectionCard(
                            children: [
                              // Education Dropdown
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: GetBuilder<EducationsController>(
                                  init: EducationsController(Get.find()),
                                  builder: (educationController) {
                                    return CustomDropdownV2<EducationModel?>(
                                      leadingIcon: true,
                                      onChange: (int index) => accountController.setSelectedEducation(
                                          educationController.educations[index]),
                                      dropdownButtonStyle: DropdownButtonStyle(
                                        width: double.infinity,
                                        height: 50,
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        primaryColor: Colors.grey.shade400,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      ),
                                      dropdownStyle: DropdownStyle(
                                        color: WHITE_COLOR,
                                        elevation: 0,
                                        padding: EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.grey, width: 0),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: educationController.educations
                                          .asMap()
                                          .entries
                                          .map((item) => DropdownItem<EducationModel?>(
                                                value: item.value,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(item.value.name!),
                                                ),
                                              ))
                                          .toList(),
                                      child: Text(
                                        accountController.selectedEducation.id != null
                                            ? accountController.selectedEducation.name!
                                            : "Education Level".tr,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Job Dropdown
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: GetBuilder<JobsController>(
                                  init: JobsController(Get.find()),
                                  builder: (jobsController) {
                                    return CustomDropdownV2<JobModel?>(
                                      leadingIcon: true,
                                      onChange: (int index) => accountController.setSelectedJob(
                                          jobsController.jobs[index]),
                                      dropdownButtonStyle: DropdownButtonStyle(
                                        width: double.infinity,
                                        height: 50,
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        primaryColor: Colors.grey.shade400,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      ),
                                      dropdownStyle: DropdownStyle(
                                        color: WHITE_COLOR,
                                        elevation: 0,
                                        padding: EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.grey, width: 0),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: jobsController.jobs
                                          .asMap()
                                          .entries
                                          .map((item) => DropdownItem<JobModel?>(
                                                value: item.value,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(item.value.name!),
                                                ),
                                              ))
                                          .toList(),
                                      child: Text(
                                        accountController.selectedJob.id != null
                                            ? accountController.selectedJob.name!
                                            : "Job Status".tr,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Marital Status Dropdown
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: GetBuilder<MaritalStatusController>(
                                  init: MaritalStatusController(Get.find()),
                                  builder: (maritalStatusController) {
                                    return CustomDropdownV2<MaritalStatusModel?>(
                                      leadingIcon: true,
                                      onChange: (int index) => accountController.setSelectedMaritalStatus(
                                          maritalStatusController.maritalStatus[index]),
                                      dropdownButtonStyle: DropdownButtonStyle(
                                        width: double.infinity,
                                        height: 50,
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        primaryColor: Colors.grey.shade400,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      ),
                                      dropdownStyle: DropdownStyle(
                                        color: WHITE_COLOR,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.grey, width: 0),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: maritalStatusController.maritalStatus
                                          .asMap()
                                          .entries
                                          .map((item) => DropdownItem<MaritalStatusModel?>(
                                                value: item.value,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(item.value.name!),
                                                ),
                                              ))
                                          .toList(),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 2),
                                          Text(
                                            accountController.selectedMaritalStatus.id != null
                                                ? accountController.selectedMaritalStatus.name!
                                                : "Marital Status".tr,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 12),

            //                   MultiSelectDropdown<LanguageModel>(
            //   items: availableLanguages,
            //   selectedItems: selectedLanguages,
            //   onSelectionChanged: (List<LanguageModel> selected) {
            //     setState(() {
            //       selectedLanguages = selected;
            //     });
            //   },
            //   displayItem: (LanguageModel language) => language.name!,
            //   hintText: 'Choose languages...',
            // ),

            // if (selectedLanguages.isNotEmpty) ...[
            //   // Text(
            //   //   'Selected Languages:',
            //   //   style: TextStyle(
            //   //     fontSize: 16,
            //   //     fontWeight: FontWeight.w600,
            //   //     color: Colors.blueGrey[700],
            //   //   ),
            //   // ),
            //   SizedBox(height: 12),
            //   Wrap(
            //     spacing: 8,
            //     runSpacing: 8,
            //     children: selectedLanguages
            //         .map((language) => SelectedItemChip(
            //               label: language.name!,
            //               onDeleted: () {
            //                 setState(() {
            //                   selectedLanguages.remove(language);
            //                 });
            //               },
            //             ))
            //         .toList(),
            //   ),],
                              
                              // Languages Dropdown
                              // Container(
                              //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(8),
                              //     border: Border.all(color: Colors.grey.shade300),
                              //   ),
                              //   child: GetBuilder<LanguagesController>(
                              //     init: LanguagesController(Get.find()),
                              //     builder: (languageController) {
                              //       return SizedBox(
                              //         child: CustomDropdown<LanguageModel>.multiSelect(
                              //           decoration: CustomDropdownDecoration(
                              //             closedBorder: Border.all(color: Colors.transparent),
                              //             expandedBorder: Border.all(color: Colors.transparent),
                              //           ),
                              //           hintText: 'Languages',
                              //           items: languageController.languages.toList(),
                              //           initialItems: languageController.languages
                              //               .where((lang) => accountController.languages!.contains(lang.id))
                              //               .toList(),
                              //           onListChanged: (value) {
                              //             print(value);
                              //           },
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),



                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: GetBuilder<LanguagesController>(
                                  init: LanguagesController(Get.find()),
                                  builder: (languageController) {
                                    // Get selected languages based on userData
                                    List<LanguageModel> selectedLanguages = [];
                                    if (userData?['languages'] != null) {
                                      List<dynamic> storedLanguages = userData!['languages'];
                                      
                                      if (storedLanguages.isNotEmpty) {
                                        if (storedLanguages.first is Map) {
                                          // If languages are stored as objects with id and name
                                          List<int> languageIds = storedLanguages
                                              .map((lang) => lang['id'] as int)
                                              .toList();
                                          selectedLanguages = languageController.languages
                                              .where((lang) => languageIds.contains(lang.id))
                                              .toList();
                                        } else {
                                          // If languages are stored as just IDs
                                          List<int> languageIds = List<int>.from(storedLanguages);
                                          selectedLanguages = languageController.languages
                                              .where((lang) => languageIds.contains(lang.id))
                                              .toList();
                                        }
                                      }
                                    }
                                    
                                    return SizedBox(
                                      child: CustomDropdown<LanguageModel>.multiSelect(
                                        decoration: CustomDropdownDecoration(
                                          closedBorder: Border.all(color: Colors.transparent),
                                          expandedBorder: Border.all(color: Colors.transparent),
                                        ),
                                        hintText: 'Languages',
                                        items: languageController.languages.toList(),
                                        initialItems: selectedLanguages,
                                        onListChanged: (List<LanguageModel> selectedItems) {
                                          // Update controller with selected language IDs
                                          // accountController.languages = selectedItems.map((lang) => lang.id).toList();
                                          // print('Selected languages: ${selectedItems.map((lang) => lang.name).join(', ')}');
                                         
                                          // print('Selected language IDs: ${accountController.languages}');
                                        },
                                      ),
                                    );
                                  },
                                ))
                            ],
                          ),
                        ),

                        // Gender Selection
                        _buildAnimatedField(
                          delay: 3,
                          child: _buildGenderSelector(accountController),
                        ),

                        // Additional Information
                        _buildAnimatedField(
                          delay: 4,
                          child: _buildSectionCard(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['experts'] ?? '',
                                  enable: false,
                                  required: false,
                                  multiline: 3,
                                  onSave: (value) => accountController.experts = value!,
                                  labelText: "Experts".tr,
                                  hintText: "",
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['previousEvents'] ?? '',
                                  required: false,
                                  textInputType: TextInputType.number,
                                  onSave: (value) => accountController.previousEvents = value!,
                                  labelText: "Previous Events Past".tr,
                                  hintText: "",
                                  onValidate: (value) {
                                    if (value?.isEmpty == true) {
                                      return "Previous Events Past Required!".tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: EasyAppTextFormField(
                                  initialValue: userData?['chronicDiseases'] ?? '',
                                  required: false,
                                  multiline: 3,
                                  onSave: (value) => accountController.chronicDiseases = value!,
                                  labelText: "Chronic diseases".tr,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // File Upload Section
                        _buildAnimatedField(
                          delay: 5,
                          child: _buildFileUploadRow(accountController),
                        ),

                        // Image Upload
                        _buildAnimatedField(
                          delay: 6,
                          child: _buildImageUpload(accountController),
                        ),

                        // Update Button
                        _buildAnimatedField(
                          delay: 7,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(16),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: accountController.isLoading
                                    ? null
                                    : () {
                                        _formKey.currentState!.save();
                                        if (_formKey.currentState!.validate()) {
                                          _saveUpdatedData();
                                        }
                                      },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: accountController.isLoading
                                        ? LinearGradient(
                                            colors: [Colors.grey.shade400, Colors.grey.shade500],
                                          )
                                        : LinearGradient(
                                            colors: [Colors.blue.shade500, Colors.blue.shade700],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (accountController.isLoading)
                                        SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                      if (accountController.isLoading)
                                        const SizedBox(width: 12),
                                      Text(
                                        accountController.isLoading
                                            ? "جاري التحديث..."
                                            : "تحديث الحساب",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
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

                        const SizedBox(height: 20),
                      ],
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