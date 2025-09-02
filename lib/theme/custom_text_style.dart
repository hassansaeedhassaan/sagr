import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeErrorContainer => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get bodyLargeGray60001 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray60001,
      );
  static get bodyLargeJFFlatPrimary =>
      theme.textTheme.bodyLarge!.jFFlat.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 18.fSize,
      );
  static get bodyLargeNunitoSans =>
      theme.textTheme.bodyLarge!.nunitoSans.copyWith(
        fontSize: 18.fSize,
      );
  static get bodyLargeTealA700 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.tealA700,
      );
  static get bodyLargeff828282 => theme.textTheme.bodyLarge!.copyWith(
        color: Color(0XFF828282),
      );
  static get bodyMediumBluegray900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray900,
      );
  static get bodyMediumBluegray90002 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray90002,
      );
  static get bodyMediumErrorContainer => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get bodyMediumGray500 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray500,
      );
  static get bodyMediumGray50001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray50001,
      );
  static get bodyMediumGray60001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray60001,
      );
  static get bodyMediumNunitoSansOnPrimary =>
      theme.textTheme.bodyMedium!.nunitoSans.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static get bodyMediumOrange400 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.orange400,
      );
  static get bodyMediumRed500 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.red500,
      );
  static get bodyMediumff292d32 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFF292D32),
      );
  static get bodyMediumff333333 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFF333333),
      );
  static get bodyMediumff363333 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFF363333),
      );
  static get bodyMediumff828282 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFF828282),
      );
  static get bodyMediumffd20653 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFFD20653),
      );
  static get bodySmall10 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 10.fSize,
      );
  static get bodySmallBluegray90001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodySmallGray500 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray500,
      );
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 10.fSize,
      );
  static get bodySmallOrange400 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.orange400,
        fontSize: 10.fSize,
      );
  static get bodySmallOrange400_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.orange400,
      );
  static get bodySmallPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodySmallff828282 => theme.textTheme.bodySmall!.copyWith(
        color: Color(0XFF828282),
      );
  // Headline text style
  static get headlineSmallNunitoSansOnPrimary =>
      theme.textTheme.headlineSmall!.nunitoSans.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static get headlineSmallff333333 => theme.textTheme.headlineSmall!.copyWith(
        color: Color(0XFF333333),
      );
  // Label text style
  static get labelLargeGray600 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeGray60001 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray60001,
      );
  static get labelLargeOnPrimary => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontWeight: FontWeight.w500,
      );
  static get labelLargePrimary => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  // Title text style
  static get titleLargeNunitoSansOnPrimaryContainer =>
      theme.textTheme.titleLarge!.nunitoSans.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeOnPrimary => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static get titleLargePoppins => theme.textTheme.titleLarge!.poppins.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleLargePrimary => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleLargePrimarySemiBold => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeff333333 => theme.textTheme.titleLarge!.copyWith(
        color: Color(0XFF333333),
      );
  static get titleLargeffd20653 => theme.textTheme.titleLarge!.copyWith(
        color: Color(0XFFD20653),
      );
  static get titleMedium16 => theme.textTheme.titleMedium!.copyWith(
   
        fontSize: 16.fSize,
        fontFamily: 'URWD'
      );

        static get titleMedium14 => theme.textTheme.titleMedium!.copyWith(
   
        fontSize: 14.fSize,
          fontFamily: 'URWD'
      );

  static get titleMediumBluegray900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray900,
      );
  static get titleMediumBluegray90001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray90001.withOpacity(0.49),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumBluegray9000116 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 16.fSize,
      );
  static get titleMediumBluegray90001Medium =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumBluegray90001Medium_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray90001,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumBluegray90001SemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumBluegray90001SemiBold_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray90001,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumBluegray90001_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray90001,
      );
  static get titleMediumBluegray900Medium =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray900,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumErrorContainer => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumErrorContainerMedium =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumMedium => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOnErrorContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer,
        fontWeight: FontWeight.w500,
         fontFamily: 'URWD'
      );
  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontSize: 16.fSize,
      );
  static get titleMediumOnPrimarySemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumOnPrimary_1 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontFamily: 'URWD'
      );

  static get titleMediumOrange400 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.orange400,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPink60001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.pink60001,
        fontSize: 16.fSize,
      );
  static get titleMediumPink60001SemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.pink60001,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumPink60001_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.pink60001,
      );
  static get titleMediumSemiBold => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleMediumTealA70001 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.tealA70001,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumff0ec784 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF0EC784),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumff333333 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF333333),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumff363333 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF363333),
      );
  static get titleMediumff4f4f4f => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF4F4F4F),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumff828282 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF828282),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumffd20653 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFFD20653),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
      );
  static get titleMediumffd20653SemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFFD20653),
        fontWeight: FontWeight.w600,
      );
  static get titleMediumffd30b51 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFFD30B51),
      );
  static get titleMediumffffffff => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFFFFFFFF),
      );
  static get titleSmallBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleSmallGray800 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallOnPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      );
  static get titleSmallOnPrimarySemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallOrange400 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.orange400,
      );
  static get titleSmallPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallPrimary_1 => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary,
          fontFamily: 'URWD'
      );
  static get titleSmallSemiBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleSmallTealA70001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.tealA70001,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallff333333 => theme.textTheme.titleSmall!.copyWith(
        color: Color(0XFF333333),
      );
  static get titleSmallff333333SemiBold => theme.textTheme.titleSmall!.copyWith(
        color: Color(0XFF333333),
        fontWeight: FontWeight.w600,
      );
  static get titleSmallffd20653 => theme.textTheme.titleSmall!.copyWith(
        color: Color.fromARGB(255, 120, 120, 120),
      );
}

extension on TextStyle {
  TextStyle get jFFlat {
    return copyWith(
      fontFamily: 'URWD',
    );
  }

  TextStyle get nunitoSans {
    return copyWith(
      fontFamily: 'Nunito Sans',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

}
