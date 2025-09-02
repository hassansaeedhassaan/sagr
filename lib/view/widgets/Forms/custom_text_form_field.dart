import 'package:flutter/material.dart';

import '../../../data/colors.dart';
import '../../../data/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String? val)? onSave;
  // final Function(dynamic val)? onValidate;
  String? Function(String? val)? onValidate;

  final String labelText;

  final String hintText;

  final bool? enable;

  String? initialValue;

  CustomTextFormField(
      {Key? key,
      this.onSave,
      this.onValidate,
      this.enable,
      required this.labelText,
      required this.hintText,
       this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: TextFormField(
        enabled: enable,
        // textDirection: TextDirection.rtl,
        initialValue: initialValue??"",
        onSaved: onSave,
        validator: onValidate,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(

              contentPadding: EdgeInsets.all(12),
            filled: false,
            fillColor: FILL_COLOR,
            isDense: true,
            // prefixIcon: Icon(
            //   Icons.lock,
            //   color: Color(0xff3d77bc),
            // ),
            
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
            labelText: labelText,
            labelStyle: const TextStyle(
                fontFamily: FONT_FAMILY,
                color: const Color(0xff000000),
                fontWeight: FontWeight.w500),
            hintText: hintText,
            hintStyle: const TextStyle(
                fontFamily: FONT_FAMILY,
                color: BLACK_COLOR,
                fontWeight: FontWeight.w400),
            icon: null),
      ),
    );
  }
}
