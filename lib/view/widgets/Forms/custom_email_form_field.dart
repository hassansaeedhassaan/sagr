import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';

class CustomEmailFormField extends StatelessWidget {

  final String? labelText;
  final String? hintText;

  AutovalidateMode? autovalidateMode;

String? initialValue; 

  final Function(String? val)? onSave;
  // final Function(dynamic val)? onValidate;
  final String? Function(String? val)? onValidate;

  CustomEmailFormField(
      {Key? key, this.onSave, this.onValidate, this.labelText, this.hintText, this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
    style: TextStyle(fontSize: 16),
      initialValue: initialValue??"",
      onSaved: onSave,
      validator: onValidate,
      keyboardType: TextInputType.emailAddress,
      
      decoration: InputDecoration(
        
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          // prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Colors.transparent, width: 1)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: GREY_COLOR.withOpacity(0.4), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 14),
          hintStyle: TextStyle(fontSize: 14),
          hintText: hintText,
          icon: null),
    );
  }
}
