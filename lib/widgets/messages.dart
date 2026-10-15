import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sagr/theme/app_theme.dart';

// 1. Simple Dialog Message (يعمل 100%)
class CustomDialog {
  static void show({
    required String title,
    required String message,
    MessageType type = MessageType.info,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getTypeColor(type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTypeIcon(type),
                color: _getTypeColor(type),
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.4,
          ),
        ),
        actions: [
          if (onCancel != null)
            TextButton(
              onPressed: () {
                Get.back();
                onCancel();
              },
              child: Text(
                cancelText,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              if (onConfirm != null) onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getTypeColor(type),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  static Color _getTypeColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.orange;
      case MessageType.info:
        return Colors.blue;
    }
  }

  static IconData _getTypeIcon(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error;
      case MessageType.warning:
        return Icons.warning;
      case MessageType.info:
        return Icons.info;
    }
  }
}

// 2. Bottom Sheet Message (يعمل 100%)
class CustomBottomSheet {
  static void show({
    required String title,
    required String message,
    MessageType type = MessageType.info,
    VoidCallback? onAction,
    String actionText = 'تأكيد',
  }) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getTypeColor(type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTypeIcon(type),
                size: 40,
                color: _getTypeColor(type),
              ),
            ),
            SizedBox(height: 20),
            
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'إغلاق',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      if (onAction != null) onAction();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getTypeColor(type),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(actionText),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Color _getTypeColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.warning:
        return Colors.orange;
      case MessageType.info:
        return Colors.blue;
    }
  }

  static IconData _getTypeIcon(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error;
      case MessageType.warning:
        return Icons.warning;
      case MessageType.info:
        return Icons.info;
    }
  }
}

// 3. GetX Snackbar Enhanced (يعمل 100%)
/// The app's one look for transient feedback ("saved", "failed", ...):
/// a navy floating card at the bottom with a tinted icon badge, bold title
/// and muted body, plus a light haptic. Modelled on the profile-update
/// confirmation so every screen reports results the same way.
class AppNotice {
  const AppNotice._();

  static void success(String title, [String message = '']) =>
      show(title: title, message: message, type: MessageType.success);

  static void error(String title, [String message = '']) =>
      show(title: title, message: message, type: MessageType.error);

  static void warning(String title, [String message = '']) =>
      show(title: title, message: message, type: MessageType.warning);

  static void info(String title, [String message = '']) =>
      show(title: title, message: message, type: MessageType.info);

  static void show({
    required String title,
    String message = '',
    MessageType type = MessageType.info,
    VoidCallback? onTap,
    int duration = 3,
  }) {
    // One at a time: a new result replaces the last instead of stacking.
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    switch (type) {
      case MessageType.success:
        HapticFeedback.mediumImpact();
        break;
      case MessageType.error:
        HapticFeedback.heavyImpact();
        break;
      default:
        HapticFeedback.selectionClick();
    }

    final accent = _accent(type);
    final body = message.trim();

    Get.rawSnackbar(
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      borderRadius: 16,
      backgroundColor: AppTheme.navy,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.18),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
      duration: Duration(seconds: duration),
      animationDuration: const Duration(milliseconds: 350),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      isDismissible: true,
      dismissDirection: DismissDirection.down,
      onTap: onTap != null ? (_) => onTap() : null,
      messageText: Row(
        crossAxisAlignment:
            body.isEmpty ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon(type), color: accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'URW',
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'URW',
                      color: Colors.white.withOpacity(0.78),
                      fontSize: 13,
                      height: 1.4,
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

  static Color _accent(MessageType type) {
    switch (type) {
      case MessageType.success:
        return AppTheme.success;
      case MessageType.error:
        return AppTheme.danger;
      case MessageType.warning:
        return AppTheme.warning;
      case MessageType.info:
        return AppTheme.sky;
    }
  }

  static IconData _icon(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Icons.check_circle_rounded;
      case MessageType.error:
        return Icons.error_rounded;
      case MessageType.warning:
        return Icons.warning_amber_rounded;
      case MessageType.info:
        return Icons.info_rounded;
    }
  }
}

/// Kept for existing callers; renders as [AppNotice].
class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    MessageType type = MessageType.info,
    VoidCallback? onTap,
    int duration = 3,
  }) =>
      AppNotice.show(
          title: title,
          message: message,
          type: type,
          onTap: onTap,
          duration: duration);
}

/// Kept for existing callers; renders as [AppNotice] (message only).
class CustomToast {
  static void show({
    required String message,
    MessageType type = MessageType.info,
    int duration = 3,
  }) =>
      AppNotice.show(title: message, type: type, duration: duration);
}

// Message Types
enum MessageType {
  success,
  error,
  warning,
  info,
}

// Easy Helper Class
class MessageHelper {
  // Dialog Messages
  static void showSuccessDialog({
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    CustomDialog.show(
      title: title,
      message: message,
      type: MessageType.success,
      onConfirm: onConfirm,
    );
  }

  static void showErrorDialog({
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) {
    CustomDialog.show(
      title: title,
      message: message,
      type: MessageType.error,
      onConfirm: onConfirm,
    );
  }

  // Bottom Sheet Messages
  static void showSuccessBottomSheet({
    required String title,
    required String message,
    VoidCallback? onAction,
  }) {
    CustomBottomSheet.show(
      title: title,
      message: message,
      type: MessageType.success,
      onAction: onAction,
    );
  }

  static void showErrorBottomSheet({
    required String title,
    required String message,
    VoidCallback? onAction,
  }) {
    CustomBottomSheet.show(
      title: title,
      message: message,
      type: MessageType.error,
      onAction: onAction,
    );
  }

  // Snackbar Messages
  static void showSuccessSnackbar({
    required String title,
    required String message,
    VoidCallback? onTap,
  }) {
    CustomSnackbar.show(
      title: title,
      message: message,
      type: MessageType.success,
      onTap: onTap,
    );
  }

  static void showErrorSnackbar({
    required String title,
    required String message,
    VoidCallback? onTap,
  }) {
    CustomSnackbar.show(
      title: title,
      message: message,
      type: MessageType.error,
      onTap: onTap,
    );
  }

  // Toast Messages
  static void showSuccessToast(String message) {
    CustomToast.show(
      message: message,
      type: MessageType.success,
    );
  }

  static void showErrorToast(String message) {
    CustomToast.show(
      message: message,
      type: MessageType.error,
    );
  }

  static void showWarningToast(String message) {
    CustomToast.show(
      message: message,
      type: MessageType.warning,
    );
  }

  static void showInfoToast(String message) {
    CustomToast.show(
      message: message,
      type: MessageType.info,
    );
  }
}
