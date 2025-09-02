import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData icon;
  final Color selectedColor;
  final Color unselectedColor;
  final String route;

  BottomNavItem({
    required this.icon,
    required this.selectedColor,
    required this.unselectedColor,
    required this.route,
  });
}
