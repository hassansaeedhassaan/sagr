import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
class CustomSnackbar {
  static void show({
    required String title,
    required String message,
    MessageType type = MessageType.info,
    VoidCallback? onTap,
    int duration = 4,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: _getTypeColor(type),
      colorText: Colors.white,
      borderRadius: 15,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      icon: Icon(
        _getTypeIcon(type),
        color: Colors.white,
        size: 28,
      ),
      shouldIconPulse: true,
      duration: Duration(seconds: duration),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: Duration(milliseconds: 600),
      onTap: onTap != null ? (_) => onTap() : null,
      mainButton: TextButton(
        onPressed: () => Get.closeCurrentSnackbar(),
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
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

// 4. Custom Toast Message (يعمل 100%)
class CustomToast {
  static void show({
    required String message,
    MessageType type = MessageType.info,
    int duration = 3,
  }) {
    final context = Get.context!;
    final overlay = Overlay.of(context);
    
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: _getTypeColor(type),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getTypeIcon(type),
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    Future.delayed(Duration(seconds: duration), () {
      overlayEntry.remove();
    });
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
