import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/colors.dart';
import '../widgets/Forms/custom_button.dart';

class ContactusScreen extends StatelessWidget {
   ContactusScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: true,
          toolbarHeight: 80,
          title: Text(
            "تواصل معنا",
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
                color: WHITE_COLOR,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                children: [
                      //  Image.asset("assets/images/gad-logo.jpeg", height: 48, width: 212),
                                   Text("متجر ماز", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),

                  SizedBox(height: 20),
                 
                 Form(
          key: _formKey,
          child: Container(
            // height: MediaQuery.of(context).size.height - 150,
            // margin: EdgeInsets.all(20),
            // padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
                color: WHITE_COLOR,
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
               
                const SizedBox(height: 25),

                Container(
                  margin: const EdgeInsets.only(left: 4, right: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: BLACK_COLOR),
                          children: [TextSpan(text: 'الاسم ')],
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 18, height: 1),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: BLACK_COLOR,
                        onSaved: (value) =>  value!,
                        validator: (value) {
                          if (value?.length == 0) {
                            return "phone_field_required".tr;
                          } else if (value!.length < 9) {
                            return "phone_short".tr;
                          } else {
                            return null;
                          }
                        },
                        // enableInteractiveSelection: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                            isCollapsed: true,
                            enabled: true,
                            isDense: true,
                            contentPadding: const EdgeInsets.only(
                                top: 18, right: 10.0, bottom: 12, left: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffeeeeee), width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffEF3939), width: 1.0),
                            ),
                            errorStyle: TextStyle(
                                overflow: TextOverflow.fade,
                                color: Color.fromARGB(255, 204, 11, 11),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                height: 0.8),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffEF3939), width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xffeeeeee),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            hintText: "الرجاء ادخال الاسم",
                            fillColor: Colors.white70),
                      ),
                    ],
                  ),
                ),

                


                Container(
                  margin: const EdgeInsets.only(left: 4, right: 4, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: BLACK_COLOR),
                          children: [TextSpan(text: 'رقم الجوال ')],
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 18, height: 1),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: BLACK_COLOR,
                        onSaved: (value) =>  value!,
                        validator: (value) {
                          if (value?.length == 0) {
                            return "phone_field_required".tr;
                          } else if (value!.length < 9) {
                            return "phone_short".tr;
                          } else {
                            return null;
                          }
                        },
                        // enableInteractiveSelection: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                            isCollapsed: true,
                            enabled: true,
                            isDense: true,
                            contentPadding: const EdgeInsets.only(
                                top: 18, right: 10.0, bottom: 12, left: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffeeeeee), width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffEF3939), width: 1.0),
                            ),
                            errorStyle: TextStyle(
                                overflow: TextOverflow.fade,
                                color: Color.fromARGB(255, 204, 11, 11),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                height: 0.8),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffEF3939), width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xffeeeeee),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            hintText: "الرجاء ادخال رقم الجوال",
                            fillColor: Colors.white70),
                      ),
                    ],
                  ),
                ),

                

                Container(
                  margin: const EdgeInsets.only(left: 4, right: 4, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: BLACK_COLOR),
                          children: [TextSpan(text: 'رسالتك ')],
                        ),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        maxLines: 6,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 18, height: 1),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: BLACK_COLOR,
                        onSaved: (value) =>  value!,
                        validator: (value) {
                          if (value?.length == 0) {
                            return "phone_field_required".tr;
                          } else if (value!.length < 9) {
                            return "phone_short".tr;
                          } else {
                            return null;
                          }
                        },
                        // enableInteractiveSelection: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        cursorHeight: 18,
                        decoration: InputDecoration(
                            isCollapsed: true,
                            enabled: true,
                            isDense: true,
                            contentPadding: const EdgeInsets.only(
                                top: 18, right: 10.0, bottom: 12, left: 20.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffeeeeee), width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffEF3939), width: 1.0),
                            ),
                            errorStyle: TextStyle(
                                overflow: TextOverflow.fade,
                                color: Color.fromARGB(255, 204, 11, 11),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                height: 0.8),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffEF3939), width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xffeeeeee),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            hintStyle: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                            hintText: "الرجاء ادخال رسالتك",
                            fillColor: Colors.white70),
                      ),
                    ],
                  ),
                ),

                
               

               
                const SizedBox(
                  height: 30.0,
                ),

               CustomButton(text: "إرسال",onPress: () =>Get.toNamed('/more'),)
                // const SizedBox(
                //   height: 178.0,
                // ),

              ],
            ),
          ),
        ),
      
                 
                ],
              ),
              ),
        ));
  }
}
