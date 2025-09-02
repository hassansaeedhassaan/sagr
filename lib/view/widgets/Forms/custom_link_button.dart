import 'package:flutter/material.dart';
import '../custom_text.dart';

class CustomLinkButton extends StatelessWidget {
  final String? text;
  final Function()? onPress;

  const CustomLinkButton({Key? key, this.text, this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: CustomText(
            text: text!, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        onPressed: onPress,
      ),
    );
  }
}
