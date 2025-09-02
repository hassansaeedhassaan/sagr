import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/Breadcrumb.dart';
import '../../widgets/fixed_app_bottom_bars.dart';
import '../Total/view.dart';
import 'editProfileWidgets.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _name = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _birth = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
        body: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      children: [
        Breadcrumb(),
        SizedBox(height: 10),
        editProfileImage(() {}),
        SizedBox(height: 30),
        CustomTextField(controller: _name, hint: "الاسم الثلاثي"),
        SizedBox(height: 15),
        CustomTextField(controller: _country, hint: "البلد"),
        SizedBox(height: 15),
        CustomTextField(controller: _gender, hint: "الجنس"),
        SizedBox(height: 15),
        CustomTextField(controller: _birth, hint: "تاريخ الميلاد"),
        SizedBox(height: 30),
        btn(() => Get.to(() => TotalPage()))
      ],
    ));
  }
}
