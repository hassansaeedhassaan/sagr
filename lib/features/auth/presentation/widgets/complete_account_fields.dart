import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/auth/presentation/controllers/create_account_controller.dart';
import 'package:sagr/features/auth/presentation/widgets/animated_field.dart';

/// A pill-style file picker button (icon + title) used in the complete-account form.
class ModernFileUpload extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final int delay;

  const ModernFileUpload(this.title, this.icon, this.onTap, this.delay,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedField(
      delay: delay,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(0),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: SAGR_PRIMARY,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        icon,
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        )
                      ],
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
}

/// Profile-image picker; shows the picked image or a camera prompt.
class ModernImageUpload extends StatelessWidget {
  final CreateAccountController accountController;

  const ModernImageUpload(this.accountController, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedField(
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
              padding: EdgeInsets.symmetric(
                  vertical: accountController.imagePath != '' ? 10 : 40,
                  horizontal: accountController.imagePath != '' ? 10 : 30),
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
              child: accountController.imagePath != ''
                  ? Image.file(File(accountController.imagePath))
                  : Column(
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
}

/// Terms-of-use agreement checkbox with rich-text label.
class AnimatedCheckbox extends StatelessWidget {
  final CreateAccountController accountController;

  const AnimatedCheckbox(this.accountController, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedField(
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
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600
                            ],
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
}
