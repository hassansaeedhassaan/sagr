import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sagr/theme/app_theme.dart';

/// Visual style for an application status. Single source of truth for the
/// colors/icons/labels used across every event surface (cards, detail, lists).
class EventStatusStyle {
  final Color color;
  final IconData icon;
  final String label;

  const EventStatusStyle(this.color, this.icon, this.label);
}

EventStatusStyle eventStatusStyle(String? status) {
  switch (status) {
    case 'accepted':
      return EventStatusStyle(
          AppTheme.success, Icons.check_circle_rounded, 'accepted'.tr);
    case 'initAccept':
      return EventStatusStyle(
          AppTheme.warning, Icons.verified_outlined, 'initAccept'.tr);
    case 'pending':
      return EventStatusStyle(
          AppTheme.warning, Icons.schedule_rounded, 'pending'.tr);
    case 'rejected':
      return EventStatusStyle(
          AppTheme.danger, Icons.cancel_rounded, 'rejected'.tr);
    default:
      return const EventStatusStyle(
          AppTheme.brand, Icons.arrow_forward_rounded, 'تقديم');
  }
}

/// Compact, premium status pill driven by [eventStatusStyle].
class EventStatusPill extends StatelessWidget {
  final String? status;
  final VoidCallback? onTap;
  final bool compact;

  const EventStatusPill({
    super.key,
    required this.status,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = eventStatusStyle(status);

    final pill = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: s.color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: compact ? 13 : 15, color: s.color),
          const SizedBox(width: 5),
          Text(
            s.label,
            style: TextStyle(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w700,
              color: s.color,
              height: 1,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return pill;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: pill,
    );
  }
}

/// Opens an event. Every application status lands on the journey screen,
/// which shows the stage tracker and the next action for that status.
/// Shared by the card status pill and list rows so navigation stays consistent.
void openEventByStatus(int? id, String? status) {
  Get.toNamed('/event_details', arguments: id, preventDuplicates: true);
}
