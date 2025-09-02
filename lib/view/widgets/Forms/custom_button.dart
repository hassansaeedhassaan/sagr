import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Function()? onPress;
  final double height;
  const CustomButton({Key? key, this.text, this.onPress, this.height = 40.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
        child: ElevatedButton(

        
           
            onPressed: onPress,
            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                              backgroundColor: MAZ_GREEN,
                              foregroundColor: WHITE_COLOR,
                              elevation: 0,),
            child: CustomText(
              text: text!,
              style: TextStyle(
                height: 1.8,
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            )
            // RaisedButton(
            //   color: GetStorage().read('app_type') == 'tools' ? Color(0xffd32026): Color(0xff0A458B),
            //   shape: new RoundedRectangleBorder(
            //       borderRadius: new BorderRadius.circular(8.0)),
            //   onPressed: onPress,
            //   child: CustomText(
            //     text: text!,
            //     style: TextStyle(
            //       height: 1.8,
            //       color: Colors.white,
            //       fontSize: 18.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            ));
  }
}
