import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/events/presentation/controllers/event_apply_controller.dart';

import '../../../../view/widgets/Forms/easy_app_text_form_field.dart';
import '../../../../widgets/Common/custom_dropdown.dart';
import '../../../jobs/data/models/job_model.dart';
import '../../../jobs/presentation/controllers/marital_status_controller.dart';

class EventApplyScreen extends StatefulWidget {
  const EventApplyScreen({super.key});

  @override
  State<EventApplyScreen> createState() => _EventApplyScreenState();
}

class _EventApplyScreenState extends State<EventApplyScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final EventApplyController applyController = Get.put(EventApplyController(Get.find()));

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _showTermsAndConditionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'This is a full-screen bottom sheet!',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: GetBuilder<EventApplyController>(
        init: EventApplyController(Get.find()),
        builder: (EventApplyController eventApplyController) {
          return Column(
            children: [
              _buildCompactHeader(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      child: Column(
                        children: [
                          _buildJobSelectionCard(eventApplyController),
                          const SizedBox(height: 12),
                          _buildTimePeriodCard(eventApplyController),
                          const SizedBox(height: 12),
                          _buildNotesCard(eventApplyController),
                          const SizedBox(height: 12),
                          _buildAgreementCard(eventApplyController),
                          const SizedBox(height: 20),
                          _buildSubmitButton(eventApplyController),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SAGR_PRIMARY, SAGR_SECONDARY],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.indigo,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "طلب التقديم",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: WHITE_COLOR,
                  ),
                ),
                Text(
                  "املأ البيانات للتقديم",
                  style: TextStyle(
                    fontSize: 13,
                    color: WHITE_COLOR.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobSelectionCard(EventApplyController controller) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.work_outline,
            title: "الوظيفة المطلوبة",
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          GetBuilder<JobsController>(
            init: JobsController(Get.find()),
            builder: (jobsController) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: controller.errors.containsKey('job')
                        ? Colors.red.shade300
                        : Colors.grey.shade300,
                  ),
                  color: Colors.grey.shade50,
                ),
                child: CustomDropdownV2<JobModel?>(
                  leadingIcon: true,
                  onChange: (int index) => controller.setSelectedJob(
                    jobsController.jobs.elementAt(index),
                  ),
                  dropdownButtonStyle: DropdownButtonStyle(
                    width: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 48,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    primaryColor: Colors.grey.shade600,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  dropdownStyle: DropdownStyle(
                    color: Colors.white,
                    elevation: 6,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: jobsController.jobs
                      .asMap()
                      .entries
                      .map(
                        (item) => DropdownItem<JobModel?>(
                          value: item.value,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              item.value.name!,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      controller.selectedJob.id != 0
                          ? controller.selectedJob.name.toString()
                          : 'اختر الوظيفة',
                      style: TextStyle(
                        color: controller.selectedJob.id != 0
                            ? Colors.black87
                            : Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (controller.errors.containsKey('job') &&
              controller.errors['job'] != "")
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                controller.errors['job'],
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodCard(EventApplyController controller) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.schedule,
            title: "الفترة الزمنية",
            color: Colors.orange,
          ),
          const SizedBox(height: 10),
          if (controller.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Column(
              children: controller.event!.periods!
                  .asMap()
                  .entries
                  .map((entry) {
                var period = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => controller.setSelectEventPeriod(period.id),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: controller.periodId == period.id
                            ? Colors.indigo.shade50
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: controller.periodId == period.id
                              ? Colors.indigo.shade400
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.periodId == period.id
                                  ? Colors.indigo
                                  : Colors.transparent,
                              border: Border.all(
                                color: controller.periodId == period.id
                                    ? Colors.indigo
                                    : Colors.grey.shade400,
                                width: 1.5,
                              ),
                            ),
                            child: controller.periodId == period.id
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              period.period,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: controller.periodId == period.id
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: controller.periodId == period.id
                                    ? Colors.indigo.shade700
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          if (controller.errors.containsKey('period') &&
              controller.errors['period'] != "")
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                controller.errors['period'],
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(EventApplyController controller) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.note_add_outlined,
            title: "ملاحظات إضافية",
            color: Colors.purple,
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade50,
            ),
            child: EasyAppTextFormField(
              required: false,
              multiline: 3,
              maxLength: 200,
              onSave: (value) => controller.others = value!,
              labelText: "اكتب ملاحظاتك هنا...",
              hintText: "",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementCard(EventApplyController controller) {
    return _buildCard(
      child: Column(
        children: [
          _buildCheckboxTile(
            value: controller.terms,
            subject: 'terms',
            onChanged: () => controller.toggleTerms(),
            title: "موافق على الشروط والأحكام",
            icon: Icons.assignment_outlined,
            color: Colors.teal,
            onShow: () => _showTermsAndConditionsBottomSheet(context),
          ),
           if (controller.errors.containsKey('terms') &&
              controller.errors['terms'] != "")
            Align(
               alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  controller.errors['terms'],
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          _buildCheckboxTile(
            value: controller.promise,
             subject: 'promise',
            onChanged: () => controller.togglePromise(),
            title: "أتعهد بصحة البيانات",
            icon: Icons.verified_outlined,
            color: Colors.indigo,
            onShow: () => _showTermsAndConditionsBottomSheet(context),
          ),
            if (controller.errors.containsKey('promise') &&
              controller.errors['promise'] != "")
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  controller.errors['promise'],
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required VoidCallback onChanged,
    required VoidCallback? onShow,
    required String title,
    required String subject,
    required IconData icon,
    required Color color,

  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value ? color.withOpacity(0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value ? color.withOpacity(0.5) : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
   
        children: [
          GestureDetector(
            onTap: onChanged,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: value ? color : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onChanged,
            child: Icon(
              icon,
              color: value ? color : Colors.grey.shade600,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: subject == 'terms' ? onShow : null,
              child: Text(
                title,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                  fontWeight: value ? FontWeight.w600 : FontWeight.w400,
                  color: value ? color : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(EventApplyController controller) {
    return GestureDetector(
      onTap: () {
        _formKey.currentState!.save();
        if (_formKey.currentState!.validate()) {
          controller.apply();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade600, Colors.indigo.shade400],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (applyController.isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              if (applyController.isLoading) const SizedBox(width: 12),
              Text(
                applyController.isLoading
                    ? "${"SEND_REQUEST".tr}..."
                    : "SEND_REQUEST".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class RadioButtonDot extends StatelessWidget {
  final double borderRadius;

  const RadioButtonDot({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: RED_COLOR,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}