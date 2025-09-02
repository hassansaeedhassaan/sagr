import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/utilities/localizations/app_language.dart';
import 'package:get/get.dart';

import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: _buildAppBar(),
      body: GetBuilder<AppLanguage>(
        init: AppLanguage(),
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLanguageSelectionCard(context, controller),
                  const Spacer(),
                  _buildContinueButton(controller),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 77,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Image.asset(
          "assets/images/logo.png",
          width: 120,
          height: 40,
        ),
      ),
      backgroundColor: WHITE_COLOR,
      foregroundColor: BLACK_COLOR,
      elevation: 0,
    );
  }

  Widget _buildLanguageSelectionCard(BuildContext context, AppLanguage controller) {
    return Container(
      decoration: BoxDecoration(
        color: WHITE_COLOR,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Language".tr,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: BLACK_COLOR,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Please select your preferred language".tr,
            style: TextStyle(
              fontSize: 16,
              color: BLACK_COLOR.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          _buildLanguageOption(
            controller,
            locale: 'ar',
            title: 'اللغة العربية',
            subtitle: 'Arabic',
          ),
          const SizedBox(height: 16),
          _buildLanguageOption(
            controller,
            locale: 'en',
            title: 'English',
            subtitle: 'الإنجليزية',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    AppLanguage controller, {
    required String locale,
    required String title,
    required String subtitle,
  }) {
    final isSelected = controller.selectLocale == locale;
    
    return InkWell(
      onTap: () => controller.saveSelectLocale(locale),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: WHITE_COLOR,
          border: Border.all(
            width: 2,
            color: isSelected 
                ? const Color(0xffd50e50) 
                : GREY_COLOR.withOpacity(0.3),
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xffd50e50).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xffd50e50) : BLACK_COLOR,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: BLACK_COLOR.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xffd50e50) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? const Color(0xffd50e50) : GREY_COLOR.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: WHITE_COLOR,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppLanguage controller) {
    return CustomElevatedButton(
      onPressed: () {
        controller.changeLanguage(controller.selectLocale.toString());
        Get.toNamed('/login');
      },
      text: "Continue".tr,
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToOrangeDecoration,
    );
  }
}