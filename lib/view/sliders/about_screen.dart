import 'package:flutter/material.dart';

import '../../data/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE_COLOR,
        appBar: AppBar(
          // automaticallyImplyLeading: true,
          toolbarHeight: 80,
          title: Text(
            "من نحن",
            style: TextStyle(
                fontSize: 20, height: 1.6, fontWeight: FontWeight.bold),
          ),
          backgroundColor: WHITE_COLOR,
          foregroundColor: BLACK_COLOR,
          elevation: 0,
          // actions: <Widget>[
          //   new ShoppingCartButtonWidget(
          //       iconColor: Theme.of(context).primaryColor,
          //       labelColor: Theme.of(context).colorScheme.primary),
          // ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
      
              decoration: BoxDecoration(
                color: MAZ_GREEN.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                children: [

                  Text("متجر ماز", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
                  // Image.asset("assets/images/lemon.png", height: 48, width: 212),
                  // Container(
                  
                  //   child: SvgPicture.asset('assets/icons/w-logo.svg',),
                  // ),
                  SizedBox(height: 20),
                  Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                  Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى ",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                  Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                  Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى ",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                  Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق ",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                 
                ],
              ),
              ),
        ));
  }
}
