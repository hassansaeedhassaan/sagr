

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/colors.dart';
import '../../widgets/price.dart';

Widget totalWidget() => Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.8),
              spreadRadius: 20,
              blurRadius: 10,
              offset: Offset(0, 3))
        ],
        // color: Colors.white,
        gradient: LinearGradient(
          // tileMode: TileMode.decal,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // begin: const Alignment(0.0, 0.0),
          // end: const Alignment(0.0, 0.0),
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter,
          colors: [
            Color(0xffffffff).withOpacity(0.1),
            Color(0xffffffff).withOpacity(0.6),
            Color(0xffffffff).withOpacity(0.8),
            Color(0xffffffff).withOpacity(0.9),
            Color(0xffffffff).withOpacity(0.9),
            Color(0xffffffff).withOpacity(0.9),
            Color(0xffffffff).withOpacity(0.9),
            Color(0xffffffff).withOpacity(1.0),

            // Colors.white,

            // Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('مجموع المنتجات'),
              Price(price: "204.55", priceFontSize: 12.0),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تكلفة التوصيل'),
              Price(price: "40.00", priceFontSize: 12.0),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المجموع الكلي'),
              Price(price: "244.55", priceFontSize: 12.0),
            ],
          ),
          SizedBox(height: 15),
          roundedBtn((() => Get.toNamed('/login')))
        ],
      ),
    );
Widget roundedBtn(Function()? onTap) => InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: PURPLE_COLOR,
            border: Border.all(width: .2, color: Colors.black)),
        child: Text("التالي",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

Widget totalText(String title, String money) => Row(
      children: [
        Text(title),
        Spacer(),
        Text(
          "$money ريال",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );

Widget payment() => Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: .06)),
      child: Row(
        children: [
          Image.asset("assets/images/logo.png", width: 40),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 30,
              width: .5,
              color: Color.fromRGBO(153, 154, 154, 1)),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "فيزا : 487894848*******",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Icon(
            Icons.check_circle,
            color: Colors.green,
          )
        ],
      ),
    );

Widget cash() => Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: .06)),
      child: Row(
        children: [
          Image.asset("assets/images/logo.png", width: 40),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 30,
              width: .5,
              color: Color.fromRGBO(153, 154, 154, 1)),
          Expanded(
            child: Text(
              "نقدا للمرسل",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 13),
            ),
          ),
          SizedBox(width: 15),
          Icon(
            Icons.check_circle,
            color: Colors.grey,
          )
        ],
      ),
    );

Widget addressDelivery() => Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: .06)),
      child: Row(
        children: [
          Image.asset("assets/images/logo.png", width: 40),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 30,
              width: .5,
              color: Color.fromRGBO(153, 154, 154, 1)),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "بيت حماي",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Icon(
            Icons.check_circle,
            color: Colors.green,
          )
        ],
      ),
    );

Widget homeDelivery() => Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: .06)),
      child: Row(
        children: [
          Image.asset("assets/images/logo.png", width: 40),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: 30,
              width: .5,
              color: Color.fromRGBO(153, 154, 154, 1)),
          Expanded(
            child: Text(
              "استلام ذاتي",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 13),
            ),
          ),
          SizedBox(width: 15),
          Icon(
            Icons.check_circle,
            color: Colors.grey,
          )
        ],
      ),
    );
