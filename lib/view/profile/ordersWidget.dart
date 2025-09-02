import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';

// THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
int activeStep = 5; // Initial step set to 5.
int upperBound = 6; // upperBound MUST BE total number of icons minus 1.

Widget myOrder(int status) => Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 10.0),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: .06)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "399",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: BLACK_COLOR),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 30,
                  width: .5,
                  color: Color.fromRGBO(153, 154, 154, 1)),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تاريخ الطلبية : 01/01/2021",
                    style: TextStyle(fontSize: 12, color: BLACK_COLOR),
                  ),
                  Text(
                    "العنوان : بيت حماي",
                    style: TextStyle(fontSize: 12, color: BLACK_COLOR),
                  ),
                ],
              )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 30,
                  width: .5,
                  color: Color.fromRGBO(153, 154, 154, 1)),
              Icon(Icons.exit_to_app, color: Colors.orange, size: 20)
            ],
          ),
          SizedBox(height: 20),
          customStepper(status)
        ],
      ),
    );
List status = [
  "قيد الطلب",
  "قيد التجهيز",
  "جاهز للتوصيل",
  "جاري التوصيل",
  "تم الاستلام"
];
Widget customStepper(int statuss) => Column(
      children: [
        Column(
          children: List.generate(
            5,
            (index) => stepperStep(status[index], statuss, index),
          ),
        )
        // stepperStep("قيد الطلب"),
        // stepperStep("قيد التجهيز"),
        // stepperStep("جاهز للتوصيل"),
        // stepperStep("جاري التوصيل"),
        // stepperStep("تم الاستلام"),
      ],
    );
Widget stepperStep(String title, int status, int index) => Row(
      children: [
        Flexible(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all((status >= index + 1) ? 2 : 0),
              decoration: BoxDecoration(
                color:
                    (status >= index + 1) ? SUCCESS_COLOR : Colors.transparent,
                border: Border.all(
                    width: .3,
                    color: (status >= index + 1)
                        ? Colors.transparent
                        : Colors.black),
                shape: BoxShape.circle,
              ),
              child: (status >= index + 1)
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 17,
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7),
                      child: Text(
                        "${index + 1}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.purple, fontSize: 11),
                      ),
                    ),
            ),
            if (index < 4)
              Container(
                  margin: EdgeInsets.symmetric(
                      vertical: (status >= index + 1) ? 2 : 0),
                  height: 14,
                  width: .8,
                  color: Color.fromRGBO(153, 154, 154, 1)),
          ],
        )),
        SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
