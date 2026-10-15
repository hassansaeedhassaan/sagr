import 'package:flutter/widgets.dart';

/// Material icons that point a way but don't mirror themselves in RTL
/// (their IconData has no matchTextDirection). Same glyphs, mirrored in
/// Arabic. Kept const so release builds can still tree-shake the icon font.
class AppIcons {
  AppIcons._();

  static const IconData login =
      IconData(0xe3b2, fontFamily: 'MaterialIcons', matchTextDirection: true);
  static const IconData loginRounded =
      IconData(0xf88a, fontFamily: 'MaterialIcons', matchTextDirection: true);
  static const IconData logoutRounded =
      IconData(0xf88b, fontFamily: 'MaterialIcons', matchTextDirection: true);
  static const IconData logoutOutlined =
      IconData(0xf199, fontFamily: 'MaterialIcons', matchTextDirection: true);
  static const IconData exitToApp =
      IconData(0xe243, fontFamily: 'MaterialIcons', matchTextDirection: true);
  static const IconData exitToAppRounded =
      IconData(0xf71e, fontFamily: 'MaterialIcons', matchTextDirection: true);
}
