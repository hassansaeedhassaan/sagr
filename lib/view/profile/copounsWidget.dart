import 'package:flutter/material.dart';

Widget couponWidget(int index) => Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.only(bottom: 15),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: .06)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "27",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              width: .5,
              color: Color.fromRGBO(153, 154, 154, 1)),
          Icon(
            Icons.qr_code_outlined,
            size: 50,
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
                "تاريخ الصلاحية : 01/01/2021",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "التفاصيل : توصيل مجاني",
                style: TextStyle(fontSize: 12),
              ),
            ],
          )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 30,
              width: .5,
              color: Color.fromRGBO(153, 154, 154, 1)),
          Icon(Icons.check_circle,
              color: index == 0 ? Colors.grey : Colors.green, size: 25)
        ],
      ),
    );
