import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sagr/sagr_chat/routes/app_routes.dart';
import 'package:sagr/theme/app_theme.dart';

/// Tabs exposed by [EventBottomNavigation]. Pass [EventBottomNavigation.active]
/// from the host screen to highlight the right item.
enum EventNavTab { walkieTalkie, attendance, notifications, chat }

/// Floating bottom navigation. Each tab always shows icon + label (vertical
/// stack). Active tab fills with a brand gradient pill and shows a bold white
/// label; inactive tabs stay transparent with muted text. Pass [eventId] when
/// the host screen has it so the walkie-talkie route resolves correctly.
class EventBottomNavigation extends StatelessWidget {
  final EventNavTab active;
  final String? eventId;

  const EventBottomNavigation({
    super.key,
    this.active = EventNavTab.attendance,
    this.eventId,
  });

  static const Duration _animDuration = Duration(milliseconds: 260);
  static const Curve _animCurve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppTheme.line),
            boxShadow: [
              BoxShadow(
                color: AppTheme.navy.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppTheme.navy.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavItem(
                isActive: active == EventNavTab.walkieTalkie,
                icon: Icons.phone_in_talk_rounded,
                label: 'Walkie Talkie'.tr,
                onTap: () => Get.toNamed('/event_walkie_talkie',
                    arguments: eventId ?? '0'),
              ),
              _NavItem(
                isActive: active == EventNavTab.attendance,
                icon: Icons.campaign_rounded,
                label: 'Attendance'.tr,
                onTap: () {
                  if (active != EventNavTab.attendance) {
                    Get.toNamed('/attendance_screen');
                  }
                },
              ),
              _NavItem(
                isActive: active == EventNavTab.notifications,
                icon: Icons.notifications_outlined,
                label: 'Notifications'.tr,
                onTap: () => Get.toNamed('/notifications'),
              ),
              _NavItem(
                isActive: active == EventNavTab.chat,
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat'.tr,
                onTap: () => Get.toNamed(AppRoutes.HOME),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({
    required this.isActive,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color foreground = isActive ? Colors.white : AppTheme.textMuted;

    return Expanded(
      child: AnimatedContainer(
        duration: EventBottomNavigation._animDuration,
        curve: EventBottomNavigation._animCurve,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.brand, AppTheme.brandDark],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.brand.withOpacity(0.32),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    duration: EventBottomNavigation._animDuration,
                    curve: EventBottomNavigation._animCurve,
                    scale: isActive ? 1.05 : 1.0,
                    child: Icon(icon, color: foreground, size: 22),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: EventBottomNavigation._animDuration,
                    curve: EventBottomNavigation._animCurve,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: foreground,
                      letterSpacing: 0.1,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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
