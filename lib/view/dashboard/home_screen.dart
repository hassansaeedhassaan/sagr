import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/app/view_model/settings/setting_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../data/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: true,
            // toolbarHeight: 70,
            title: Text(
              "الرئيسية",
              style: TextStyle(
                  fontSize: 20, height: 1.6, fontWeight: FontWeight.bold),
            ),
            backgroundColor: WHITE_COLOR,
            foregroundColor: BLACK_COLOR,
            elevation: 0,
            automaticallyImplyLeading: false,
            // actions: <Widget>[
            //   new ShoppingCartButtonWidget(
            //       iconColor: Theme.of(context).primaryColor,
            //       labelColor: Theme.of(context).colorScheme.primary),
            // ],
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
                  GetBuilder<SettingController>(
                      init: SettingController(),
                      builder: (SettingController controller) {
                        return controller.isLoading
                            ? CircularProgressIndicator()
                            : GridView.count(
                                mainAxisSpacing: 5.0,
                                crossAxisSpacing: 5.0,
                                // physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                children: controller.setting.statistics!
                                    .map((player) => Container(
                                          decoration: BoxDecoration(
                                              color: WHITE_COLOR,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: BLACK_COLOR
                                                      .withOpacity(0.4),
                                                  spreadRadius: 0.001,
                                                  blurRadius: 1,
                                                  offset: Offset(0,
                                                      0.3), // changes position of shadow
                                                )
                                              ]),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    player['count'].toString()),
                                                Text(player['text'])
                                              ]),
                                        ))
                                    .toList(),
                              );
                      })
                  //  Image.asset("assets/images/gad-logo.jpeg", height: 48, width: 212),
                ],
              ),
            ),
          )),
    );
  }
}
