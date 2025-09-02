import 'package:flutter/material.dart';

import '../../../data/colors.dart';
import '../../../data/constants.dart';

class TextareaFormField extends StatelessWidget {
  final Function(String? val)? onSave;
  // final Function(dynamic val)? onValidate;
  String? Function(String? val)? onValidate;

  final String labelText;
  final String hintText;
  final String initialValue;

  TextareaFormField(
      {Key? key,
      this.onSave,
      this.onValidate,
      required this.labelText,
      required this.hintText,
      required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: const Border(
              right: const BorderSide(width: 0, color: PRIMARY_COLOR))),
      child: TextFormField(
        maxLines: 4,
        initialValue: initialValue,
        onSaved: onSave,
        validator: onValidate,
        keyboardType: TextInputType.text,
        style: TextStyle(color: BLACK_COLOR, fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            filled: false,
            // fillColor: FILL_COLOR,
            isDense: true,
            // prefixIcon: Icon(
            //   Icons.lock,
            //   color: Color(0xff3d77bc),
            // ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(const Radius.circular(8.0)),
                borderSide:
                    const BorderSide(color: GREY_COLOR, width: 1)),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 207, 206, 206), width: 1.0),
              borderRadius: BorderRadius.all(const Radius.circular(8.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 207, 206, 206), width: 1.0),
              borderRadius: BorderRadius.all(const Radius.circular(8.0)),
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
