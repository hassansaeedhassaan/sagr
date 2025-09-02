import 'dart:ui';
// import 'package:eltikia_s_application6/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import 'theme_helper.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillGray => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray10001,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h!!),
        ),
      );
  static ButtonStyle get fillOnPrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h!!),
        ),
      );
  static ButtonStyle get fillOnPrimaryTL12 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h!!),
        ),
      );
  static ButtonStyle get fillOrange => ElevatedButton.styleFrom(
        backgroundColor: appTheme.orange400.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h!!),
        ),
      );
  static ButtonStyle get fillTealA => ElevatedButton.styleFrom(
        backgroundColor: appTheme.tealA700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h!!),
        ),
      );
  static ButtonStyle get fillTealATL8 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.tealA700.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
      );

  // Gradient button style
  static BoxDecoration get gradientPrimaryToOrangeDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(12.h),
        gradient: LinearGradient(
          // begin: Alignment(0.0, 1),
          end: Alignment(1.0, 1),
          colors: [
            // theme.colorScheme.primary,
            // appTheme.orange400,
Color(0xff0B0B0C),
            Color(0xff0B0B0C)

          ],
        ),
      );
  static BoxDecoration get gradientPrimaryToOrangeTL8Decoration =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(8.h!!),
        gradient: LinearGradient(
          begin: Alignment(0.0, 1),
          end: Alignment(1.0, 1),
          colors: [
            theme.colorScheme.primary,
            appTheme.orange400,
          ],
        ),
      );
  static BoxDecoration get gradientSecondaryContainerToOrangeDecoration =>
      BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            8.h!!,
          ),
          topRight: Radius.circular(
            8.h!!,
          ),
          bottomLeft: Radius.circular(
            8.h!!,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment(0.0, 1),
          end: Alignment(1.0, 1),
          colors: [
            theme.colorScheme.secondaryContainer,
            appTheme.orange400.withOpacity(0.1),
          ],
        ),
      );
  static BoxDecoration get gradientSecondaryContainerToOrangeTL12Decoration =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(12.h!!),
        gradient: LinearGradient(
          // begin: Alignment(0.0, 1),
          end: Alignment(1.0, 1),
          colors: [
            theme.colorScheme.secondaryContainer,
            appTheme.orange400.withOpacity(0.1),
          ],
        ),
      );

  // Outline button style
  static ButtonStyle get outlineOrange => OutlinedButton.styleFrom(
        backgroundColor: appTheme.orange400.withOpacity(0.1),
        side: BorderSide(
          color: appTheme.orange400,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h!!),
        ),
      );
  static ButtonStyle get outlineOrange1 => OutlinedButton.styleFrom(
        backgroundColor: appTheme.orange400.withOpacity(0.1),
        side: BorderSide(
          color: appTheme.orange400,
          width: 1,
        ),
        shape: RoundedRectangleBorder(),
      );
  static ButtonStyle get outlinePinkTL8 => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: appTheme.pink600,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h!!),
        ),
      );
  static ButtonStyle get outlineTealA => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: appTheme.tealA70001,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h!!),
        ),
      );
  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
      );
}
