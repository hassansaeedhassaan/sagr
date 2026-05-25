import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class StatusBarHelper {
  // Dark status bar with light icons
  static void setDarkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xff092941),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  // Light status bar with dark icons
  static void setLightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  // Custom status bar with color and brightness
  static void setCustomStatusBar({
    required Color color,
    required Brightness brightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness == Brightness.dark 
            ? Brightness.light 
            : Brightness.dark,
      ),
    );
  }

   static const SystemUiOverlayStyle darkStatusBar = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  // Light status bar with dark icons
  static const SystemUiOverlayStyle lightStatusBar = SystemUiOverlayStyle(
    statusBarColor: Color(0xff092941),
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  // Custom status bar
  static SystemUiOverlayStyle customStatusBar({
    required Color color,
    required Brightness brightness,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarIconBrightness: brightness,
      statusBarBrightness: brightness == Brightness.dark 
          ? Brightness.light 
          : Brightness.dark,
    );
  }

  static SystemUiOverlayStyle gradientStatusBar({
    required Brightness brightness,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness,
      statusBarBrightness: brightness == Brightness.dark 
          ? Brightness.light 
          : Brightness.dark,
    );
  }

}
