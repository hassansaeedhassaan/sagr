import 'package:flutter/material.dart';

Widget btn(Function()? onTap) => InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.purple,
            border: Border.all(width: .2, color: Colors.black)),
        child: Text("حفظ البيانات",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

Widget editProfileImage(Function()? onEditTap) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onEditTap,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                      radius: 45.0,
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      backgroundColor: Colors.transparent),
                  PositionedDirectional(
                      end: 10,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: Icon(Icons.edit, size: 15),
                      ))
                ],
              ),
              SizedBox(height: 15),
              Text(
                "اسم المستخدم",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? type;
  final String? hint;
  final Widget? icon;
  final Function(String? val)? onTextChange;
  final int? maxLines;
  final FormFieldValidator? validator;
  CustomTextField({
    this.controller,
    this.type,
    this.hint,
    this.icon,
    this.onTextChange,
    this.maxLines,
    this.validator,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          keyboardType: widget.type,
          obscureText: false,
          autofocus: false,
          onChanged: widget.onTextChange,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: Colors.black),
          decoration: InputDecoration(
              filled: true,
              focusColor: Colors.transparent,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple, width: .1),
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              hintText: widget.hint,
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  color: Colors.black,
                  fontFamily: 'Cairo'),
              icon: widget.icon == null ? null : widget.icon,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 10))),
    );
  }
}
