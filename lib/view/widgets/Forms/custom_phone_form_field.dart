import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/colors.dart';

class CustomPhoneFormField extends StatelessWidget {


  final Function(String? val)? onSave;
 final  String? initialValue; 
   CustomPhoneFormField({Key? key, this.onSave, this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: initialValue ??"",
        onSaved: onSave,
        keyboardType: TextInputType.phone,
        validator: (value) {

     
          if (value == null) {
            return "field_required";
          } else {
            return null;
          }

          // String pattern = "^(05)(5|0|3|6|4|9|1|8|7)([0-9]{7})";
          // RegExp regExp = new RegExp(pattern);
          // var potentialNumber = int.tryParse(value!);
          // if (potentialNumber == null) {
          //   return "field_required";
          // } else if (!regExp.hasMatch(value)) {
          //   return "phone_no_not_correct";
          // } else {
          //   return null;
          // }
        },
        decoration: InputDecoration(
          // filled: true,
          // fillColor: Colors.white,
          // isDense: false,
          // prefixIcon: Container(
          //   width: 50.0,
          //   margin: EdgeInsets.all(5.0),
          //   decoration: BoxDecoration(
          //       border: Border.all(color: Colors.white),
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(10.0),
          //           bottomLeft: Radius.circular(10.0))),
          //   child: Center(
          //     child: Text("+966",
          //         textDirection: TextDirection.ltr,
          //         style:
          //             TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          //   ),
          // ),
          // prefixText: "las",
          // prefix: Container(
          //   width: 60.0,
          //   child: Text("+966"),
          // ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Colors.transparent, width: 1)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: GREY_COLOR.withOpacity(0.4), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          labelText: "phone".tr,
          hintText: "enter_phone",
          icon: null,
        ));
  }
}
