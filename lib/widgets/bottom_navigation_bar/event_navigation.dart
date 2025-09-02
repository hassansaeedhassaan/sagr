import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/walkie_talkie/screens/walkie_talkie.dart';
import 'package:sagr/walkie_talkie/screens/walkie_talkie_screen_2.dart';

import '../../data/colors.dart';

class EventBottomNavigation extends StatelessWidget {
  const EventBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 47, 47, 47).withOpacity(0.4),
          borderRadius: BorderRadius.circular(14)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.toNamed('/attendance_screen'),
            child: Column(
              children: [
                Icon(
                  Icons.person_3_outlined,
                  color: Color.fromARGB(93, 0, 255, 17),
                  size: 30,
                ),
                Text("الحضور والإنصراف", textAlign: TextAlign.center, style: TextStyle(color: Color.fromARGB(93, 0, 255, 17)),)
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => WalkieTalkieScreen(appId: "3aa7d0944ad240e4acc7bff3e6a59a5f", channelName: "testing2025", token: "007eJxTYHhQ787gqW365KJ9onR/IEshX/gK53D+jYLcBUdq11vJHVVgME5MNE8xsDQxSUwxMjFINUlMTjZPSkszTjVLNLVMNE3b41mV0RDIyMAdHs7IyACBYD5DSWpxSWZeupGBkSkDAwAFBR3q", userId: 2,)),
            child: Column(
              children: [
                Icon(
                  Icons.phone_in_talk,
                  color: Color(0xFF00ff00),
                  size: 30,
                ),
                Text("Walkie Talkie", style: TextStyle(color: Color(0xFF00ff00), fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => WalkieTalkieScreen2()),
            child: Column(
              children: [
                Icon(
                  Icons.notifications,
                  color: Color.fromARGB(93, 0, 255, 17),
                  size: 30,
                ),
                Text("التنبيهات", style: TextStyle(color: Color.fromARGB(93, 0, 255, 17)),)
              ],
            ),
          ),
          Column(
            children: [
              Icon(
                Icons.chat,
                color: Color.fromARGB(93, 0, 255, 17),
                size: 30,
              ),
              Text("الدردشة", style: TextStyle(color: Color.fromARGB(93, 0, 255, 17)),)
            ],
          ),
        ],
      ),
    );
  }
}
