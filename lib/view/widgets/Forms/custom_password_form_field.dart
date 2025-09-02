
import 'package:flutter/material.dart';

import '../../../data/colors.dart';

class CustomPasswordFormField extends StatelessWidget {
  final Function()? onChangeTextSecure;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final Function(String? val)? onSave;
  final String? Function(String? val)? onValidate;

   CustomPasswordFormField(
      {Key? key,
      this.onSave,
      this.onValidate,
      this.labelText,
      this.hintText,
      this.obscureText = true,
      this.onChangeTextSecure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      
            child: TextFormField(

              onSaved: onSave,
              validator: onValidate,
              obscureText: obscureText,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  filled: false,
                  fillColor: FILL_COLOR,
                  isDense: true,
                  // suffixIcon: GestureDetector(
                  //   child: Icon(
                  //       obscureText ? Icons.visibility : Icons.visibility_off),
                  //   onTap: onChangeTextSecure,
                  // ),
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
            ),
          );
  }
}
