import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/features/notifications/live/live_notifications.dart';
import 'package:sagr/theme/app_theme.dart';

/// Wraps a bell with the live unread count; nothing when there is none.
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final Offset offset;

  const NotificationBadge({
    super.key,
    required this.child,
    this.offset = const Offset(-6, -6),
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = LiveNotifications.to.unread.value;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (count > 0)
            PositionedDirectional(
              top: offset.dy,
              end: offset.dx,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppTheme.danger,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
