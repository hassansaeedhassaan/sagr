import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/view/profile/Total/totalWidgets.dart';

import '../../../data/colors.dart';
import '../../widgets/Breadcrumb.dart';
import '../../widgets/fixed_app_bottom_bars.dart';
import '../../widgets/price.dart';

class TotalPage extends StatefulWidget {
  @override
  _TotalPageState createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Stack(
        children: [
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
              child: Breadcrumb()),
          Container(
            margin: EdgeInsets.only(top: 50),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  20, 0, 20, MediaQuery.of(context).size.width * .5),
              children: [
                Text("طريقة الدفع",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      checkoutBox(
                          onPress: () => Get.dialog(AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              content: Container(
                                // alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    minHeight: 300, maxHeight: 500),
                                color: BLACK_COLOR.withOpacity(0.4),
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //     image: DecorationImage(
                                    //       image: AssetImage('images/new_york.jpg'),
                                    //       fit: BoxFit.fitHeight,
                                    //     ),
                                    //   ),
                                    // ),
                                    Positioned(
                                        // top: 50.0,

                                        // left: 10.0,
                                        // right: 10.0,
                                        child: Container(
                                            // height: 400.0,
                                            // width: 600.0,
                                            width: double.infinity,
                                            color: Colors.white,
                                            // elevation: 8.0,
                                            // shape: RoundedRectangleBorder(
                                            //   borderRadius:
                                            //       BorderRadius.circular(8.0),
                                            // ),
                                            child: Column(children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  "العنوان",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Container(
                                                  // height: 34.0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Container(
                                                      //       height: 32.0,
                                                      //       padding: EdgeInsets.only(
                                                      //           top: 0,
                                                      //           bottom: 6,
                                                      //           left: 10,
                                                      //           right:
                                                      //               10.0),
                                                      //       margin: EdgeInsets
                                                      //           .symmetric(
                                                      //               horizontal:
                                                      //                   2.0),
                                                      //       decoration: BoxDecoration(
                                                      //           // color: Colors
                                                      //           //     .red,
                                                      //           border: Border.all(width: 2, color: Colors.grey[400]),
                                                      //           borderRadius: BorderRadius.circular(24.0)),
                                                      //       child: TextField(
                                                      //         cursorHeight:
                                                      //             24.0,
                                                      //         cursorColor:
                                                      //             Colors.grey[
                                                      //                 400],
                                                      //         decoration: InputDecoration(
                                                      //             contentPadding:
                                                      //                 EdgeInsetsDirectional
                                                      //                     .zero,
                                                      //             isDense:
                                                      //                 true,
                                                      //             enabledBorder:
                                                      //                 InputBorder
                                                      //                     .none,
                                                      //             focusedBorder:
                                                      //                 InputBorder.none),
                                                      //       ))

                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 4, right: 4),
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          cursorColor:
                                                              Colors.grey[400],
                                                          decoration:
                                                              new InputDecoration(
                                                                  enabled: true,
                                                                  isDense: true,
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          right:
                                                                              10.0,
                                                                          bottom:
                                                                              5,
                                                                          left:
                                                                              10.0),
                                                                  border:
                                                                      new OutlineInputBorder(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      const Radius
                                                                              .circular(
                                                                          10.0),
                                                                    ),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.red),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            2.0),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  filled: true,
                                                                  hintStyle: new TextStyle(
                                                                      fontSize:
                                                                          12.0),
                                                                  hintText:
                                                                      "الاسم",
                                                                  fillColor: Colors
                                                                      .white70),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 4, right: 4),
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          cursorColor:
                                                              Colors.grey[400],
                                                          decoration:
                                                              new InputDecoration(
                                                                  enabled: true,
                                                                  isDense: true,
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          top:
                                                                              5,
                                                                          right:
                                                                              10.0,
                                                                          bottom:
                                                                              5,
                                                                          left:
                                                                              10.0),
                                                                  border:
                                                                      new OutlineInputBorder(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      const Radius
                                                                              .circular(
                                                                          10.0),
                                                                    ),
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.red),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            2.0),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  filled: true,
                                                                  hintStyle: new TextStyle(
                                                                      fontSize:
                                                                          12.0),
                                                                  hintText:
                                                                      "صورة",
                                                                  fillColor: Colors
                                                                      .white70),
                                                        ),
                                                      ),

                                                      SizedBox(height: 30),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: InkWell(
                                                          onTap: () =>
                                                              print("Submit"),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            30)),
                                                                color:
                                                                    PURPLE_COLOR,
                                                                border: Border.all(
                                                                    width: .2,
                                                                    color: Colors
                                                                        .black)),
                                                            child: Text(
                                                                "التالي",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]))),
                                    // IndexedStack(
                                    //   index: 1,
                                    //   children: [
                                    //     C
                                    //   ],
                                    // ),

                                    // Positioned(
                                    //     right: 80.0,
                                    //     child: Container(
                                    //       alignment: Alignment.center,
                                    //       width: 100.0,
                                    //       height: 100.0,
                                    //       color: Colors.amber.withOpacity(0.3),
                                    //     )),

                                    // Positioned(
                                    //     top: 25,
                                    //     child: Container(
                                    //       width: 14.0,
                                    //       height: 20.0,
                                    //       color: Colors.amber,
                                    //     )),
                                    // RaisedButton(
                                    //   child: Text('Good Login'),
                                    //   onPressed: () => Get.back(result: true),
                                    //   // ** result: returns this value up the call stack **
                                    // ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    // RaisedButton(
                                    //   child: Text('Bad Login'),
                                    //   onPressed: () => Get.back(result: false),
                                    // ),
                                  ],
                                ),
                              ))),
                          image: "assets/images/logo.png",
                          icon: Icons.credit_card,
                          title: Text("فيزا : 487894848*******",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12)),
                          hasBtn: true,
                          btnText: "تغيير العنوان",
                          isChecked: true),
                      SizedBox(width: 10),
                      checkoutBox(
                          onPress: () => print("PRINT FORM VISA WIDGET"),
                          icon: Icons.attach_money_outlined,
                          image: "assets/images/logo.png",
                          title: Text("نقداً للمرسل",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12)),
                          hasBtn: false,
                          isChecked: false),
                    ]),

                // payment(),
                // SizedBox(height: 10),
                // cash(),
                Text("طريقة التوصيل",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      checkoutBox(
                          onPress: () => print("PRINT FORM VISA WIDGET"),
                          image: "assets/images/logo.png",
                          icon: Icons.place,
                          title: Text("بيت حماي",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12)),
                          hasBtn: true,
                          btnText: "تغيير العنوان",
                          isChecked: true),
                      SizedBox(width: 10),
                      checkoutBox(
                          onPress: () => print("PRINT FORM VISA WIDGET"),
                          image: "assets/images/logo.png",
                          icon: Icons.clean_hands,
                          title: Text("إستلام ذاتي",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12)),
                          hasBtn: false,
                          isChecked: false),
                    ]),

                Text("طريقة الاستلام",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      checkoutBox(
                          onPress: () => print("PRINT FORM VISA WIDGET"),
                          image: "assets/images/logo.png",
                          icon: Icons.delivery_dining,
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "اسم المستلم: محمد فرج",
                                style: TextStyle(fontSize: 12.0),
                              ),
                              // Text(
                              //   "رقم الهاتف: 0528733713 ",
                              //   style: TextStyle(fontSize: 12.0),
                              // )
                            ],
                          ),
                          hasBtn: true,
                          hasIcon: false,
                          btnText: "تغيير المستلم",
                          isChecked: true),
                      SizedBox(width: 10),
                      checkoutBox(
                          onPress: () => print("PRINT FORM VISA WIDGET"),
                          image: "assets/images/logo.png",
                          icon: Icons.headset_mic,
                          title: Text("إستلام ذاتي",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12)),
                          hasBtn: false,
                          hasIcon: false,
                          isChecked: false),
                    ]),

                Text("طريقة التغليف",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      checkoutBoxWrap(
                          onPress: () => print("PRINT FORM VISA WIDGET"),
                          image: "assets/images/logo.png",
                          icon: Icons.card_giftcard,
                          title: Text("بدون تغليف",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12)),
                          price: "0",
                          isChecked: true),
                      SizedBox(width: 10),
                      checkoutBoxWrap(
                          onPress: () => print("PRINT FORM VISA WIDGET"),
                          image: "assets/images/logo.png",
                          icon: Icons.card_giftcard,
                          title: Text("تغليف بريميوم",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12)),
                          price: "30",
                          isChecked: false),
                      SizedBox(width: 10),
                      checkoutBoxWrap(
                          onPress: () => print("PRINT FORM VISA WIDGET"),
                          image: "assets/images/logo.png",
                          icon: Icons.card_giftcard,
                          price: "60",
                          title: Text("تغليف جولد",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12)),
                          isChecked: false),
                    ]),
                // addressDelivery(),
                // SizedBox(height: 0),
                // homeDelivery(),
              ],
            ),
          ),
          Positioned(bottom: 0, right: 0, left: 0, child: totalWidget())
        ],
      ),
    );
  }
}

Widget checkoutBoxWrap(
        {required String? image,
        required Widget? title,
        String price = "0",
        IconData? icon,
        bool isChecked = true,
        bool hasIcon = true,
        Function()? onPress}) =>
    Expanded(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          if (hasIcon)
            Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.check_circle,
                  color: isChecked ? Colors.orange : Colors.grey[400],
                )),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 15),
            constraints: BoxConstraints(minHeight: 132, maxHeight: 134),
            decoration: BoxDecoration(
                // color: Colors.black,
                border: Border.all(color: Colors.black, width: .06)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(image, width: 60),
                Icon(
                  icon,
                  size: 36,
                  color: PURPLE_COLOR.withOpacity(0.8),
                ),
                SizedBox(
                  height: 5,
                ),
                title!,
                SizedBox(
                  height: 5,
                ),
                Price(price: price)
              ],
            ),
          )
        ],
      ),
    );

Widget checkoutBox(
        {required String? image,
        required Widget? title,
        bool hasBtn = false,
        IconData? icon,
        String btnText = "",
        bool isChecked = true,
        bool hasIcon = true,
        Function()? onPress}) =>
    Expanded(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          if (hasIcon)
            Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.check_circle,
                  color: isChecked ? Colors.orange : Colors.grey[400],
                )),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 15),
            constraints: BoxConstraints(minHeight: 132, maxHeight: 134),
            decoration: BoxDecoration(
                // color: Colors.black,
                border: Border.all(color: Colors.black, width: .06)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: PURPLE_COLOR.withOpacity(0.8),
                ),
                SizedBox(
                  height: 5,
                ),
                title!,
                SizedBox(
                  height: 5,
                ),
                if (hasBtn)
                  GestureDetector(
                    onTap: onPress,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color: PURPLE_COLOR,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Text(
                        btnText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );

Widget cash() => Expanded(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned(
              top: 10,
              right: 10,
              child: Icon(
                Icons.check_circle,
                color: Colors.grey,
              )),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 15),
            constraints: BoxConstraints(minHeight: 132, maxHeight: 134),
            decoration: BoxDecoration(

                // color: Colors.black,
                border: Border.all(color: Colors.black, width: .06)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png", width: 60),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "نقداً للمرسل",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
Widget checkourBoxes() =>
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )),
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 15),
              constraints: BoxConstraints(minHeight: 132, maxHeight: 134),
              decoration: BoxDecoration(
                  // color: Colors.black,
                  border: Border.all(color: Colors.black, width: .06)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png", width: 60),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "فيزا : 487894848*******",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: PURPLE_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      "تغيير العنوان",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.grey,
                )),
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 15),
              constraints: BoxConstraints(minHeight: 132, maxHeight: 134),
              decoration: BoxDecoration(

                  // color: Colors.black,
                  border: Border.all(color: Colors.black, width: .06)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png", width: 60),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "نقداً للمرسل",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ]);
