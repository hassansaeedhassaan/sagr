import 'package:flutter/material.dart';

class button_widgets extends StatelessWidget {
  String? label;
  Function? onPressed;
  IconData? icon;
  Color? color;
  button_widgets({
    this.icon,
    this.label,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 30,
      margin: EdgeInsets.only(top: 10),

      child: TextButton.icon(
        onPressed: () {},
        label: Text(
          "اضف للسله",
          style: TextStyle(
            fontSize: 11,
            height: 1.5,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        icon: Icon(
          Icons.shopping_cart,
          color: Color.fromARGB(255, 255, 255, 255),
          size: 18,
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xff11BBD5)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ))),
      ),
    );
  }
}

// class Button_Widget extends StatefulWidget {
//   String? text;
//   Color? color;
//   IconData? icon;
//   VoidCallback? function;
//   Button_Widget({this.color, this.function, this.icon, this.text});

//   @override
//   State<Button_Widget> createState() => _Button_WidgetState();
// }

// class _Button_WidgetState extends State<Button_Widget> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Button_Widget(
//           color: Colors.amber,
//           text: "s",
//         ),
//       ],
//     );
//   }
// }
