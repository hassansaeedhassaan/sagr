import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/app/view_model/init_controller.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sagr/data/colors.dart';

class InitView extends StatefulWidget {
  const InitView({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<InitView> createState() => _InitViewState();
}

class _InitViewState extends State<InitView> {
  @override
  void initState() {
    super.initState();

    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 5));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InitController>(
      init: InitController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.all(26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Center(
                //   child: CircularProgressIndicator(
                //     color: MAZ_GREEN,
                //   ),
                // ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Image.asset('assets/images/sagr-logo.png', width: 220),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
