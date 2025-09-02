import 'package:flutter/material.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../data/colors.dart';
import '../../widgets/ShoppingCartButtonWidget.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      
      body: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: true,
            toolbarHeight: 80,
            title: Text(
              "الشروط والاحكام",
              style: TextStyle(
                  fontSize: 20, height: 1.6, fontWeight: FontWeight.bold),
            ),
            backgroundColor: WHITE_COLOR,
            foregroundColor: BLACK_COLOR,
            elevation: 0,
            actions: <Widget>[
              new ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).colorScheme.primary),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
        
                decoration: BoxDecoration(
                  color: WHITE_COLOR,
                  borderRadius: BorderRadius.circular(12),
                ),
      
                child: Column(
                  children: [
                             Image.asset("assets/images/gad-logo.jpeg", height: 48, width: 212),
                    SizedBox(height: 20),
                    Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                    Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى ",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                    Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                    Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى ",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                    Text("هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق ",style: TextStyle(height: 1.8, color: BLACK_COLOR),),
                   
                  ],
                ),
                ),
          )),
    );
  }
}
