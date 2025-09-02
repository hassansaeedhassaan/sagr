import 'package:flutter/material.dart';

import '../../../../data/colors.dart';

class LabelTextFormField extends StatelessWidget {

  final String text;
  final bool required;

  const LabelTextFormField({
    Key? key, required this.text,
     this.required = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: BLACK_COLOR),
        children: [
          TextSpan(text: text),
          required ? TextSpan(
            text: '*',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xffEF3939),
                fontFamily: "TJ",
                height: 0.5),
          ) : TextSpan(),
        ],
      ),
    );
  }
}
