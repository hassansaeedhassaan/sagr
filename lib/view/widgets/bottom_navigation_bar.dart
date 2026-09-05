import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/app/view_model/auth/account_controller.dart';
import 'package:sagr/theme/app_theme.dart';

/// Premium, compact bottom navigation shell shown on every primary screen.
/// Active tab expands into a teal pill (icon + label); inactive tabs are
/// icon-only for a clean, modern look. Routing/index logic preserved.
class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({Key? key}) : super(key: key);

  final _controller = Get.put(AccountController(Get.find()));

  static const _routes = ['/home', '/ads', '/sagr_chat', '/more'];

  int get _currentIndex {
    final i = _routes.indexOf(Get.currentRoute);
    return i < 0 ? 0 : i;
  }

  void _onTap(BuildContext context, int i) {
    if (Get.currentRoute == _routes[i]) return;
    if (i == 3) _controller.userInfo();
    Navigator.pushNamedAndRemoveUntil(context, _routes[i], (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, 'Home'.tr),
      (Icons.storefront_rounded, 'Advertisements'.tr),
      (Icons.chat_rounded, 'Chat'.tr),
      (Icons.menu_rounded, 'More'.tr),
    ];
    final current = _currentIndex;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.navy,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.navy.withOpacity(0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < items.length; i++)
            _NavItem(
              icon: items[i].$1,
              label: items[i].$2,
              selected: i == current,
              onTap: () => _onTap(context, i),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 16 : 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? AppTheme.brand : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? Colors.white : const Color(0xff8b97a8),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              child: selected
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
