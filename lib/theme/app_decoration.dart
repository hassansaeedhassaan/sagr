import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import 'theme_helper.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray10001,
      );
  static BoxDecoration get fillGray50 => BoxDecoration(
        color: appTheme.gray50,
      );
  static BoxDecoration get fillGray5001 => BoxDecoration(
        color: appTheme.gray5001,
      );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static BoxDecoration get fillOnPrimary1 => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillSecondaryContainer => BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
      );
  static BoxDecoration get fillTealA => BoxDecoration(
        color: appTheme.tealA700,
      );

  // Gradient decorations
  static BoxDecoration get gradientPrimaryToOrange => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.11, -0.23),
          end: Alignment(1.09, 1.21),
          colors: [
            theme.colorScheme.primary,
            appTheme.orange400,
          ],
        ),
      );
  static BoxDecoration get gradientSecondaryContainerToOrange => BoxDecoration(
        gradient: LinearGradient(
          // begin: Alignment(0, 1),
          end: Alignment(1, 1),
          colors: [
            theme.colorScheme.secondaryContainer,
            appTheme.orange400.withOpacity(0.1),
          ],
        ),
      );

  // Linear decorations
  static BoxDecoration get linear => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 1),
          end: Alignment(1, 1),
          colors: [
            theme.colorScheme.primary,
            appTheme.orange400,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.04),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border.all(
          color: appTheme.gray300,
          width: 1.h!,
        ),
      );
  static BoxDecoration get outlineOrange => BoxDecoration(
        color: appTheme.orange400.withOpacity(0.1),
        border: Border.all(
          color: appTheme.orange400,
          width: 1.h!,
        ),
      );
  static BoxDecoration get outlinePrimary => BoxDecoration(
        color: appTheme.gray10001,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h!,
        ),
      );
  static BoxDecoration get outlinePrimary1 => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h!,
        ),
      );
  static BoxDecoration get outlinePrimary2 => BoxDecoration(
        color: appTheme.pink50,
      );

  // White decorations
  static BoxDecoration get white => BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.15),
            spreadRadius: 2.h!,
            blurRadius: 2.h!,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder1 => BorderRadius.circular(
        1.h!,
      );
  static BorderRadius get circleBorder21 => BorderRadius.circular(
        21.h!,
      );
  static BorderRadius get circleBorder24 => BorderRadius.circular(
        24.h!,
      );
  static BorderRadius get circleBorder45 => BorderRadius.circular(
        45.h!,
      );

  // Custom borders
  static BorderRadius get customBorderBL12 => BorderRadius.vertical(
        bottom: Radius.circular(12.h!),
      );
  static BorderRadius get customBorderBL8 => BorderRadius.only(
        topRight: Radius.circular(8.h!),
        bottomLeft: Radius.circular(8.h!),
        bottomRight: Radius.circular(8.h!),
      );
  static BorderRadius get customBorderTL12 => BorderRadius.vertical(
        top: Radius.circular(12.h!),
      );
  static BorderRadius get customBorderTL121 => BorderRadius.only(
        topLeft: Radius.circular(12.h!),
        topRight: Radius.circular(12.h!),
        bottomRight: Radius.circular(12.h!),
      );
  static BorderRadius get customBorderTL8 => BorderRadius.only(
        topLeft: Radius.circular(8.h!),
        topRight: Radius.circular(8.h!),
        bottomLeft: Radius.circular(8.h!),
      );

  // Rounded borders
  static BorderRadius get roundedBorder12 => BorderRadius.circular(
        12.h!,
      );
  static BorderRadius get roundedBorder16 => BorderRadius.circular(
        16.h!,
      );
  static BorderRadius get roundedBorder4 => BorderRadius.circular(
        4.h!,
      );
  static BorderRadius get roundedBorder56 => BorderRadius.circular(
        56.h!,
      );
  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8.h!,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.
    
// For Flutter SDK Version 3.7.2 or greater.
    
double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
    