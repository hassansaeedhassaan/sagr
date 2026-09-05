import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sagr/data/colors.dart';

/// Single source of truth for the app's visual identity.
///
/// Unifies the previously inconsistent styling (73% hardcoded colors, a unused
/// pink template ColorScheme) around the SAGR brand: teal [SAGR_SECONDARY] +
/// navy [SAGR_PRIMARY]. Wiring `AppTheme.light` into `GetMaterialApp` upgrades
/// every Material-default widget (app bars, buttons, inputs, dialogs, cards,
/// chips, snackbars, FABs, progress) at once — compact and premium.
class AppTheme {
  const AppTheme._();

  // ---- Brand tokens ----
  static const Color brand = SAGR_SECONDARY; // teal  #06987d
  static const Color brandDark = Color(0xff047d66);
  static const Color navy = SAGR_PRIMARY; // navy  #0f172a
  static const Color sky = SAGR_THIRD; // #0ea5e9

  static const Color scaffold = Color(0xfff5f7f8);
  static const Color surface = Color(0xffffffff);
  static const Color field = Color(0xffeef1f4);
  static const Color line = Color(0xffe4e8ec);

  static const Color textTitle = Color(0xff0f172a);
  static const Color textBody = Color(0xff1f2937);
  static const Color textMuted = Color(0xff667085);
  static const Color textHint = Color(0xff98a2b3);

  static const Color danger = Color(0xffef4444);
  static const Color success = Color(0xff22c55e);
  static const Color warning = Color(0xfff59e0b);

  static const String _font = 'URW';

  // ---- Shared shape tokens ----
  static const double radiusSm = 10;
  static const double radius = 14;
  static const double radiusLg = 20;

  // ---- Status bar styles ----
  // Transparent bar so it adopts the app-bar/page color behind it (premium,
  // edge-to-edge). Icons flip with brightness so it's correct in light & dark.
  static const SystemUiOverlayStyle statusBarLight = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android: dark icons
    statusBarBrightness: Brightness.light, // iOS: dark icons
  );
  static const SystemUiOverlayStyle statusBarDark = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // Android: light icons
    statusBarBrightness: Brightness.dark, // iOS: light icons
  );

  static const ColorScheme _scheme = ColorScheme.light(
    primary: brand,
    onPrimary: Colors.white,
    primaryContainer: Color(0xffd6f2ec),
    onPrimaryContainer: brandDark,
    secondary: navy,
    onSecondary: Colors.white,
    surface: surface,
    onSurface: textTitle,
    background: scaffold,
    onBackground: textTitle,
    error: danger,
    onError: Colors.white,
    outline: line,
  );

  static ThemeData get light => ThemeData(
        useMaterial3: false,
        fontFamily: _font,
        colorScheme: _scheme,
        primaryColor: brand,
        scaffoldBackgroundColor: scaffold,
        canvasColor: surface,
        splashColor: brand.withOpacity(0.08),
        highlightColor: brand.withOpacity(0.04),
        visualDensity: VisualDensity.compact,
        iconTheme: const IconThemeData(color: textTitle, size: 22),
        dividerTheme: const DividerThemeData(
          color: line,
          thickness: 0.7,
          space: 0.7,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          foregroundColor: textTitle,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: textTitle),
          titleTextStyle: TextStyle(
            fontFamily: _font,
            color: textTitle,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
          systemOverlayStyle: statusBarLight,
        ),

        textSelectionTheme: TextSelectionThemeData(
          cursorColor: brand,
          selectionColor: brand.withOpacity(0.25),
          selectionHandleColor: brand,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: brand,
            foregroundColor: Colors.white,
            disabledBackgroundColor: textHint.withOpacity(0.4),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            textStyle: const TextStyle(
              fontFamily: _font,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: brand,
            minimumSize: const Size(0, 48),
            side: const BorderSide(color: brand, width: 1.3),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            textStyle: const TextStyle(
              fontFamily: _font,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: brand,
            textStyle: const TextStyle(
              fontFamily: _font,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: brand,
          foregroundColor: Colors.white,
          elevation: 2,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: field,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: const TextStyle(color: textHint, fontSize: 15),
          labelStyle: const TextStyle(color: textMuted, fontSize: 15),
          prefixIconColor: textMuted,
          suffixIconColor: textMuted,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: brand, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: danger, width: 1.2),
          ),
        ),

        cardTheme: CardTheme(
          color: surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
            side: const BorderSide(color: line),
          ),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: field,
          selectedColor: brand.withOpacity(0.14),
          labelStyle: const TextStyle(
            color: textBody,
            fontWeight: FontWeight.w500,
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),

        dialogTheme: DialogTheme(
          backgroundColor: surface,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          titleTextStyle: const TextStyle(
            fontFamily: _font,
            color: textTitle,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          contentTextStyle: const TextStyle(
            fontFamily: _font,
            color: textBody,
            fontSize: 15,
          ),
        ),

        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLg)),
          ),
        ),

        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: navy,
          contentTextStyle: const TextStyle(
            fontFamily: _font,
            color: Colors.white,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),

        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: brand,
        ),

        listTileTheme: const ListTileThemeData(
          iconColor: textMuted,
          horizontalTitleGap: 12,
        ),

        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected) ? brand : Colors.white,
          ),
          trackColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected)
                ? brand.withOpacity(0.45)
                : textHint.withOpacity(0.4),
          ),
        ),

        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            (s) =>
                s.contains(MaterialState.selected) ? brand : Colors.transparent,
          ),
          checkColor: MaterialStateProperty.all(Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          side: const BorderSide(color: textHint, width: 1.4),
        ),

        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected) ? brand : textHint,
          ),
        ),

        tabBarTheme: const TabBarTheme(
          labelColor: brand,
          unselectedLabelColor: textMuted,
          indicatorColor: brand,
          dividerColor: Colors.transparent,
        ),
      );
}
