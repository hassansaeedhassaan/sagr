import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sagr/data/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class App {
  BuildContext? _context;
  double? _height;
  double? _width;
  double? _heightPadding;
  double? _widthPadding;

  App(_context) {
    this._context = _context;
    MediaQueryData queryData = MediaQuery.of(this._context!);
    _height = queryData.size.height / 100.0;
    _width = queryData.size.width / 100.0;
    _heightPadding =
        _height! - ((queryData.padding.top + queryData.padding.bottom) / 100.0);
    _widthPadding =
        _width! - (queryData.padding.left + queryData.padding.right) / 100.0;
  }

  double appHeight(double v) {
    return _height! * v;
  }

  double appWidth(double v) {
    return _width! * v;
  }

  double appVerticalPadding(double v) {
    return _heightPadding! * v;
  }

  double appHorizontalPadding(double v) {
    return _widthPadding! * v;
  }
}

class Colors {
  Color _mainColor = Color(0xFF009DB5);
  Color _mainDarkColor = Color(0xFF22B7CE);
  Color _secondColor = Color(0xFF04526B);
  Color _secondDarkColor = Color(0xFFE7F6F8);
  Color _accentColor = Color(0xFFADC4C8);
  Color _accentDarkColor = Color(0xFFADC4C8);

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }
}

class SharedData {


  Future<void> appLaunchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }


    Future<void> appLaunchEmail(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }


  void showAlert(context, message){
      Flushbar(
      // title: "Hey Ninja",
      titleColor: WHITE_COLOR,
      // message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      // backgroundColor: Colors.red,
      boxShadows: [BoxShadow(color: const Color.fromARGB(255, 0, 0, 0), offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      // backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: false,
      duration: Duration(seconds: 4),
      icon: Icon(
        Icons.check,
        color: MAZ_GREEN,
      ),
     
      showProgressIndicator: false,
      // progressIndicatorBackgroundColor: Colors.blueGrey,
      // titleText: Text(
      //   "Hello Hero",
      //   style: TextStyle(
      //       fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.yellow[600], fontFamily: "ShadowsIntoLightTwo"),
      // ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 18.0, color: MAZ_GREEN, fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context);
  }

  void showAlertError(context, message){
      Flushbar(
        
      // title: "Hey Ninja",
      titleColor: WHITE_COLOR,
      // message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Color.fromARGB(255, 214, 9, 9),
      boxShadows: [BoxShadow(color: const Color.fromARGB(255, 0, 0, 0), offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      // backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: false,
      duration: Duration(seconds: 4),
      icon: Icon(
        Icons.check,
        color: WHITE_COLOR,
      ),
     
      showProgressIndicator: false,
      // progressIndicatorBackgroundColor: Colors.blueGrey,
      // titleText: Text(
      //   "Hello Hero",
      //   style: TextStyle(
      //       fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.yellow[600], fontFamily: "ShadowsIntoLightTwo"),
      // ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 18.0, color: WHITE_COLOR, fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context);
  }


    void showMessage(context, {required String message, Color? color}){


      showToastWidget(
        position: StyledToastPosition.top,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            color: color!= null ? color :  ZAHRA_RED.withOpacity(0.9),
          ),
          child: Row(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: WHITE_COLOR,
                ),
              ),
              //  IconButton(
              //      onPressed: () {
              //          ToastManager().dismissAll(showAnim: true);
              //          Navigator.push(context,
              //              MaterialPageRoute(builder: (context) {
              //              return CardsScreen(Get.find());
              //          }));
              //      },
              //      icon: Icon(
              //          Icons.add_circle_outline_outlined,
              //          color: Colors.white,
              //      ),
              //  ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        context: context,
        isIgnoring: false,
        duration: Duration(milliseconds: 5000),
      );
    }

}

