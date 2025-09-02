import 'package:flutter/material.dart';

import '../../data/colors.dart';

AppBar CommonAppBar({String? title}) {
  return AppBar(
        automaticallyImplyLeading: true,
        toolbarHeight: 80, // Set this height
        title: Text(
          title!,
          style:
              TextStyle(fontSize: 20, height: 1.6, fontWeight: FontWeight.bold),
        ),
        backgroundColor: WHITE_COLOR,
        foregroundColor: BLACK_COLOR,
        elevation: 0,
      );
}
