import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';

class ElegantExitDialog extends StatefulWidget {
  const ElegantExitDialog({Key? key}) : super(key: key);

  @override
  State<ElegantExitDialog> createState() => _ElegantExitDialogState();
}

class _ElegantExitDialogState extends State<ElegantExitDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );
    _iconController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFBFE),
              Color(0xFFF8F9FF),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة متحركة
            ScaleTransition(
              scale: _iconAnimation,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      SAGR_PRIMARY,
                      SAGR_PRIMARY,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: SAGR_PRIMARY.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // العنوان
            Text(
              'Exit App'.tr, // استبدل بـ 'Exit App'.tr
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),

            // الرسالة
            Text(
              'Are you sure you want to exit the app?'.tr, // استبدل بـ .tr
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF718096),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // الأزرار
            Row(
              children: [
                // زر الإلغاء
                Expanded(
                  child: _DialogButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    text: 'Cancel'.tr, // استبدل بـ 'Cancel'.tr
                    isPrimary: false,
                  ),
                ),
                const SizedBox(width: 12),

                // زر الخروج
                Expanded(
                  child: _DialogButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    text: 'Exit'.tr, // استبدل بـ 'Exit'.tr
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isPrimary;

  const _DialogButton({
    required this.onPressed,
    required this.text,
    required this.isPrimary,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: widget.isPrimary
              ? const LinearGradient(
                  colors: [SAGR_PRIMARY, SAGR_PRIMARY],
                )
              : null,
          color: widget.isPrimary ? null : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.isPrimary
                        ? SAGR_PRIMARY.withOpacity(0.3)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: widget.isPrimary ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: widget.isPrimary ? Colors.white : const Color(0xFF718096),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}