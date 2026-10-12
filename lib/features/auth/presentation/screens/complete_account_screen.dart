import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
import 'package:sagr/theme/app_theme.dart';

T _findOrPut<T>(T Function() create) =>
    Get.isRegistered<T>() ? Get.find<T>() : Get.put<T>(create());

/// Profile completion, required once before a user can apply for events.
///
/// Three short steps (personal → background → bank & documents) instead of
/// one long card, each validated before moving on. Pops with `true` once the
/// profile is saved so the apply form underneath can carry on.
class CompleteAccountScreen extends StatefulWidget {
  const CompleteAccountScreen({super.key});

  @override
  State<CompleteAccountScreen> createState() => _CompleteAccountScreenState();
}

class _CompleteAccountScreenState extends State<CompleteAccountScreen> {
  static const _stepCount = 3;
  static const _transition = Duration(milliseconds: 280);

  final _formKeys = List.generate(_stepCount, (_) => GlobalKey<FormState>());
  final _attempted = <int>{};
  int _step = 0;
  bool _forward = true;
  DateTime _lastNavigation = DateTime(0);

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
  final _previousEvents = TextEditingController();
  final _experts = TextEditingController();
  final _chronic = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  /// Seeds fields from what the account already has. New accounts only carry
  /// the single `name` typed at sign-up, so split it into first/middle/last.
  void _prefill() {
    final user = c.authController.authenticatedUser ?? const {};
    String? read(String key) {
      final v = user[key];
      return v is String && v.trim().isNotEmpty ? v.trim() : null;
    }

    final parts = (read('name') ?? '')
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    _first.text = read('firstName') ?? (parts.isNotEmpty ? parts.first : '');
    _middle.text = read('middleName') ?? (parts.length > 2 ? parts[1] : '');
    _last.text = read('lastName') ?? (parts.length > 1 ? parts.last : '');
    _nationalId.text = read('nationalID') ?? '';
    _bankName.text = read('bankAccountName') ?? '';
    _experts.text = read('experts') ?? '';
    _chronic.text = read('chronic_diseases') ?? '';
    final iban = read('ibanNo');
    if (iban != null) {
      _iban.value = IbanInputFormatter()
          .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: iban));
    }
    final previous = user['previous_events_past'];
    if (previous != null) _previousEvents.text = '$previous';
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
      _previousEvents,
      _experts,
      _chronic,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  // ---- Navigation ----

  /// Swallows taps while a step transition is still running; re-entering a
  /// step mid-animation would mount its form key twice.
  bool _navigationLocked() {
    final now = DateTime.now();
    if (now.difference(_lastNavigation) < _transition) return true;
    _lastNavigation = now;
    return false;
  }

  Future<void> _next() async {
    FocusScope.of(context).unfocus();
    if (!_formKeys[_step].currentState!.validate()) {
      HapticFeedback.heavyImpact();
      setState(() => _attempted.add(_step));
      return;
    }
    if (_step == _stepCount - 1) return _submit();
    if (_navigationLocked()) return;
    HapticFeedback.selectionClick();
    setState(() {
      _forward = true;
      _step++;
    });
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    if (_navigationLocked()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _forward = false;
      _step--;
    });
  }

  Future<void> _submit() async {
    c
      ..firstName = _first.text.trim()
      ..middleName = _middle.text.trim()
      ..lastName = _last.text.trim()
      ..nationalNo = _nationalId.text.trim()
      ..ibanNumber = _iban.text.replaceAll(' ', '')
      ..bankAccountName = _bankName.text.trim()
      ..previousEvents = _previousEvents.text.trim()
      ..experts = _experts.text.trim()
      ..chronicDiseases = _chronic.text.trim();

    final saved = await c.completeAccount();
    if (!saved || !mounted) return;

    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(true);
    Get.snackbar(
      'Profile completed'.tr,
      'You can now apply for events'.tr,
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
        c.clearImage();
        break;
    }
    if (mounted) setState(() {});
  }

  Future<void> _pickDocument(Future<void> Function() pick) async {
    await pick();
    if (mounted) setState(() {});
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

  String? _nationalIdRule(String? v) =>
      RegExp(r'^\d{10}$').hasMatch(v?.trim() ?? '')
          ? null
          : 'National ID must be 10 digits'.tr;

  String? _ibanRule(String? v) =>
      RegExp(r'^SA\d{22}$').hasMatch((v ?? '').replaceAll(' ', ''))
          ? null
          : 'Enter a valid Saudi IBAN (SA + 22 digits)'.tr;

  // ---- Build ----

  @override
  Widget build(BuildContext context) {
    final isLast = _step == _stepCount - 1;

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.statusBarLight,
        child: Scaffold(
          backgroundColor: AppTheme.scaffold,
          appBar: AppBar(
            backgroundColor: AppTheme.scaffold,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: BackButton(onPressed: _back, color: AppTheme.textTitle),
            title: Text(
              'Complete your profile'.tr,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.textTitle,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: ProfileStepProgress(
                    current: _step, total: _stepCount),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: _transition,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  layoutBuilder: (current, previous) => Stack(
                    alignment: Alignment.topCenter,
                    children: [...previous, if (current != null) current],
                  ),
                  transitionBuilder: (child, animation) {
                    final incoming = child.key == ValueKey(_step);
                    final rtl =
                        Directionality.of(context) == TextDirection.rtl;
                    final dx =
                        (incoming == _forward ? 0.08 : -0.08) * (rtl ? -1 : 1);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween(
                          begin: Offset(dx, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(_step),
                    child: _stepView(_step),
                  ),
                ),
              ),
              Obx(() => ProfileBottomBar(
                    label: isLast ? 'Submit profile'.tr : 'Continue'.tr,
                    loading: c.isLoading,
                    onPressed: _next,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepView(int step) {
    final children = step == 0
        ? _personalStep()
        : step == 1
            ? _backgroundStep()
            : _bankStep();

    // A Column, not a ListView: validate() only sees fields that are built.
    return Form(
      key: _formKeys[step],
      autovalidateMode: _attempted.contains(step)
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  Widget _intro(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.textTitle,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static const _gap = SizedBox(height: 24);

  List<Widget> _personalStep() {
    final now = DateTime.now();
    return [
      _intro(
        'Personal info'.tr,
        'Enter your details exactly as they appear on your national ID.'.tr,
      ),
      AvatarFormField(
        path: c.imagePath,
        onTap: _pickPhoto,
        requiredMessage: 'Please add a profile photo'.tr,
      ),
      _gap,
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
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
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

  List<Widget> _backgroundStep() {
    return [
      _intro(
        'Background'.tr,
        'This helps supervisors assign you to the right role.'.tr,
      ),
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
            child: _text(
              _previousEvents,
              hint: '0',
              keyboard: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
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

  List<Widget> _bankStep() {
    return [
      _intro(
        'Bank & documents'.tr,
        'Your event payments are transferred to this account.'.tr,
      ),
      FormSection(
        title: 'Bank account'.tr,
        icon: Icons.account_balance_outlined,
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
            icon: Icons.receipt_long_outlined,
            onTap: () => _pickDocument(c.handleFileSelectionForIban),
            requiredMessage: 'Please upload this document'.tr,
          ),
          DocumentFormField(
            title: 'CV / Resume'.tr,
            hint: 'PDF or Word'.tr,
            path: c.cvEmpPath,
            icon: Icons.description_outlined,
            onTap: () => _pickDocument(c.handleFileSelection),
            requiredMessage: 'Please upload this document'.tr,
          ),
        ],
      ),
      const SizedBox(height: 20),
      _terms(),
    ];
  }

  Widget _terms() {
    return FormField<bool>(
      initialValue: c.agree,
      validator: (_) =>
          c.agree ? null : 'Please accept the terms to continue'.tr,
      builder: (field) {
        void toggle() {
          HapticFeedback.selectionClick();
          c.acceptAgree();
          field.didChange(c.agree);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: toggle,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              child: Row(
                children: [
                  Checkbox.adaptive(
                    value: c.agree,
                    activeColor: AppTheme.brand,
                    onChanged: (_) => toggle(),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: '${'I agree to the'.tr} ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textBody,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Use & Privacy Policy'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.brand,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (field.hasError && !c.agree)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(fontSize: 12, color: AppTheme.danger),
                ),
              ),
          ],
        );
      },
    );
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
