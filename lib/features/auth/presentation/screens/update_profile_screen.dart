import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/features/auth/presentation/controllers/create_account_controller.dart';
import 'package:sagr/features/auth/presentation/widgets/profile_form_kit.dart';
import 'package:sagr/features/education/data/models/education_model.dart';
import 'package:sagr/features/education/presentation/controllers/education_status_controller.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import 'package:sagr/features/jobs/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/features/language/data/models/language_model.dart';
import 'package:sagr/features/language/presentation/controllers/languages_controller.dart';
import 'package:sagr/features/marital_status/data/models/marital_status_model.dart';
import 'package:sagr/features/marital_status/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/features/nationalities/data/models/nationality_model.dart';
import 'package:sagr/features/nationalities/presentation/controllers/nationalities_controller.dart';
import 'package:sagr/features/regions/data/models/region_model.dart';
import 'package:sagr/features/regions/presentation/controllers/regions_controller.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

T _findOrPut<T>(T Function() create) =>
    Get.isRegistered<T>() ? Get.find<T>() : Get.put<T>(create());

/// Edit profile, built from the same pieces as [CompleteAccountScreen] so the
/// two read as one flow. One scrolling page rather than steps: people come
/// here to change a field or two, not to walk through everything again.
class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({super.key});

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _attempted = false;

  final c = _findOrPut<CreateAccountController>(
      () => CreateAccountController(Get.find()));
  final _educations =
      _findOrPut<EducationsController>(() => EducationsController(Get.find()));
  final _jobs = _findOrPut<JobsController>(() => JobsController(Get.find()));
  final _marital = _findOrPut<MaritalStatusController>(
      () => MaritalStatusController(Get.find()));
  final _languages =
      _findOrPut<LanguagesController>(() => LanguagesController(Get.find()));
  final _nationalities = _findOrPut<NationalitiesController>(
      () => NationalitiesController(Get.find()));
  final _regions =
      _findOrPut<RegionsController>(() => RegionsController(Get.find()));

  final _first = TextEditingController();
  final _middle = TextEditingController();
  final _last = TextEditingController();
  final _nationalId = TextEditingController();
  final _iban = TextEditingController();
  final _bankName = TextEditingController();
  final _experts = TextEditingController();
  final _chronic = TextEditingController();
  int? _previousEvents;

  Map<String, dynamic> _user = const {};

  /// Saved values that predate today's format rules; sent back unchanged
  /// they are accepted (the API keeps them), so they must not block a save.
  String _savedNationalId = '';
  String _savedIban = '';

  @override
  void initState() {
    super.initState();
    _prefill();
    c.recoverLostPhoto().then((_) {
      if (mounted) setState(() {});
    });
  }

  void _prefill() {
    final Object? stored = c.authController.authenticatedUser ??
        GetStorage().read<Object>('userData');
    _user = stored is Map ? Map<String, dynamic>.from(stored) : const {};
    c.loadSavedProfile();

    _first.text = _read('firstName');
    _middle.text = _read('middleName');
    _last.text = _read('lastName');
    _savedNationalId = _read('nationalID');
    _nationalId.text = _savedNationalId;
    _bankName.text = _read('bankAccountName');
    _experts.text = _read('experts');
    _chronic.text = _read('chronic_diseases');
    _savedIban = _read('ibanNo').replaceAll(' ', '').toUpperCase();
    if (_savedIban.isNotEmpty) {
      _iban.value = IbanInputFormatter().formatEditUpdate(
          TextEditingValue.empty, TextEditingValue(text: _savedIban));
    }
    // Older profiles may hold free text here; only a number pre-fills, and
    // the saved text is kept unless a count is entered.
    _previousEvents = int.tryParse(
        LatinDigitsFormatter.convert(_read('previous_events_past')).trim());
  }

  String _read(String key) {
    final v = _user[key];
    return v == null ? '' : '$v'.trim();
  }

  @override
  void dispose() {
    for (final controller in [
      _first,
      _middle,
      _last,
      _nationalId,
      _iban,
      _bankName,
      _experts,
      _chronic,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  // ---- Actions ----

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      setState(() => _attempted = true);
      return;
    }

    c
      ..firstName = _first.text.trim()
      ..middleName = _middle.text.trim()
      ..lastName = _last.text.trim()
      ..nationalNo = LatinDigitsFormatter.convert(_nationalId.text).trim()
      ..ibanNumber = _iban.text.replaceAll(' ', '')
      ..bankAccountName = _bankName.text.trim()
      ..previousEvents = _previousEvents?.toString() ?? ''
      ..experts = _experts.text.trim()
      ..chronicDiseases = _chronic.text.trim();

    final saved = await c.updateProfile(showSuccessMessage: false);
    if (!saved || !mounted) return;

    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(true);
    Get.snackbar(
      'Profile updated'.tr,
      'Your changes have been saved'.tr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: AppTheme.navy,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_rounded, color: AppTheme.success),
    );
  }

  Future<void> _pickPhoto() async {
    final source = await showPhotoSourceSheet(context,
        hasPhoto: c.imagePath.isNotEmpty);
    if (source == null) return;
    switch (source) {
      case PhotoSource.camera:
        await c.takePhoto();
        break;
      case PhotoSource.gallery:
        await c.pickImage();
        break;
      case PhotoSource.remove:
        // Drops the newly picked photo; the saved one stays.
        c.clearImage();
        break;
    }
    if (mounted) setState(() {});
  }

  Future<void> _pickDocument(Future<void> Function() pick) async {
    await pick();
    if (mounted) setState(() {});
  }

  void _viewDocument(String key, String title) {
    final path = _read(key);
    if (path.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _DocumentPreviewSheet(
        url: userImageUrl(path),
        title: title,
      ),
    );
  }

  // ---- Validators ----

  String? _requiredText(String? v) =>
      (v?.trim().isEmpty ?? true) ? 'Required'.tr : null;

  String? _name(String? v) {
    final text = v?.trim() ?? '';
    if (text.isEmpty) return 'Required'.tr;
    // Backend rule: min:3.
    if (text.length < 3) return 'Must be at least 3 characters'.tr;
    return null;
  }

  String? _nationalIdRule(String? v) {
    final value = LatinDigitsFormatter.convert(v ?? '').trim();
    if (value.isNotEmpty && value == _savedNationalId) return null;
    return RegExp(r'^\d{10}$').hasMatch(value)
        ? null
        : 'National ID must be 10 digits'.tr;
  }

  String? _ibanRule(String? v) {
    final value = (v ?? '').replaceAll(' ', '');
    if (value.isNotEmpty && value == _savedIban) return null;
    return RegExp(r'^SA\d{22}$').hasMatch(value)
        ? null
        : 'Enter a valid Saudi IBAN (SA + 22 digits)'.tr;
  }

  // ---- Build ----

  static const _gap = SizedBox(height: 24);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.statusBarLight,
      child: Scaffold(
        backgroundColor: AppTheme.scaffold,
        appBar: AppBar(
          backgroundColor: AppTheme.scaffold,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: const BackButton(color: AppTheme.textTitle),
          title: Text(
            'Edit profile'.tr,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppTheme.textTitle,
            ),
          ),
        ),
        body: GestureDetector(
          // Tapping outside a field closes the keyboard.
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  autovalidateMode: _attempted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  // A Column, not a ListView: validate() only sees fields
                  // that are built.
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _header(),
                        _gap,
                        ..._personal(now),
                        _gap,
                        ..._background(),
                        _gap,
                        ..._bank(),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() => ProfileBottomBar(
                    label: 'Save changes'.tr,
                    loading: c.isLoading,
                    onPressed: _save,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final image = _read('image');
    final contact = [_read('phone'), _read('email')]
        .where((v) => v.isNotEmpty)
        .join('  ·  ');
    return Column(
      children: [
        AvatarFormField(
          path: c.imagePath,
          networkUrl: image.isEmpty ? null : userImageUrl(image),
          onTap: _pickPhoto,
          requiredMessage: 'Please add a profile photo'.tr,
        ),
        if (contact.isNotEmpty) ...[
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              contact,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.textHint),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _personal(DateTime now) {
    return [
      AutofillGroup(
        child: FormSection(
          title: 'Full name'.tr,
          icon: Icons.person_outline_rounded,
          children: [
            LabeledField(
              label: 'First Name'.tr,
              child: _text(_first,
                  validator: _name, autofill: AutofillHints.givenName),
            ),
            LabeledField(
              label: 'Middle Name'.tr,
              child: _text(_middle,
                  validator: _name, autofill: AutofillHints.middleName),
            ),
            LabeledField(
              label: 'Family Name'.tr,
              child: _text(_last,
                  validator: _name, autofill: AutofillHints.familyName),
            ),
          ],
        ),
      ),
      _gap,
      FormSection(
        title: 'Identity'.tr,
        icon: Icons.badge_outlined,
        children: [
          LabeledField(
            label: 'National Number'.tr,
            child: _text(
              _nationalId,
              hint: '10 digits'.tr,
              validator: _nationalIdRule,
              keyboard: TextInputType.number,
              action: TextInputAction.done,
              formatters: [
                LatinDigitsFormatter(),
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(14),
              ],
            ),
          ),
          LabeledField(
            label: 'Gender'.tr,
            child: Obx(() => _GenderPicker(
                  value: c.gender,
                  onChanged: (g) {
                    HapticFeedback.selectionClick();
                    c.setGender(g);
                  },
                )),
          ),
          LabeledField(
            label: 'Date of birth'.tr,
            child: DateFormField(
              value: c.birthdate,
              hint: 'Select date'.tr,
              first: DateTime(now.year - 80),
              last: DateTime(now.year - 16, now.month, now.day),
              onChanged: c.setBirthdate,
              requiredMessage: 'Please select your date of birth'.tr,
            ),
          ),
          LabeledField(
            label: 'Nationality'.tr,
            child: Obx(() => SelectFormField<NationalityModel>(
                  title: 'Nationality'.tr,
                  hint: 'Select your nationality'.tr,
                  icon: Icons.flag_outlined,
                  // Not required by the API; a saved choice may also be
                  // one the dashboard has since removed.
                  required: false,
                  loading: _nationalities.isLoading &&
                      _nationalities.nationalities.isEmpty,
                  value: c.selectedNationality.id == null
                      ? null
                      : c.selectedNationality,
                  items: _nationalities.nationalities,
                  itemLabel: (n) => n.name ?? '',
                  itemKey: (n) => n.id,
                  onChanged: c.setSelectedNationality,
                )),
          ),
          LabeledField(
            label: 'Region'.tr,
            child: Obx(() => SelectFormField<RegionModel>(
                  title: 'Region'.tr,
                  hint: 'Select your region'.tr,
                  icon: Icons.location_on_outlined,
                  required: false,
                  loading: _regions.isLoading && _regions.regions.isEmpty,
                  value: c.selectedRegion.id == null ? null : c.selectedRegion,
                  items: _regions.regions,
                  itemLabel: (r) => r.name ?? '',
                  itemKey: (r) => r.id,
                  onChanged: c.setSelectedRegion,
                )),
          ),
        ],
      ),
    ];
  }

  List<Widget> _background() {
    return [
      FormSection(
        title: 'Education & work'.tr,
        icon: Icons.school_outlined,
        children: [
          LabeledField(
            label: 'Education Level'.tr,
            child: Obx(() => SelectFormField<EducationModel>(
                  title: 'Education Level'.tr,
                  hint: 'Select'.tr,
                  loading: _educations.isLoading &&
                      _educations.educations.isEmpty,
                  value: c.selectedEducation.id == null
                      ? null
                      : c.selectedEducation,
                  items: _educations.educations,
                  itemLabel: (e) => e.name ?? '',
                  itemKey: (e) => e.id,
                  onChanged: c.setSelectedEducation,
                )),
          ),
          LabeledField(
            label: 'Job Status'.tr,
            child: Obx(() => SelectFormField<JobModel>(
                  title: 'Job Status'.tr,
                  hint: 'Select'.tr,
                  loading: _jobs.isLoading && _jobs.jobs.isEmpty,
                  value: c.selectedJob.id == null ? null : c.selectedJob,
                  items: _jobs.jobs,
                  itemLabel: (j) => j.name ?? '',
                  itemKey: (j) => j.id,
                  onChanged: c.setSelectedJob,
                )),
          ),
          LabeledField(
            label: 'Marital Status'.tr,
            child: Obx(() => SelectFormField<MaritalStatusModel>(
                  title: 'Marital Status'.tr,
                  hint: 'Select'.tr,
                  loading: _marital.isLoading && _marital.maritalStatus.isEmpty,
                  value: c.selectedMaritalStatus.id == null
                      ? null
                      : c.selectedMaritalStatus,
                  items: _marital.maritalStatus,
                  itemLabel: (m) => m.name ?? '',
                  itemKey: (m) => m.id,
                  onChanged: c.setSelectedMaritalStatus,
                )),
          ),
        ],
      ),
      _gap,
      FormSection(
        title: 'Experience'.tr,
        icon: Icons.workspace_premium_outlined,
        children: [
          LabeledField(
            label: 'Languages'.tr,
            optional: true,
            child: Obx(() => MultiSelectFormField<LanguageModel>(
                  title: 'Languages'.tr,
                  hint: 'Select languages'.tr,
                  icon: Icons.translate_rounded,
                  loading:
                      _languages.isLoading && _languages.languages.isEmpty,
                  values: c.languages,
                  items: _languages.languages,
                  itemLabel: (l) => l.name ?? '',
                  itemKey: (l) => l.id,
                  onChanged: c.setLanguages,
                )),
          ),
          LabeledField(
            label: 'Previous Events Past'.tr,
            optional: true,
            child: CountStepperField(
              value: _previousEvents,
              onChanged: (v) => _previousEvents = v,
            ),
          ),
          LabeledField(
            label: 'Experts'.tr,
            optional: true,
            child: _text(
              _experts,
              hint: 'Events or roles you have worked in'.tr,
              lines: 4,
              caps: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
      _gap,
      FormSection(
        title: 'Health'.tr,
        icon: Icons.favorite_border_rounded,
        footer: 'Only shared with event supervisors, for your safety.'.tr,
        children: [
          LabeledField(
            label: 'Chronic diseases'.tr,
            optional: true,
            child: _text(
              _chronic,
              hint: 'Leave empty if none'.tr,
              lines: 3,
              caps: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _bank() {
    return [
      FormSection(
        title: 'Bank account'.tr,
        icon: Icons.account_balance_outlined,
        footer: 'Your event payments are transferred to this account.'.tr,
        children: [
          LabeledField(
            label: 'Iban Number'.tr,
            child: Directionality(
              // IBANs read left-to-right even in Arabic.
              textDirection: TextDirection.ltr,
              child: _text(
                _iban,
                hint: 'SA00 0000 0000 0000 0000 0000',
                validator: _ibanRule,
                caps: TextCapitalization.characters,
                autocorrect: false,
                formatters: [IbanInputFormatter()],
              ),
            ),
          ),
          LabeledField(
            label: 'Bank Account Name'.tr,
            child: _text(
              _bankName,
              hint: 'Name as on the bank account'.tr,
              validator: _requiredText,
              autofill: AutofillHints.name,
              action: TextInputAction.done,
            ),
          ),
        ],
      ),
      _gap,
      FormSection(
        title: 'Documents'.tr,
        icon: Icons.folder_outlined,
        children: [
          DocumentFormField(
            title: 'IBAN certificate'.tr,
            hint: 'PDF or image'.tr,
            path: c.ibanFilePath,
            saved: _read('iban_file').isNotEmpty,
            onView: () => _viewDocument('iban_file', 'IBAN certificate'.tr),
            icon: Icons.receipt_long_outlined,
            onTap: () => _pickDocument(c.handleFileSelectionForIban),
          ),
          DocumentFormField(
            title: 'CV / Resume'.tr,
            hint: 'PDF or Word'.tr,
            path: c.cvEmpPath,
            saved: _read('emp_cv').isNotEmpty,
            onView: () => _viewDocument('emp_cv', 'CV / Resume'.tr),
            icon: Icons.description_outlined,
            onTap: () => _pickDocument(c.handleFileSelection),
          ),
        ],
      ),
    ];
  }

  Widget _text(
    TextEditingController controller, {
    String? hint,
    FormFieldValidator<String>? validator,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    String? autofill,
    int lines = 1,
    TextInputAction? action,
    TextCapitalization caps = TextCapitalization.words,
    bool autocorrect = true,
  }) {
    final multiline = lines > 1;
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: multiline ? TextInputType.multiline : keyboard,
      inputFormatters: formatters,
      autofillHints: autofill == null ? null : [autofill],
      autocorrect: autocorrect,
      minLines: multiline ? lines : 1,
      maxLines: multiline ? lines + 2 : 1,
      textInputAction: action ??
          (multiline ? TextInputAction.newline : TextInputAction.next),
      textCapitalization: caps,
      cursorColor: AppTheme.brand,
      style: const TextStyle(fontSize: 15, color: AppTheme.textTitle),
      decoration: profileInputDecoration(hint: hint),
    );
  }
}

/// Two-option male / female switch in the field style.
class _GenderPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _GenderPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget option(String gender, String label, IconData icon) {
      final selected = value == gender;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(gender),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            height: 42,
            decoration: BoxDecoration(
              color: selected ? AppTheme.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              boxShadow: selected
                  ? const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 18,
                    color: selected ? AppTheme.brand : AppTheme.textMuted),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? AppTheme.textTitle : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.field,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Row(
        children: [
          option('male', 'Male'.tr, Icons.male_rounded),
          const SizedBox(width: 4),
          option('female', 'Female'.tr, Icons.female_rounded),
        ],
      ),
    );
  }
}

/// Saved IBAN certificate or CV: a photo or a PDF.
class _DocumentPreviewSheet extends StatelessWidget {
  final String url;
  final String title;

  const _DocumentPreviewSheet({required this.url, required this.title});

  bool get _isImage =>
      RegExp(r'\.(jpe?g|png|webp|heic|heif)$', caseSensitive: false)
          .hasMatch(url);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textTitle,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radius)),
              child: _isImage
                  ? InteractiveViewer(
                      child: Image.network(
                        url,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const _PreviewError(),
                      ),
                    )
                  : SfPdfViewer.network(url),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewError extends StatelessWidget {
  const _PreviewError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Couldn't open this file".tr,
        style: const TextStyle(color: AppTheme.textMuted),
      ),
    );
  }
}
