import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sagr/features/notifications/data/models/notification_model.dart';
import 'package:sagr/theme/app_theme.dart';

/// One inbox row: type icon, title, body, time. Unread rows get a brand tint
/// and a dot; a chevron shows when tapping opens an event.
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = notification.is_read != true;
    final (icon, color) = _typeStyle(notification.type);
    final title = (notification.title ?? '').trim();
    final body = (notification.content ?? '').trim();

    return Material(
      color: unread ? AppTheme.brand.withOpacity(0.06) : AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            border: Border.all(
              color: unread ? AppTheme.brand.withOpacity(0.25) : AppTheme.line,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title.isNotEmpty ? title : body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.35,
                              color: AppTheme.textTitle,
                              fontWeight:
                                  unread ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.brand,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (title.isNotEmpty && body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        body.tr,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 13, color: AppTheme.textHint),
                        const SizedBox(width: 4),
                        Text(
                          formatNotificationTime(notification.created_at),
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textHint,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        if (notification.eventId != null)
                          const Icon(Icons.chevron_right_rounded,
                              size: 20, color: AppTheme.textHint),
                      ],
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
}

(IconData, Color) _typeStyle(String? type) {
  switch (type) {
    case 'success':
      return (Icons.check_circle_outline_rounded, AppTheme.success);
    case 'error':
    case 'danger':
      return (Icons.error_outline_rounded, AppTheme.danger);
    case 'warning':
      return (Icons.warning_amber_rounded, AppTheme.warning);
    default:
      return (Icons.notifications_none_rounded, AppTheme.brand);
  }
}

/// Today -> "14:05", yesterday -> "Yesterday 14:05", else "2026/10/12 14:05".
String formatNotificationTime(String? raw) {
  final parsed = raw == null ? null : DateTime.tryParse(raw);
  if (parsed == null) return raw ?? '';
  final d = parsed.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  final time = '${two(d.hour)}:${two(d.minute)}';

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = today.difference(day).inDays;

  if (diff == 0) return time;
  if (diff == 1) return '${'Yesterday'.tr} $time';
  return '${d.year}/${two(d.month)}/${two(d.day)} $time';
}
