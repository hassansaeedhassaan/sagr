import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:sagr/data/colors.dart';
import 'package:get/get.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';

import '../../../home/presentation/screens/home_screen.dart';

class EventAcceptScreen extends StatelessWidget {
  const EventAcceptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(
      init: EventController(Get.find()),
      builder: (EventController eventController){

      return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1, //70 for bottom

            child: Stack(
              children: [
                Container(
                  height: 260.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/cover.jpg"))),
                ),
                Positioned(
                    top: 80,
                    child: Container(
                      padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                      child: Icon(
                        Icons.arrow_back,
                        color: WHITE_COLOR,
                      ),
                    )),
                Positioned(
                  top: 235.0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 240,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        shape: BoxShape.rectangle,
                        color: WHITE_COLOR,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                   
                                    Text("${eventController.event!.name}"),
                                    Text("${eventController.event!.date}", style: TextStyle(color: GREY_COLOR, fontSize: 12),)
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: Icon(Icons.arrow_forward_ios),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                    // height: 90,
                                    // width: 90,
                                    child: CustomPaint(
                                  // painter: BorderPainter(),
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    // width: BarReaderSize.width,
                                    height: BarReaderSize.height + 40,

                                    decoration: BoxDecoration(
                                       boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 0,
                                    child: Material(
                                      color: WHITE_COLOR,
                                      borderRadius: BorderRadius.circular(12),
                                      elevation: 10,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    90,
                                                padding: EdgeInsets.fromLTRB(
                                                    30, 20, 30, 20),
                                                decoration: BoxDecoration(
                                                    // color: GREY_COLOR
                                                    //     .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    
                                                    
                                                   
                                      
                                         
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: WHITE_COLOR,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12)),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("الرقم الوظيفي "),
                                                          Flexible(
                                                              child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    BLACK_COLOR,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                            child: Text(
                                                              eventController.event!.nationalID.toString(),
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                      WHITE_COLOR),
                                                            ),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                      
                                                    SizedBox(height: 15),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4,
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: WHITE_COLOR,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12)),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("الزون"),
                                                          Flexible(
                                                              child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    BLACK_COLOR,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                            child: Text(
                                                              "3",
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color:
                                                                      WHITE_COLOR),
                                                            ),
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                      
                                                    // SizedBox(height: 40,),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),


SizedBox(height: 20,),
                                // Center(
                                //   child: Container(
                                //     width:
                                //         MediaQuery.of(context).size.width - 90,
                                //     padding:
                                //         EdgeInsets.fromLTRB(30, 20, 30, 20),
                                //     decoration: BoxDecoration(
                                //         color: GREY_COLOR.withOpacity(0.3),
                                //         borderRadius:
                                //             BorderRadius.circular(20)),
                                //     child: Column(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       children: [
                                //         Row(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.center,
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             Text("تاريخ مباشرة العمل", style: TextStyle(),),
                                //             Text("22/03/2025",      style: TextStyle(fontSize: 12),)
                                //           ],
                                //         ),
                                //         SizedBox(
                                //           height: 30,
                                //         ),
                                //         Row(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.center,
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             Text("ساعات العمل"),
                                //             Text(
                                //               "08:00 AM - 05:00 PM",
                                //               textDirection: TextDirection.ltr,
                                //                     style: TextStyle(fontSize: 12),
                                //             )
                                //           ],
                                //         ),

                                //         SizedBox(height: 30),
                                //         Row(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.center,
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             Text("المبلغ المقدم"),
                                //             Text(
                                //               "500 ريال",
                                //               textDirection: TextDirection.rtl,
                                //               style: TextStyle(fontSize: 12),
                                //             )
                                //           ],
                                //         ),

                                //         // SizedBox(height: 40,),
                                //       ],
                                //     ),
                                //   ),
                                // ),

                       

                                Container(
                                  child: Image.asset(
                                    'assets/images/sagr-logo.png',
                                    width: 140,
                                  ),
                                ),

                                SizedBox(height: 20),

                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: TimerCountdown(
                                    daysDescription: "Days".tr,
                                    secondsDescription: "Seconds".tr,
                                    minutesDescription: "Minutes".tr,
                                    hoursDescription: "Hours".tr,
                                    format: CountDownTimerFormat
                                        .daysHoursMinutesSeconds,
                                    endTime: DateTime.now().add(
                                      Duration(
                                        days: 5,
                                        hours: 14,
                                        minutes: 27,
                                        seconds: 34,
                                      ),
                                    ),
                                    onEnd: () {
                                      print("Timer finished");
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                          Container(
                            decoration: BoxDecoration(
                                color: GREY_COLOR.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(14)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [Icon(Icons.list), Text("القائمة")],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.spoke_rounded),
                                    Text("الإعلانات")
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: GREY_COLOR,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(Icons.celebration_outlined),
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.notifications),
                                    Text("التنبيهات")
                                  ],
                                ),
                                Column(
                                  children: [Icon(Icons.chat), Text("الدردشة")],
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
            // child: Stack(

            //   children: [

            //     Positioned(
            //       top: 0,
            //       bottom: 0, // to shift little up
            //       left: 0,
            //       right: 0,
            //       child: Container(
            //         alignment: Alignment.topCenter,
            //         decoration: const BoxDecoration(
            //           color: Colors.amber,
            //           borderRadius: BorderRadius.vertical(
            //             bottom: Radius.circular(20),
            //           ),
            //         ),
            //         width: constraints.maxWidth,

            //         height: 300,

            //         child: Image.asset("assets/images/cover.jpg", height: 220, fit: BoxFit.cover,),
            //       ),
            //     ),

            //     Positioned(
            //       top: 180,
            //       bottom: 0, // to shift little up
            //       left: 0,
            //       right: 0,
            //       child: Container(
            //         decoration: const BoxDecoration(
            //           color: Color.fromARGB(255, 29, 29, 27),
            //           borderRadius: BorderRadius.vertical(
            //             top: Radius.circular(20),
            //           ),
            //         ),
            //         width: constraints.maxWidth,
            //         // height: constraints.maxHeight * 0.6,
            //       ),
            //     ),

            //     // Positioned(
            //     //   top: constraints.maxHeight * .4,
            //     //   height: 400,
            //     //   left: 0,
            //     //   right: 0,
            //     //   child: ClipRRect(
            //     //     borderRadius: BorderRadius.circular(24),
            //     //     child: Card(
            //     //       child: Container(
            //     //         color: Colors.red,
            //     //       ),
            //     //     ),
            //     //   ),
            //     // ),

            //   ],
            // ),
          ),
        ),
      ),
    );
    });
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select an Option',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.link),
            title: Text('Copy Link'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
