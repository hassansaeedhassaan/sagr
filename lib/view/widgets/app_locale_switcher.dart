import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/theme/app_theme.dart';

import '../../utilities/localizations/app_language.dart';

/// Compact, premium language switcher: a rounded pill (globe + current
/// language) that opens a clean popup menu to pick Arabic / English.
class AppLocaleSwitcher extends StatelessWidget {
  const AppLocaleSwitcher({Key? key}) : super(key: key);

  static const _langs = [
    ('ar', 'العربية', '🇸🇦'),
    ('en', 'English', '🇬🇧'),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppLanguage>(
      init: AppLanguage(),
      builder: (controller) {
        final current = controller.appLocale == 'en' ? 'en' : 'ar';
        final label = current == 'en' ? 'English' : 'العربية';

        return PopupMenuButton<String>(
          tooltip: '',
          offset: const Offset(0, 46),
          color: AppTheme.surface,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            side: const BorderSide(color: AppTheme.line),
          ),
          onSelected: (value) {
            controller.changeLanguage(value);
            Get.updateLocale(Locale(value));
          },
          itemBuilder: (_) => [
            for (final l in _langs) _menuItem(l.$1, l.$2, l.$3, l.$1 == current),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.field,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language_rounded,
                    size: 18, color: AppTheme.brand),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textBody,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 18, color: AppTheme.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<String> _menuItem(
      String value, String label, String flag, bool selected) {
    return PopupMenuItem<String>(
      value: value,
      height: 44,
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppTheme.brand : AppTheme.textBody,
            ),
          ),
          const Spacer(),
          if (selected)
            const Icon(Icons.check_rounded, size: 18, color: AppTheme.brand),
        ],
      ),
    );
  }
}
