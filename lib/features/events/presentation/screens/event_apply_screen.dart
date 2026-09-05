import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/features/events/presentation/controllers/event_apply_controller.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

import '../../../../view/widgets/Forms/easy_app_text_form_field.dart';
import '../../../../widgets/Common/custom_dropdown.dart';
import '../../../jobs/data/models/job_model.dart';
import '../../../jobs/presentation/controllers/marital_status_controller.dart';

/// Tabular figures: keeps numbers (dates, times, counts) aligned on the same
/// width so the layout never jitters as values change.
const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

/// Apply-to-event form. Single-purpose screen — no bottom nav; a sticky CTA
/// bar lives at the bottom so the primary action is always one tap away.
class EventApplyScreen extends StatefulWidget {
  const EventApplyScreen({super.key});

  @override
  State<EventApplyScreen> createState() => _EventApplyScreenState();
}

class _EventApplyScreenState extends State<EventApplyScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final EventApplyController applyController =
      Get.put(EventApplyController(Get.find()));

  void _showTermsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scroll) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textTitle,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scroll,
                  children: const [
                    Text(
                      '...',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.textBody,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: AppBar(
        title: Text(
          'Apply'.tr,
          style: const TextStyle(
            color: AppTheme.textTitle,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppTheme.textTitle,
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<EventApplyController>(
        init: EventApplyController(Get.find()),
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _EventSummaryHeader(controller: controller),
                        const SizedBox(height: 16),
                        _SectionCard(
                          icon: Icons.work_outline_rounded,
                          title: 'Choose role'.tr,
                          errorText:
                              controller.errors['job']?.toString().isNotEmpty ==
                                      true
                                  ? controller.errors['job'].toString()
                                  : null,
                          child: _buildJobField(controller),
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          icon: Icons.schedule_rounded,
                          title: 'Choose shift'.tr,
                          errorText: controller.errors['period']
                                      ?.toString()
                                      .isNotEmpty ==
                                  true
                              ? controller.errors['period'].toString()
                              : null,
                          child: _buildPeriodList(controller),
                        ),
                        const SizedBox(height: 12),
                        _SectionCard(
                          icon: Icons.edit_note_rounded,
                          title: 'Add a note'.tr,
                          trailing: Text(
                            'Optional',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFeatures: _tabular,
                            ),
                          ),
                          child: _buildNotesField(controller),
                        ),
                        const SizedBox(height: 12),
                        _AgreementCard(
                          controller: controller,
                          onShowTerms: _showTermsSheet,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _StickyCta(
                applyController: applyController,
                onSubmit: () {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    controller.apply();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildJobField(EventApplyController controller) {
    final bool hasError = controller.errors.containsKey('job');
    return GetBuilder<JobsController>(
      init: JobsController(Get.find()),
      builder: (jobsController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.field,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(
              color: hasError ? AppTheme.danger : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: CustomDropdownV2<JobModel?>(
            leadingIcon: true,
            onChange: (int index) => controller.setSelectedJob(
              jobsController.jobs.elementAt(index),
            ),
            dropdownButtonStyle: DropdownButtonStyle(
              width: double.infinity,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusSm),
              ),
              height: 48,
              elevation: 0,
              backgroundColor: Colors.transparent,
              primaryColor: AppTheme.textMuted,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            dropdownStyle: DropdownStyle(
              color: AppTheme.surface,
              elevation: 6,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusSm),
              ),
            ),
            items: jobsController.jobs
                .asMap()
                .entries
                .map(
                  (item) => DropdownItem<JobModel?>(
                    value: item.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Text(
                        item.value.name ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textBody,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                controller.selectedJob.id != 0
                    ? controller.selectedJob.name.toString()
                    : 'اختر الوظيفة',
                style: TextStyle(
                  color: controller.selectedJob.id != 0
                      ? AppTheme.textTitle
                      : AppTheme.textHint,
                  fontSize: 14,
                  fontWeight: controller.selectedJob.id != 0
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodList(EventApplyController controller) {
    if (controller.isLoading || controller.event == null) {
      return AppLoader.list(items: 3, showTrailing: false);
    }

    final periods = controller.event!.periods ?? [];
    if (periods.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No shifts available',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 13,
          ),
        ),
      );
    }

    return Column(
      children: List.generate(periods.length, (i) {
        final p = periods[i];
        final bool selected = controller.periodId == p.id;
        return Padding(
          padding: EdgeInsets.only(bottom: i == periods.length - 1 ? 0 : 8),
          child: InkWell(
            onTap: () => controller.setSelectEventPeriod(p.id),
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.brand.withOpacity(0.08)
                    : AppTheme.field,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(
                  color: selected ? AppTheme.brand : Colors.transparent,
                  width: 1.4,
                ),
              ),
              child: Row(
                children: [
                  _RadioDot(selected: selected),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      p.period,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? AppTheme.brandDark
                            : AppTheme.textBody,
                        fontFeatures: _tabular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNotesField(EventApplyController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.field,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: EasyAppTextFormField(
        required: false,
        multiline: 3,
        maxLength: 200,
        onSave: (value) => controller.others = value ?? '',
        labelText: 'اكتب ملاحظاتك هنا...',
        hintText: '',
      ),
    );
  }
}

/// Compact event summary at the top: small logo, name, date · time on one line.
/// Gives the user context for the form without dominating the screen.
class _EventSummaryHeader extends StatelessWidget {
  final EventApplyController controller;
  const _EventSummaryHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading || controller.event == null) {
      return _HeaderSkeleton();
    }

    final event = controller.event!;
    final date = event.date ?? '';
    final time = event.time ?? '';
    final meta = [date, time].where((s) => s.isNotEmpty).join(' · ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.field,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/sagr-logo.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTitle,
                    height: 1.2,
                  ),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w500,
                      fontFeatures: _tabular,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: AppShimmer(
        child: Row(
          children: const [
            Bone(width: 44, height: 44, radius: 12),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone(width: 140, height: 12),
                  SizedBox(height: 8),
                  Bone(width: 90, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Generic section card used across the form: white surface, line border,
/// header row (icon + title in w800), optional trailing label, optional error.
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;
  final String? errorText;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.brand.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.brand, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textTitle,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 14,
                  color: AppTheme.danger,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText!,
                    style: const TextStyle(
                      color: AppTheme.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Two compact agreement checkboxes (terms + promise) inside one card —
/// preserves the original wiring (toggleTerms / togglePromise) and error keys.
class _AgreementCard extends StatelessWidget {
  final EventApplyController controller;
  final VoidCallback onShowTerms;

  const _AgreementCard({
    required this.controller,
    required this.onShowTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(color: AppTheme.line),
      ),
      child: Column(
        children: [
          _CheckRow(
            value: controller.terms,
            title: 'موافق على الشروط والأحكام',
            onToggle: controller.toggleTerms,
            onTitleTap: onShowTerms,
            underline: true,
          ),
          if ((controller.errors['terms']?.toString() ?? '').isNotEmpty)
            _ErrorLine(text: controller.errors['terms'].toString()),
          const SizedBox(height: 10),
          _CheckRow(
            value: controller.promise,
            title: 'أتعهد بصحة البيانات',
            onToggle: controller.togglePromise,
          ),
          if ((controller.errors['promise']?.toString() ?? '').isNotEmpty)
            _ErrorLine(text: controller.errors['promise'].toString()),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final bool value;
  final String title;
  final VoidCallback onToggle;
  final VoidCallback? onTitleTap;
  final bool underline;

  const _CheckRow({
    required this.value,
    required this.title,
    required this.onToggle,
    this.onTitleTap,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? AppTheme.brand : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? AppTheme.brand : AppTheme.textHint,
                  width: 1.4,
                ),
              ),
              child: value
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: onTitleTap ?? onToggle,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: value ? FontWeight.w700 : FontWeight.w500,
                    color: value ? AppTheme.textTitle : AppTheme.textBody,
                    decoration:
                        underline ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorLine extends StatelessWidget {
  final String text;
  const _ErrorLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 13,
              color: AppTheme.danger,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppTheme.danger,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppTheme.brand : Colors.transparent,
        border: Border.all(
          color: selected ? AppTheme.brand : AppTheme.textHint,
          width: 1.4,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
          : null,
    );
  }
}

/// Sticky bottom CTA bar — surface card with brand gradient button. Keeps the
/// submit action one tap away no matter how long the form gets.
class _StickyCta extends StatelessWidget {
  final EventApplyController applyController;
  final VoidCallback onSubmit;

  const _StickyCta({
    required this.applyController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.line)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      child: Obx(() {
        final loading = applyController.isLoading;
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: InkWell(
            onTap: loading ? null : onSubmit,
            borderRadius: BorderRadius.circular(AppTheme.radius),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.brand, AppTheme.brandDark],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radius),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.brand.withOpacity(0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loading) ...[
                      AppLoader.inline(size: 18, color: Colors.white),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      loading
                          ? 'Submitting...'.tr
                          : 'Submit Application'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (!loading) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
