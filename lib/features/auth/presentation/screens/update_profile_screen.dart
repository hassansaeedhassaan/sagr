import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';
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
import 'package:sagr/view/widgets/Forms/easy_app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../helper/base_url.dart';
import '../../../../widgets/Common/custom_dropdown.dart';
import '../../../../widgets/image_edit_preview.dart';
import '/../core/utils/size_utils.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CreateAccountController _accountController;
  final GetStorage _storage = GetStorage();
  
  Map<String, dynamic>? _userData;
  bool _isLoadingData = true;

  // Theme colors - centralized for consistency
  static const _primaryBlue = Color(0xFF2196F3);
  static const _accentBlue = Color(0xFF1976D2);
  static const _lightGrey = Color(0xFFF5F5F5);
  static const _borderGrey = Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _accountController = Get.put(CreateAccountController(Get.find()));
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final data = _storage.read('userData');
      
      if (data != null && mounted) {
        setState(() {
          _userData = Map<String, dynamic>.from(data);
          _populateControllerData();
          _isLoadingData = false;
        });
      } else {
        setState(() => _isLoadingData = false);
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  void _populateControllerData() {
    if (_userData == null) return;
    
    _accountController
      ..firstName = _userData!['firstName'] ?? ''
      ..middleName = _userData!['middleName'] ?? ''
      ..lastName = _userData!['lastName'] ?? ''
      ..nationalNo = _userData!['nationalID'] ?? ''
      ..ibanNumber = _userData!['ibanNumber'] ?? ''
      ..bankAccountName = _userData!['bankAccountName'] ?? ''
      ..experts = _userData!['experts'] ?? ''
      ..previousEvents = _userData!['previous_events_past'] ?? ''
      ..chronicDiseases = _userData!['chronic_diseases'] ?? ''

      ..setGender(_userData!['gender'] ?? 'male');

    // Set marital status if available
    if (_userData!['selectedMaritalStatus'] != null) {
      _accountController.setSelectedMaritalStatus(_userData!['selectedMaritalStatus']);
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightGrey,
      appBar: _buildAppBar(),
      body: _isLoadingData ? _buildLoadingIndicator() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700], size: 20),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoader.inline(color: _primaryBlue),
          const SizedBox(height: 16),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return GetBuilder<CreateAccountController>(
      init: _accountController,
      builder: (controller) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            children: [
              const SizedBox(height: 8),
              _buildPersonalInfoSection(controller),
              _buildBankingInfoSection(controller),
              _buildDropdownsSection(controller),
              _buildGenderSection(controller),
              _buildAdditionalInfoSection(controller),
              _buildFileUploadSection(controller),
              _buildImageUploadSection(controller),
              _buildUpdateButton(controller),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // MARK: - Personal Information Section
  Widget _buildPersonalInfoSection(CreateAccountController controller) {
    return _AnimatedSection(
      delay: 0,
      child: _SectionCard(
        children: [
          _buildTextField(
            initialValue: _userData?['firstName'] ?? '',
            onSave: (value) => controller.firstName = value!,
            labelText: "First Name".tr,
            icon: Icons.person_outline,
            validator: (value) => value?.isEmpty == true ? "First Name Required!".tr : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            initialValue: _userData?['middleName'] ?? '',
            onSave: (value) => controller.middleName = value!,
            labelText: "Middle Name".tr,
            icon: Icons.person_outline,
            validator: (value) => value?.isEmpty == true ? "Middle Name Required!".tr : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            initialValue: _userData?['lastName'] ?? '',
            onSave: (value) => controller.lastName = value!,
            labelText: "Family Name".tr,
            icon: Icons.person_outline,
            validator: (value) => value?.isEmpty == true ? "Family Name Required!".tr : null,
          ),
        ],
      ),
    );
  }

  // MARK: - Banking Information Section
  Widget _buildBankingInfoSection(CreateAccountController controller) {
    return _AnimatedSection(
      delay: 1,
      child: _SectionCard(
        children: [
          _buildTextField(
            initialValue: _userData?['ibanNo'] ?? '',
            onSave: (value) => controller.ibanNumber = value!,
            labelText: "Iban Number".tr,
            icon: Icons.credit_card,
            validator: (value) => value?.isEmpty == true ? "Iban Number Required!".tr : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            initialValue: _userData?['bankAccountName'] ?? '',
            onSave: (value) => controller.bankAccountName = value!,
            labelText: "Bank Account Name".tr,
            icon: Icons.account_balance,
            validator: (value) => value?.isEmpty == true ? "Bank Account Name Required!".tr : null,
          ),
        ],
      ),
    );
  }

  // MARK: - Dropdowns Section
  Widget _buildDropdownsSection(CreateAccountController controller) {
    return _AnimatedSection(
      delay: 2,
      child: _SectionCard(
        children: [
          _buildEducationDropdown(controller),
          const SizedBox(height: 12),
          _buildJobDropdown(controller),
          const SizedBox(height: 12),
          _buildMaritalStatusDropdown(controller),
          const SizedBox(height: 12),

          Text(controller.languages.toString()),
          _buildLanguagesDropdown(controller),
        ],
      ),
    );
  }

  Widget _buildEducationDropdown(CreateAccountController controller) {
    return GetBuilder<EducationsController>(
      init: EducationsController(Get.find()),
      builder: (educationController) {
        return _DropdownContainer(
          child: CustomDropdownV2<EducationModel?>(
            leadingIcon: true,
            onChange: (index) => controller.setSelectedEducation(
              educationController.educations[index],
            ),
            dropdownButtonStyle: _getDropdownButtonStyle(),
            dropdownStyle: _getDropdownStyle(),
            items: educationController.educations
                .map((item) => DropdownItem<EducationModel?>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.name!),
                      ),
                    ))
                .toList(),
            child: Text(
              controller.selectedEducation.id != null
                  ? controller.selectedEducation.name!
                  : "Education Level".tr,
            ),
          ),
        );
      },
    );
  }

  Widget _buildJobDropdown(CreateAccountController controller) {
    return GetBuilder<JobsController>(
      init: JobsController(Get.find()),
      builder: (jobsController) {
        return _DropdownContainer(
          child: CustomDropdownV2<JobModel?>(
            leadingIcon: true,
            onChange: (index) => controller.setSelectedJob(
              jobsController.jobs[index],
            ),
            dropdownButtonStyle: _getDropdownButtonStyle(),
            dropdownStyle: _getDropdownStyle(),
            items: jobsController.jobs
                .map((item) => DropdownItem<JobModel?>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.name!),
                      ),
                    ))
                .toList(),
            child: Text(
              controller.selectedJob.id != null
                  ? controller.selectedJob.name!
                  : "Job Status".tr,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaritalStatusDropdown(CreateAccountController controller) {
    return GetBuilder<MaritalStatusController>(
      init: MaritalStatusController(Get.find()),
      builder: (maritalStatusController) {
        return _DropdownContainer(
          child: CustomDropdownV2<MaritalStatusModel?>(
            leadingIcon: true,
            onChange: (index) => controller.setSelectedMaritalStatus(
              maritalStatusController.maritalStatus[index],
            ),
            dropdownButtonStyle: _getDropdownButtonStyle(),
            dropdownStyle: _getDropdownStyle(),
            items: maritalStatusController.maritalStatus
                .map((item) => DropdownItem<MaritalStatusModel?>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item.name!),
                      ),
                    ))
                .toList(),
            child: Text(
              controller.selectedMaritalStatus.id != null
                  ? controller.selectedMaritalStatus.name!
                  : "Marital Status".tr,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguagesDropdown(CreateAccountController controller) {
    return GetBuilder<LanguagesController>(
      init: LanguagesController(Get.find()),
      builder: (languageController) {
        final selectedLanguages = _getSelectedLanguages(languageController);
        
        return _DropdownContainer(
          child: CustomDropdown<LanguageModel>.multiSelect(
            decoration: CustomDropdownDecoration(
              closedBorder: Border.all(color: Colors.transparent),
              expandedBorder: Border.all(color: Colors.transparent),
            ),
            hintText: 'Languages',
            items: languageController.languages.toList(),
            initialItems: selectedLanguages,
            onListChanged: (selectedItems) {
              controller.setSelectedUpdatedLanguages(selectedItems);
            },
          ),
        );
      },
    );
  }

  List<LanguageModel> _getSelectedLanguages(LanguagesController controller) {
    if (_userData?['languages'] == null) return [];
    
    final storedLanguages = _userData!['languages'] as List<dynamic>;
    if (storedLanguages.isEmpty) return [];

    final languageIds = storedLanguages.first is Map
        ? storedLanguages.map((lang) => lang['id'] as int).toList()
        : List<int>.from(storedLanguages);

    return controller.languages
        .where((lang) => languageIds.contains(lang.id))
        .toList();
  }

  // MARK: - Gender Section
  Widget _buildGenderSection(CreateAccountController controller) {
    return _AnimatedSection(
      delay: 3,
      child: _SectionCard(
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: _primaryBlue, size: 20),
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
                child: _GenderOption(
                  controller: controller,
                  gender: 'male',
                  label: 'ذكر',
                  icon: Icons.male,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderOption(
                  controller: controller,
                  gender: 'female',
                  label: 'انثي',
                  icon: Icons.female,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MARK: - Additional Info Section
  Widget _buildAdditionalInfoSection(CreateAccountController controller) {
    return _AnimatedSection(
      delay: 4,
      child: _SectionCard(
        children: [
          _buildTextField(
            initialValue: _userData?['experts'] ?? '',
            onSave: (value) => controller.experts = value!,
            labelText: "Experts".tr,
            enabled: false,
            required: false,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            initialValue: _userData?['previous_events_past'] ?? '',
            onSave: (value) => controller.previousEvents = value!,
            labelText: "Previous Events Past".tr,
            required: false,
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty == true 
                ? "Previous Events Past Required!".tr 
                : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            initialValue: _userData?['chronic_diseases'] ?? '',
            onSave: (value) => controller.chronicDiseases = value!,
            labelText: "Chronic diseases".tr,
            required: false,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // MARK: - File Upload Section
  Widget _buildFileUploadSection(CreateAccountController controller) {
    return _AnimatedSection(
      delay: 5,
      child: _SectionCard(
        children: [
          Row(
            children: [
              Icon(Icons.attach_file, color: _primaryBlue, size: 20),
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
                child: _FileUploadColumn(
                  uploadText: "إرفاق مستند الايبان",
                  viewText: "عرض ملف الإيبان",
                  icon: Icons.picture_as_pdf,
                  onUpload: controller.handleFileSelectionForIban,
                  onView: () => _showPdfPreview(
                    '$HOSTURL${_userData?['iban_file']}',
                    'الإيبان',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FileUploadColumn(
                  uploadText: "إرفاق السيرة الذاتية",
                  viewText: "عرض السيرة الذاتية",
                  icon: Icons.description,
                  onUpload: controller.handleFileSelection,
                  onView: () => _showPdfPreview(
                    '$HOSTURL${_userData?['emp_cv']}',
                    "السيرة الذاتية",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // MARK: - Image Upload Section
  Widget _buildImageUploadSection(CreateAccountController controller) {
    return _AnimatedSection(
      delay: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ImageEditPreview(
          initialImageUrl: "$HOSTURL${_userData?['image']}",
          onImageSelected: controller.takenPhoto,
        ),
      ),
    );
  }

  // MARK: - Update Button
  Widget _buildUpdateButton(CreateAccountController controller) {
    return _AnimatedSection(
      delay: 7,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.isLoading ? null : _handleUpdate,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: controller.isLoading
                      ? [Colors.grey.shade400, Colors.grey.shade500]
                      : [_primaryBlue, _accentBlue],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryBlue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isLoading) ...[
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: AppLoader.inline(size: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    controller.isLoading ? "جاري التحديث..." : "تحديث الحساب",
                    style: const TextStyle(
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
    );
  }

  // MARK: - Helper Methods
  void _handleUpdate() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      _accountController.updateProfile();
    }
  }

  void _showPdfPreview(String url, String title) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PdfPreviewSheet(url: url, title: title),
    );
  }

  Widget _buildTextField({
    required String initialValue,
    required FormFieldSetter<String> onSave,
    required String labelText,
    IconData? icon,
    FormFieldValidator<String>? validator,
    bool enabled = true,
    bool required = true,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: EasyAppTextFormField(
        initialValue: initialValue,
        onSave: onSave,
        labelText: labelText,
        hintText: "",
        enable: enabled,
        required: required,
        multiline: maxLines,
        textInputType: keyboardType,
        prefixIcon: icon != null ? Icon(icon, color: _primaryBlue) : null,
        onValidate: validator,
      ),
    );
  }

  DropdownButtonStyle _getDropdownButtonStyle() {
    return DropdownButtonStyle(
      width: double.infinity,
      height: 50,
      elevation: 0,
      backgroundColor: Colors.white,
      primaryColor: Colors.grey.shade400,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  DropdownStyle _getDropdownStyle() {
    return DropdownStyle(
      color: WHITE_COLOR,
      elevation: 0,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 0),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

// MARK: - Reusable Widgets

class _AnimatedSection extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedSection({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (delay * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 15 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
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
      child: Column(children: children),
    );
  }
}

class _DropdownContainer extends StatelessWidget {
  final Widget child;

  const _DropdownContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}

class _GenderOption extends StatelessWidget {
  final CreateAccountController controller;
  final String gender;
  final String label;
  final IconData icon;

  const _GenderOption({
    required this.controller,
    required this.gender,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = controller.gender == gender;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.setGender(gender),
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
}

class _FileUploadColumn extends StatelessWidget {
  final String uploadText;
  final String viewText;
  final IconData icon;
  final VoidCallback onUpload;
  final VoidCallback onView;

  const _FileUploadColumn({
    required this.uploadText,
    required this.viewText,
    required this.icon,
    required this.onUpload,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onUpload,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Icon(icon, color: Colors.blue.shade600, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    uploadText,
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
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onView,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.picture_as_pdf, size: 18),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    viewText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PdfPreviewSheet extends StatelessWidget {
  final String url;
  final String title;

  const _PdfPreviewSheet({required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.description, color: Colors.blue.shade700),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SfPdfViewer.network(url),
            ),
          ),
        ],
    ));

  }}
