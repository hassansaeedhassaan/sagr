import 'package:flutter/material.dart';
import 'package:sagr/view/widgets/bottom_navigation_bar.dart';

class MasterWrapper extends StatelessWidget {
  final Widget body;

  final PreferredSizeWidget? appBar;

  MasterWrapper({Key? key, required this.body, this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8FA),
      appBar: appBar,
      body: SafeArea(child: body),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
