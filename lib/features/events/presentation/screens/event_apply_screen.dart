import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/events/presentation/controllers/event_apply_controller.dart';
import 'package:sagr/features/language/presentation/controllers/languages_controller.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';

import '../../../../view/widgets/Forms/easy_app_text_form_field.dart';
import '../../../../widgets/Common/custom_dropdown.dart';
import '../../../jobs/data/models/job_model.dart';
import '../../../jobs/presentation/controllers/marital_status_controller.dart';
import '../../../language/data/models/language_model.dart';

class EventApplyScreen extends StatefulWidget {
  const EventApplyScreen({super.key});

  @override
  State<EventApplyScreen> createState() => _EventApplyScreenState();
}

class _EventApplyScreenState extends State<EventApplyScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
    final EventApplyController applyController = Get.put(EventApplyController(Get.find()));

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
      begin: const Offset(0, 0.3),
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
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: GetBuilder<EventApplyController>(
          init: EventApplyController(Get.find()),
          builder: (EventApplyController eventApplyController) {
            return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
              child: Column(
                children: [
                  // Modern Header

          
                  _buildModernHeader(),
                       
                  // Form Content
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                offset: Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Form indicator
                                _buildFormIndicator(),
                                
                                // Scrollable form content
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      children: [
                                      
                                        _buildJobSelectionCard(eventApplyController),
                                        const SizedBox(height: 20),
                                        _buildLanguagesCard(eventApplyController),
                                        const SizedBox(height: 20),
                                        _buildTimePeriodCard(eventApplyController),
                                        const SizedBox(height: 20),
                                        _buildNotesCard(eventApplyController),
                                        const SizedBox(height: 20),
                                        Card(elevation: 1, child: _buildAgreementCard(eventApplyController)) ,
                                        const SizedBox(height: 30),
                                        _buildSubmitButton(eventApplyController),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                

                                
//                                 NavigationBarWidget(
//   initialActiveIndex: 0,
//   onTabChanged: (index) {
//     print('Tab changed to: $index');
//   },
// ),

// // Or use the floating version
// FloatingNavigationBarWidget(
//   initialActiveIndex: 0,
//   onTabChanged: (index) {
//     // Handle tab change
//   },
// ),
                                // Container(
                                //   margin: EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
                                //   child: EventBottomNavigation(),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.indigo,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "طلب التقديم",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "املأ البيانات للتقديم على الفعالية",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.indigo.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: 50,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildJobSelectionCard(EventApplyController controller) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildAnimatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.work_outline,
                          color: Colors.blue.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "الوظيفة المطلوبة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<JobsController>(
                    init: JobsController(Get.find()),
                    builder: (jobsController) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            height: 56,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            primaryColor: Colors.grey.shade600,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          dropdownStyle: DropdownStyle(
                            color: Colors.white,
                            elevation: 8,
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: jobsController.jobs
                              .asMap()
                              .entries
                              .map(
                                (item) => DropdownItem<JobModel?>(
                                  value: item.value,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      item.value.name!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        controller.errors['job'],
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguagesCard(EventApplyController controller) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildAnimatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.language,
                          color: Colors.green.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "اللغات المتقنة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<LanguagesController>(
                    init: LanguagesController(Get.find()),
                    builder: (languageController) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller.errors.containsKey('language')
                                ? Colors.red.shade300
                                : Colors.grey.shade300,
                          ),
                          color: Colors.grey.shade50,
                        ),
                        child: CustomDropdown<LanguageModel>.multiSelect(
                          decoration: CustomDropdownDecoration(
                            closedBorderRadius: BorderRadius.circular(12),
                            expandedBorderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'اختر اللغات',
                          items: languageController.languages.toList(),
                          initialItems: controller.languages.toList(),
                          onListChanged: (value) => 
                              controller.setSelectedLanguages(value),
                        ),
                      );
                    },
                  ),
                  if (controller.errors.containsKey('language') && 
                      controller.errors['language'] != "")
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        controller.errors['language'],
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimePeriodCard(EventApplyController controller) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildAnimatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.schedule,
                          color: Colors.orange.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "اختيار الفترة الزمنية",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (controller.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    Column(
                      children: controller.event!.periods!
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        var period = entry.value;
                        
                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, animValue, child) {
                            return Transform.scale(
                              scale: animValue,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: controller.periodId == period.id
                                      ? Colors.indigo.shade50
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: controller.periodId == period.id
                                        ? Colors.indigo.shade300
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () => controller.setSelectEventPeriod(period.id),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Row(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller.periodId == period.id
                                              ? Colors.indigo
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: controller.periodId == period.id
                                                ? Colors.indigo
                                                : Colors.grey.shade400,
                                            width: 2,
                                          ),
                                        ),
                                        child: controller.periodId == period.id
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
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
                          },
                        );
                      }).toList(),
                    ),
                  if (controller.errors.containsKey('period') && 
                      controller.errors['period'] != "")
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        controller.errors['period'],
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesCard(EventApplyController controller) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildAnimatedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.note_add_outlined,
                          color: Colors.purple.shade600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "ملاحظات إضافية",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.shade50,
                    ),
                    child: EasyAppTextFormField(
                      required: false,
                      multiline: 4,
                      maxLength: 200,
                      onSave: (value) => controller.others = value!,
                      labelText: "اكتب ملاحظاتك هنا...",
                      hintText: "",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAgreementCard(EventApplyController controller) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: _buildAnimatedCard(
              child: Column(
                children: [
                  _buildCheckboxTile(
                    value: controller.terms,
                    onChanged: () => controller.toggleTerms(),
                    title: "موافق على الشروط والأحكام للفعالية",
                    icon: Icons.assignment_outlined,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 16),
                  _buildCheckboxTile(
                    value: controller.promise,
                    onChanged: () => controller.togglePromise(),
                    title: "أتعهد أن كافة بياناتي صحيحة",
                    icon: Icons.verified_outlined,
                    color: Colors.indigo,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required VoidCallback onChanged,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? color : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              color: value ? color : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: value ? FontWeight.w600 : FontWeight.w400,
                  color: value ? color : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(EventApplyController controller) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1100),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap: () {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                controller.apply();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo.shade600,
                    Colors.indigo.shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child:  Obx(() =>   Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (applyController.isLoading)
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                          if (applyController.isLoading)
                                            const SizedBox(width: 15),
                                          Text(
                                            applyController.isLoading
                                                ? "${"SEND_REQUEST".tr}..."
                                                : "SEND_REQUEST".tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )) ,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
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