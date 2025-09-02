import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/colors.dart';
import '../../../data/constants.dart';

class EasyAppTextFormField extends StatelessWidget {
  final Function(String? val)? onSave;

  final Function(String? val)? onChanged;

  // final Function(dynamic val)? onValidate;
  final String? Function(String? val)? onValidate;

  final String labelText;

  final String? hintText;

  final bool? enable;
  
  final bool? required;

  final int? multiline;

  final EdgeInsets? padding;
  final Border? border;

  final TextInputType? textInputType;

  final String? initialValue;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  EasyAppTextFormField(
      {Key? key,
      this.onSave,
      this.onChanged,
      this.onValidate,
      this.enable,
      this.required,
      this.textInputType,
      this.multiline,
      this.padding,
      this.border,
      this.suffixIcon,
      this.prefixIcon,
      required this.labelText,
      this.hintText,
      this.inputFormatters,
      this.maxLength,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        inputFormatters: inputFormatters ?? [],
        maxLength: maxLength ?? null,
        // enabled: enable,
        // textDirection: TextDirection.rtl,
        initialValue: initialValue ?? "",
        onSaved: onSave,
        onChanged: onChanged,
        validator: onValidate,

        maxLines: multiline ?? 1,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        keyboardType: textInputType ?? TextInputType.text,
        decoration: InputDecoration(
            contentPadding: padding != null ? padding : EdgeInsets.all(12),
            filled: false,
            fillColor: FILL_COLOR,
            isDense: true,
            suffixIcon: suffixIcon ?? null,
            prefixIcon: prefixIcon ?? null,
            label: RichText(
                text: TextSpan(
                    text: labelText,
                    style: const TextStyle(
                        fontFamily: "URWD",
                        color: Color.fromARGB(255, 141, 141, 141)),
                    children: [
                  TextSpan(
                      text: required != false ? ' *': '',
                      style: TextStyle(
                        color: Colors.red,
                      ))
                ])),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.transparent, width: 1)),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: GREY_COLOR.withOpacity(0.4), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: const Color.fromARGB(255, 92, 55, 52), width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            // labelText: labelText,
            labelStyle: const TextStyle(
                fontFamily: FONT_FAMILY,
                // color: const Color(0xff000000),
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
