import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

import '../../data/models/evocation_model.dart';

const _tabular = [FontFeature.tabularFigures()];

/// Premium, compact 2-step bottom sheet for creating / editing an evocation
/// (prayer / food permission request). Uses the unified [AppTheme] tokens —
/// no purple gradient, no rotating borders, no heavy animation stack.
class CreateEvocationBottomSheet extends StatefulWidget {
  final Function(EvocationModel) onEvocationCreated;
  final EvocationModel? initialEvocation;

  const CreateEvocationBottomSheet({
    super.key,
    required this.onEvocationCreated,
    this.initialEvocation,
  });

  @override
  State<CreateEvocationBottomSheet> createState() =>
      _CreateEvocationBottomSheetState();
}

class _CreateEvocationBottomSheetState
    extends State<CreateEvocationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  final PageController _pageController = PageController();

  EvocationType? _selectedType;
  File? _selectedFile;
  String? _selectedFileName;

  bool _isLoading = false;
  String? _fileError;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialEvocation;
    if (initial != null) {
      _selectedType = initial.type;
      _durationController.text = initial.duration.toString();
      _notesController.text = initial.notes ?? '';
      _selectedFileName = initial.attachment;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ---- File picking ----
  Future<void> _pickFile() async {
    try {
      setState(() => _fileError = null);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const [
          'jpg', 'jpeg', 'png', 'pdf', 'mp3', 'mp4', 'doc', 'docx'
        ],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        final fileSize = await file.length();

        if (fileSize > 10 * 1024 * 1024) {
          setState(() => _fileError = 'File size must be less than 10MB');
          return;
        }

        setState(() {
          _selectedFile = file;
          _selectedFileName = result.files.first.name;
        });
      }
    } catch (e) {
      setState(() => _fileError = 'Error selecting file: $e');
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
      _fileError = null;
    });
  }

  // ---- Formatting / submit ----
  String _formatDuration(String text) {
    if (text.isEmpty) return '';
    final minutes = int.tryParse(text) ?? 0;
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) return ' (${hours}h ${mins}m)';
    return ' (${mins}m)';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      _toast('Please select an evocation type', isSuccess: false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final evocation = EvocationModel(
        id: widget.initialEvocation?.id,
        type: _selectedType!,
        duration: int.parse(_durationController.text),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        eventId: 1,
        zoneId: 1,
        userId: 1,
      );

      await Future.delayed(const Duration(milliseconds: 1200));

      widget.onEvocationCreated(evocation);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _toast('Error: $e', isSuccess: false);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toast(String message, {bool isSuccess = true}) {
    final color = isSuccess ? AppTheme.success : AppTheme.danger;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(message,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 1 && _formKey.currentState!.validate()) {
      if (_selectedType == null) {
        _toast('Please select an evocation type', isSuccess: false);
        return;
      }
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _header(),
          _stepper(),
          Expanded(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _formStep(),
                  _reviewStep(),
                ],
              ),
            ),
          ),
          _footer(),
        ],
      ),
    );
  }

  // ---- Header (clean white + handle + teal icon block) ----
  Widget _header() {
    final isEdit = widget.initialEvocation != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppTheme.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.brand, AppTheme.brandDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.brand.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isEdit ? Icons.edit_rounded : Icons.add_circle_outline_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit
                          ? 'Edit Evocation'.tr
                          : 'Create Evocation'.tr,
                      style: const TextStyle(
                        color: AppTheme.textTitle,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isEdit
                          ? 'Update evocation details'.tr
                          : 'Add a new prayer or food evocation'.tr,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: AppTheme.field,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(Icons.close_rounded,
                        color: AppTheme.textTitle, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Step indicator ----
  Widget _stepper() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${"Step".tr} ${_currentStep + 1}/2',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.4,
                  fontFeatures: _tabular,
                ),
              ),
              const Spacer(),
              Text(
                _currentStep == 0 ? 'Details'.tr : 'Review'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.brand,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(2, (i) {
              final active = i <= _currentStep;
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: i == 0 ? 8 : 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    height: 5,
                    decoration: BoxDecoration(
                      color: active ? AppTheme.brand : AppTheme.line,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ---- Step 1: form ----
  Widget _formStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Evocation Type'.tr, required: true),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _typeCard(EvocationType.prayer)),
              const SizedBox(width: 12),
              Expanded(child: _typeCard(EvocationType.food)),
            ],
          ),
          const SizedBox(height: 22),

          _sectionLabel('Duration'.tr, required: true),
          const SizedBox(height: 10),
          _durationField(),
          const SizedBox(height: 22),

          _sectionLabel('Notes'.tr),
          const SizedBox(height: 10),
          _notesField(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ---- Step 2: review ----
  Widget _reviewStep() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Review & Confirm'.tr),
          const SizedBox(height: 12),
          _reviewCard(),
          const SizedBox(height: 20),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Column(
                  children: [
                    AppLoader.inline(size: 36, color: AppTheme.brand),
                    const SizedBox(height: 10),
                    Text(
                      widget.initialEvocation == null
                          ? '${"Creating evocation".tr}...'
                          : '${"Updating evocation".tr}...',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---- Helpers ----
  Widget _sectionLabel(String title, {bool required = false}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppTheme.textTitle,
            letterSpacing: 0.2,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.danger,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ],
    );
  }

  Widget _typeCard(EvocationType type) {
    final selected = _selectedType == type;
    final isPrayer = type == EvocationType.prayer;
    final Color accent = isPrayer ? AppTheme.sky : AppTheme.warning;
    final IconData icon =
        isPrayer ? Icons.self_improvement_rounded : Icons.restaurant_rounded;
    final String label = isPrayer ? 'Prayer'.tr : 'Food'.tr;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: selected ? accent.withOpacity(0.08) : Colors.white,
          border: Border.all(
            color: selected ? accent : AppTheme.line,
            width: selected ? 1.6 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected
                    ? accent.withOpacity(0.14)
                    : AppTheme.field,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: selected ? accent : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: selected ? accent : AppTheme.textTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input({
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppTheme.textHint,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      suffixText: suffix,
      suffixStyle: const TextStyle(
        color: AppTheme.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        fontFeatures: _tabular,
      ),
      prefixIcon: Container(
        margin: const EdgeInsets.fromLTRB(10, 8, 6, 8),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: AppTheme.brand.withOpacity(0.10),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, color: AppTheme.brand, size: 16),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.brand, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.danger, width: 1.6),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
    );
  }

  Widget _durationField() {
    return TextFormField(
      controller: _durationController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppTheme.textTitle,
        fontFeatures: _tabular,
      ),
      decoration: _input(
        hint: 'Enter duration in minutes'.tr,
        icon: Icons.schedule_rounded,
        suffix: _formatDuration(_durationController.text),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter duration'.tr;
        }
        final duration = int.tryParse(value);
        if (duration == null || duration <= 0) {
          return 'Please enter a valid duration'.tr;
        }
        if (duration > 1440) {
          return 'Duration cannot exceed 24 hours'.tr;
        }
        return null;
      },
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _notesField() {
    return TextFormField(
      controller: _notesController,
      maxLines: 3,
      maxLength: 2000,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
        color: AppTheme.textBody,
        height: 1.45,
      ),
      decoration: _input(
        hint: '${"Add any additional notes".tr}...',
        icon: Icons.notes_rounded,
      ).copyWith(
        counterStyle: const TextStyle(
          color: AppTheme.textMuted,
          fontSize: 11,
          fontFeatures: _tabular,
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  // Attachment block (kept available; currently not wired into form step).
  // ignore: unused_element
  Widget _attachmentSection() {
    final hasFile = _selectedFile != null || _selectedFileName != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasFile)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.08),
              border: Border.all(color: AppTheme.success.withOpacity(0.35)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.attach_file_rounded,
                      color: AppTheme.success, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedFileName ?? 'Unknown file'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      Text(
                        'File attached successfully'.tr,
                        style: TextStyle(
                          color: AppTheme.success.withOpacity(0.85),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _removeFile,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close_rounded,
                        color: AppTheme.danger, size: 18),
                  ),
                ),
              ],
            ),
          )
        else
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.field,
                border: Border.all(color: AppTheme.line),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload_rounded,
                      size: 28, color: AppTheme.textMuted.withOpacity(0.7)),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to select file'.tr,
                    style: const TextStyle(
                      color: AppTheme.textTitle,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'JPG, PNG, PDF, MP3, MP4, DOC · Max 10MB',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AppTheme.textMuted,
                      fontFeatures: _tabular,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_fileError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppTheme.danger, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _fileError!,
                    style: const TextStyle(
                      color: AppTheme.danger,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ---- Review card ----
  Widget _reviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _reviewItem(
            'Type'.tr,
            _selectedType?.displayName ?? '—',
            Icons.category_rounded,
          ),
          _reviewItem(
            'Duration'.tr,
            '${_durationController.text} ${"minutes".tr}${_formatDuration(_durationController.text)}',
            Icons.schedule_rounded,
          ),
          if (_notesController.text.isNotEmpty)
            _reviewItem('Notes'.tr, _notesController.text, Icons.notes_rounded),
          if (_selectedFileName != null)
            _reviewItem('Attachment'.tr, _selectedFileName!,
                Icons.attach_file_rounded),
        ],
      ),
    );
  }

  Widget _reviewItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.brand.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: AppTheme.brand),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: AppTheme.textTitle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Footer ----
extension _Footer on _CreateEvocationBottomSheetState {
  Widget _footer() {
    final isLast = _currentStep == 1;
    final isEdit = widget.initialEvocation != null;
    final String primaryLabel = isLast
        ? (isEdit ? 'Update Evocation'.tr : 'Create Evocation'.tr)
        : 'Review'.tr;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppTheme.line)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: const BorderSide(color: AppTheme.line, width: 1.2),
                    foregroundColor: AppTheme.textTitle,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: Text(
                    'Previous'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: _PrimaryCta(
                label: primaryLabel,
                loading: _isLoading,
                onPressed: _isLoading
                    ? null
                    : (isLast ? _submitForm : _nextStep),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  const _PrimaryCta({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.brand, AppTheme.brandDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.brand.withOpacity(0.30),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: loading
                  ? AppLoader.inline(size: 18, color: Colors.white)
                  : Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 14.5,
                        letterSpacing: 0.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
