import 'package:flutter/material.dart';

AppBar CustomAppBar({String? title}) {
  return AppBar(
    elevation: 0,
    title: Image.asset(
      'assets/images/logo.png',
      width: 50,
    ),
    centerTitle: true,
    leading: Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Icon(
        Icons.search,
        size: 30,
      ),
    ),
    actions: [
      Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: GestureDetector(
          child: Icon(Icons.menu),
          onTap: () => print("Open Menu"),
        ),
      )
    ],
  );
}
