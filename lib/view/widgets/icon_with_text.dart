import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
          child: Icon(Icons.search),
        ),
        Container(
            child: Text("ادخل كلمة البحث للمنتج لتظهر كل المنتجات  المطلوبة"))
      ],
    );
  }
}
