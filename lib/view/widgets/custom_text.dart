import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  // final Color color;
  final String text;
  // final double font;
  final TextStyle? style;

  const CustomText({Key? key, this.text = "", this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(fontFamily: "TJB"),
    );
  }
}
