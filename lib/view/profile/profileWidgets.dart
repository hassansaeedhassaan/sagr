import 'package:flutter/material.dart';

Widget profileImage(Function()? onEditTap) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onEditTap,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                      radius: 45.0,
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      backgroundColor: Colors.transparent),
                  PositionedDirectional(
                      end: 10,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: Icon(Icons.edit, size: 15),
                      ))
                ],
              ),
              SizedBox(height: 15),
              Text(
                "اسم المستخدم",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );

Widget profileTabs(int index, Function()? onFirstTap, Function()? onSecondTap) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: onFirstTap,
            child: Container(
              padding: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: index == 0
                              ? Colors.orange.withOpacity(.8)
                              : Colors.transparent,
                          width: 3))),
              child: Text(
                "طلباتي",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: index == 0 ? Colors.orange : Colors.black,
                  fontWeight: index == 1 ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        // SizedBox(),
        Expanded(
          child: InkWell(
            onTap: onSecondTap,
            child: Container(
              padding: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: index == 1
                              ? Colors.orange.withOpacity(.8)
                              : Colors.transparent,
                          width: 3))),
              child: Text(
                "كوبونات",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: index == 1 ? Colors.orange : Colors.black,
                  fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )
      ],
    );

Widget appBar() => AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.purple,
        ),
        onPressed: () {},
      ),
      title: Image.asset(
        "assets/images/logo.png",
        height: 30,
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.purple,
            ),
            onPressed: () {})
      ],
    );
