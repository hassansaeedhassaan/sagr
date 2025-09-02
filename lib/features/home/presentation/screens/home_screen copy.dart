import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sagr/features/events/presentation/controllers/events_controller.dart';
import 'package:sagr/features/jobs/presentation/controllers/marital_status_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:simple_infinite_scroll/simple_infinite_scroll.dart';

import '../../../../data/colors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final SimpleInfiniteScrollController _scrollController =
      SimpleInfiniteScrollController();

  Future<List<String>> dataFetch(int page) async {
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    List<String> testList = [];
    if (page < 4) {
      for (int i = 1 + (page - 1) * 20; i <= page * 20; i++) {
        testList.add('Item$i in page$page');
      }
    }
    return testList;
  }

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: AppBar(
          title: InkWell(child:  Text("Sagr".tr), onTap:  () =>   Get.toNamed('/conversations')),
          scrolledUnderElevation: 0,
          backgroundColor: WHITE_COLOR,
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 0),
          color: WHITE_COLOR,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
// SizedBox(height: 20,),

// InkWell(
//   onTap:  () =>    Navigator.push(context,
//             MaterialPageRoute(builder: (context) => ChatScreen())),
//   child: Text("WOOOO Chat"),
// ),

              GetBuilder<JobsController>(
                  init: JobsController(Get.find()),
                  builder: (JobsController jobController) {
                    return jobController.isLoading
                        ? CircularProgressIndicator()
                        : Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                  // color: PURPLE_COLOR,
                                  ),
                              // height: 160,
                              child: ListView.builder(
                                  itemExtent: 140,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: jobController.jobs.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withValues(alpha: 0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: WHITE_COLOR,
                                        borderRadius: BorderRadius.circular(8),
                                        elevation: 3,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.sign_language),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(jobController.jobs
                                                  .elementAt(index)
                                                  .name
                                                  .toString())
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ));
                  }),

              // Expanded(
              //     flex: 1,
              //     child: Container(
              //       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              //       decoration:
              //           BoxDecoration(
              //             // color: PURPLE_COLOR,
              //             ),
              //       // height: 160,
              //       child: ListView.builder(
              //           itemExtent: 140,
              //           scrollDirection: Axis.horizontal,
              //           itemCount: 8,
              //           itemBuilder: (context, index) {

              //             return Container(

              //               margin: EdgeInsets.all(10),
              //               decoration: BoxDecoration(
              //                 boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.grey.withValues(alpha: 0.2),
              //                   spreadRadius: 5,
              //                   blurRadius: 7,
              //                   offset:
              //                       Offset(0, 3), // changes position of shadow
              //                 ),
              //               ],
              //               ),
              //               child: Material(
              //                 color: WHITE_COLOR,
              //                 borderRadius: BorderRadius.circular(8),
              //                 elevation: 3,child: Center(
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Icon(Icons.sign_language),
              //                       SizedBox(height: 10,),
              //                       Text("مسئول تسجيل")
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             );
              //             return Container(
              //               // height: 90,
              //               // width: 90,
              //               child: CustomPaint(
              //                 willChange: true,
              //                 isComplex: true,
              //                 painter: BorderPainter(),
              //                 child: Container(
              //                   margin: EdgeInsets.symmetric(horizontal: 10),
              //                   // width: BarReaderSize.width,
              //                   // height: BarReaderSize.height,
              //                   width: 150,
              //                   child: Center(
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Icon(
              //                           Icons.group_add_sharp,
              //                           color: BLACK_COLOR,
              //                           size: 50,
              //                         ),
              //                         Text("مسؤول تسجيل")
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             );
              //           }),
              //     )),

              GetBuilder<EventsController>(
                  init: EventsController(Get.find()),
                  builder: (EventsController eventController) {
                    // if (eventController.events.isEmpty && eventController.isLoading) {
                    //   return Center(child: CircularProgressIndicator()); // Show loader if first-time loading
                    // }

                    return eventController.isLoading
                        ? CircularProgressIndicator()
                        : Expanded(
                            flex: 4,
                            child: SmartRefresher(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: eventController.refreshController,
                              enablePullDown: false,
                              enablePullUp: true,
                              header: WaterDropHeader(),
                              onRefresh: eventController.onRefresh,
                              onLoading: eventController.onLoading,
                              footer: CustomFooter(
                                height: 40,
                                builder:
                                    (BuildContext context, LoadStatus? mode) {
                                  Widget body;
                                  if (mode == LoadStatus.idle) {
                                    body = eventController.events.length > 0
                                        ? Text("Pull up load ↑")
                                        : Text("");
                                  } else if (mode == LoadStatus.loading) {
                                    body = Center(
                                      child:
                                          LoadingAnimationWidget.twistingDots(
                                              leftDotColor:
                                                  const Color(0xFF1A1A3F),
                                              rightDotColor:
                                                  const Color(0xFFEA3799),
                                              size: 60),
                                    );
                                  } else if (mode == LoadStatus.failed) {
                                    body = Text("Load Failed!Click retry!");
                                  } else if (mode == LoadStatus.canLoading) {
                                    body = Text("release to load more");
                                  } else {
                                    body = Text("No more Data");
                                  }

                                  if (eventController.hasMore == false) {
                                    body =
                                        Text("لا يوجد المزيد من الفعاليات 🛑");
                                  }

                                  return Container(
                                    height: 20.0,
                                    child: Center(child: body),
                                  );
                                },
                              ),
                              child: ListView.builder(
                                  itemExtent: 140,
                                  scrollDirection: Axis.vertical,
                                  itemCount: eventController.events.length,
                                  controller: eventController.scrollController,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () => Get.toNamed(
                                          '/event_processing_screen',
                                          arguments: eventController.events
                                              .elementAt(index)
                                              .id,
                                          preventDuplicates: true),
                                      child: Container(
                                        height: 140,
                                        margin: EdgeInsets.only(
                                            bottom: 5,
                                            right: 10,
                                            left: 10,
                                            top: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.2),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          borderRadius:
                                              new BorderRadius.circular(12.0),
                                          color: WHITE_COLOR,
                                          elevation: 4,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(10,
                                                                      10, 0, 0),
                                                          decoration: BoxDecoration(
                                                              color: GREY_COLOR
                                                                  .withOpacity(
                                                                      0.4),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Image.asset(
                                                              "assets/images/sagr-logo.png",
                                                              width: 70,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        14,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    eventController
                                                                        .events
                                                                        .elementAt(
                                                                            index)
                                                                        .name
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                SizedBox(
                                                                    height: 10),
                                                                Container(
                                                                    child: Row(
                                                                  children: [
                                                                    // Icon(Icons.calendar_month, size: 15,),
                                                                    // SizedBox(width: 10,),
                                                                    Flexible(
                                                                        child:
                                                                            Text(
                                                                      "${eventController.events.elementAt(index).address}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    )),
                                                                  ],
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10, 0, 0, 5),
                                                      child: Container(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      "${eventController.events.elementAt(index).date}"),
                                                                  Text(
                                                                    "${eventController.events.elementAt(index).time}",
                                                                    style: TextStyle(
                                                                        height:
                                                                            1.2),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            // Container(
                                                            //   padding: EdgeInsets.symmetric(
                                                            //       vertical: 6,
                                                            //       horizontal: 10),
                                                            //   decoration: BoxDecoration(
                                                            //       color: const Color.fromARGB(
                                                            //           255, 217, 217, 217),
                                                            //       borderRadius:
                                                            //           BorderRadius.circular(
                                                            //               6)),
                                                            //   child: Row(
                                                            //     children: [
                                                            //       Icon(
                                                            //         Icons.hourglass_bottom,
                                                            //         size: 15,
                                                            //       ),
                                                            //       Text(
                                                            //         "الجمعة ٢٠ اغسطس ٢٠٢٤",
                                                            //         style: TextStyle(
                                                            //             fontSize: 12),
                                                            //       )
                                                            //     ],
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    EventCardLeftTime(
                                                      ago: eventController
                                                          .events
                                                          .elementAt(index)
                                                          .ago,
                                                    ),
                                                    Spacer(),
                                                    AppliedWidgetStatusAndApplyButton(
                                                      status: eventController
                                                          .events
                                                          .elementAt(index)
                                                          .appliedStatus,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    return Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withValues(alpha: 0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: WHITE_COLOR,
                                        borderRadius: BorderRadius.circular(8),
                                        elevation: 3,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.sign_language),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Column(
                                                children: [
                                                  Text(eventController.events
                                                      .elementAt(index)
                                                      .name
                                                      .toString()),
                                                  Text(eventController.events
                                                      .elementAt(index)
                                                      .datetime
                                                      .toString())
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ));

                    return eventController.isLoading
                        ? CircularProgressIndicator()
                        : Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                  // color: PURPLE_COLOR,
                                  ),
                              // height: 160,
                              child: ListView.builder(
                                  itemExtent: 140,
                                  scrollDirection: Axis.vertical,
                                  itemCount: eventController.events.length + 1,
                                  controller: eventController.scrollController,
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        eventController.events.length) {
                                      return Center(
                                          child:
                                              CircularProgressIndicator()); // Show loading at the end
                                    }
                                    return Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey
                                                .withValues(alpha: 0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: WHITE_COLOR,
                                        borderRadius: BorderRadius.circular(8),
                                        elevation: 3,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.sign_language),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(eventController.events
                                                  .elementAt(index)
                                                  .name
                                                  .toString())
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ));
                  }),

              // Expanded(
              //     flex: 4,
              //     child: ListView.builder(
              //         itemCount: 5,
              //         itemBuilder: (context, index) {
              //           return Container(
              //             height: 140,
              //             margin:
              //                 EdgeInsets.only(bottom: 5, right: 10, left: 10, top: 10),
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(20),
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: Colors.grey.withValues(alpha: 0.2),
              //                   spreadRadius: 5,
              //                   blurRadius: 7,
              //                   offset:
              //                       Offset(0, 3), // changes position of shadow
              //                 ),
              //               ],
              //             ),
              //             child: Material(
              //               borderRadius: new BorderRadius.circular(12.0),
              //               color: WHITE_COLOR,
              //               elevation: 4,
              //               child: Row(
              //                 children: [
              //                   Expanded(
              //                       child: Container(
              //                     child: Column(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Row(
              //                           children: [
              //                             Container(
              //                               margin:
              //                                   EdgeInsetsDirectional.fromSTEB(
              //                                       10, 10, 0, 0),
              //                               decoration: BoxDecoration(
              //                                   color:
              //                                       GREY_COLOR.withOpacity(0.4),
              //                                   borderRadius:
              //                                       BorderRadius.circular(10)),
              //                               child: Padding(
              //                                 padding: EdgeInsets.all(5),
              //                                 child: Image.asset(
              //                                   "assets/images/sagr-logo.png",
              //                                   width: 70,
              //                                 ),
              //                               ),
              //                             ),
              //                             Expanded(
              //                               child: Padding(
              //                                 padding: EdgeInsetsDirectional
              //                                     .fromSTEB(14, 0, 0, 0),
              //                                 child: Column(
              //                                   crossAxisAlignment:
              //                                       CrossAxisAlignment.start,
              //                                       mainAxisAlignment: MainAxisAlignment.center,
              //                                   children: [
              //                                     Text(
              //                                         "المهرجان الثقافي الدولي ",
              //                                         style: TextStyle(
              //                                             fontSize: 14,
              //                                             fontWeight:
              //                                                 FontWeight.bold)),
              //                                     SizedBox(height: 10),
              //                                     Container(

              //                                         child: Row(
              //                                       children: [
              //                                         // Icon(Icons.calendar_month, size: 15,),
              //                                         // SizedBox(width: 10,),
              //                                         Flexible(
              //                                             child: Text(
              //                                           "حديقة المدينة - شارع الثقافة الرياض",
              //                                           style: TextStyle(
              //                                               fontSize: 12),
              //                                         )),
              //                                       ],
              //                                     )),
              //                                   ],
              //                                 ),
              //                               ),
              //                             )
              //                           ],
              //                         ),
              //                         Padding(
              //                           padding: EdgeInsetsDirectional.fromSTEB(
              //                               10, 0, 0, 10),
              //                           child: Container(
              //                             child: Row(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: [

              //                                  Container(
              //     child: Column(

              //       children: [
              //         Text("12/01/2025"),
              //         Text("10:30:00 AM"),

              //       ],
              //     ),
              //    ),

              //                                 // Container(
              //                                 //   padding: EdgeInsets.symmetric(
              //                                 //       vertical: 6,
              //                                 //       horizontal: 10),
              //                                 //   decoration: BoxDecoration(
              //                                 //       color: const Color.fromARGB(
              //                                 //           255, 217, 217, 217),
              //                                 //       borderRadius:
              //                                 //           BorderRadius.circular(
              //                                 //               6)),
              //                                 //   child: Row(
              //                                 //     children: [
              //                                 //       Icon(
              //                                 //         Icons.hourglass_bottom,
              //                                 //         size: 15,
              //                                 //       ),
              //                                 //       Text(
              //                                 //         "الجمعة ٢٠ اغسطس ٢٠٢٤",
              //                                 //         style: TextStyle(
              //                                 //             fontSize: 12),
              //                                 //       )
              //                                 //     ],
              //                                 //   ),
              //                                 // )
              //                               ],
              //                             ),
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   )),
              //                   Container(
              //                     child: Column(
              //                       crossAxisAlignment: CrossAxisAlignment.end,
              //                       children: [
              //                         EventCardLeftTime(),
              //                         Spacer(),
              //                         Container(
              //                           margin: EdgeInsetsDirectional.only(
              //                               bottom: 0, end: 0),
              //                           padding: EdgeInsets.symmetric(
              //                               vertical: 4, horizontal: 10),
              //                           decoration: BoxDecoration(
              //                               color: GREY_COLOR.withOpacity(0.4),
              //                               borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(12),topStart:Radius.circular(6))),
              //                           child: Row(
              //                             children: [
              //                               Text(
              //                                 ' تقديم ',
              //                                 style: TextStyle(height: 1.4),
              //                               ),
              //                               Icon(
              //                                 Icons.arrow_forward,
              //                                 size: 15,
              //                               ),
              //                             ],
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //           );
              //           return EventCard(
              //             imageUrl: "assets/images/riyad.jpeg",
              //             title: 'مهرجان الفنون والثقافة',
              //             date: 'الجمعه 20 اغسطس 2024',
              //             location: 'Online Event',
              //             onRegisterPressed: () {
              //               Get.toNamed('/event_apply_screen');
              //               print('Register button pressed!');
              //             },
              //           );
              //           return Container(
              //             padding: EdgeInsetsDirectional.only(end: 10),
              //             margin: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              //             decoration: BoxDecoration(
              //               color: WHITE_COLOR,
              //               borderRadius: BorderRadius.circular(12),
              //               border: Border.all(width: 1),
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: const Color.fromARGB(255, 255, 255, 255)
              //                       .withOpacity(0.5),
              //                   spreadRadius: 1,
              //                   blurRadius: 4,
              //                   offset:
              //                       Offset(0, 4), // changes position of shadow
              //                 ),
              //               ],
              //             ),
              //             child: Row(
              //               children: [
              //                 Padding(
              //                   padding: EdgeInsets.all(5),
              //                   child: ClipRRect(
              //                     borderRadius: BorderRadius.only(
              //                         topLeft: Radius.circular(10),
              //                         bottomRight: Radius.circular(10),
              //                         topRight: Radius.circular(10),
              //                         bottomLeft: Radius.circular(10)),
              //                     child: Image.asset("assets/images/riyad.jpeg",
              //                         width: 130),
              //                   ),
              //                 ),
              //                 // ClipRRect(
              //                 //   borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
              //                 //   child: Image.asset("assets/images/img_rectangle_2.png" ,width: 120),
              //                 // ),

              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Expanded(
              //                     child: Column(
              //                   // mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Row(
              //                       children: [
              //                         Icon(
              //                           Icons.event,
              //                           size: 16,
              //                         ),
              //                         SizedBox(width: 5),
              //                         Text(
              //                           "مهرجان الفنون والثقافة",
              //                           style: TextStyle(height: 2),
              //                         )
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Icon(
              //                           Icons.home,
              //                           size: 16,
              //                         ),
              //                         SizedBox(width: 5),
              //                         Text(
              //                             "حديقة المدينة، شارع الثقافة، الرياض",
              //                             style: TextStyle(
              //                                 height: 2, fontSize: 12))
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Icon(
              //                           Icons.calendar_month,
              //                           size: 16,
              //                         ),
              //                         SizedBox(width: 5),
              //                         Text("الجمعه 20 اغسطس 2024",
              //                             style: TextStyle(
              //                                 height: 2, fontSize: 12))
              //                       ],
              //                     ),
              //                     Align(
              //                       alignment: AlignmentDirectional.bottomEnd,
              //                       child: Text(
              //                         "كم تبعد",
              //                         style: TextStyle(fontSize: 12),
              //                       ),
              //                     )
              //                   ],
              //                 ))
              //               ],
              //             ),
              //           );
              //         })),

              // SizedBox(
              //   height: 25,
              // ),

              // SizedBox(
              //   height: 20,
              // ),
              // InkWell(
              //   onTap: () => Get.toNamed('/create_account'),
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              //     decoration: BoxDecoration(
              //         color: BLACK_COLOR,
              //         borderRadius: BorderRadius.circular(8)),
              //     child: Text(
              //       "Register Now".tr,
              //       style: TextStyle(
              //           color: WHITE_COLOR,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 16),
              //     ),
              //   ),
              // ),

              // SizedBox(
              //   height: 15,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppliedWidgetStatusAndApplyButton extends StatelessWidget {
  final String? status;

  const AppliedWidgetStatusAndApplyButton({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 'accepted') {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
            color: SAGR_ACCEPTED.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
        child: Row(
          children: [
            Icon(Icons.done,
                size: 15,
                color:
                    SAGR_ACCEPTED.withValues(alpha: 1)),
            Text(
              status!.tr,
              style: TextStyle(
                  height: 1.4,
                  color:
                      SAGR_ACCEPTED.withValues(alpha: 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else if (status == 'initAccept') {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
        child: Row(
          children: [
            Icon(Icons.indeterminate_check_box,
                size: 15, color: SAGR_INIT_ACCEPTED.withValues(alpha: 1)),
            Text(
              status!.tr,
              style: TextStyle(
                  height: 1.4,
                  color: SAGR_INIT_ACCEPTED.withValues(alpha: 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else if (status == 'rejected') {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
            color: RED_COLOR.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
        child: Row(
          children: [
            Icon(Icons.error,
                size: 15, color: RED_COLOR.withValues(alpha: 1)),
            Text(
              status!.tr,
              style: TextStyle(
                  height: 1.4,
                  color: RED_COLOR.withValues(alpha: 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }else if (status == 'pending') {
      return Container(
        margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
            color: SAGR_PENDING.withValues(alpha: 0.3),
            borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
        child: Row(
          children: [
            Icon(Icons.timer,
                size: 15, color: SAGR_PENDING.withValues(alpha: 1)),
            Text(
              status!.tr,
              style: TextStyle(
                  height: 1.4,
                  color: SAGR_PENDING.withValues(alpha: 1),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 0, end: 0),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
          color: GREY_COLOR.withOpacity(0.4),
          borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(12), topStart: Radius.circular(6))),
      child: Row(
        children: [
          Text(
            'تقديم',
            style: TextStyle(height: 1.4),
          ),
          Icon(
            Icons.arrow_forward,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class EventCardLeftTime extends StatelessWidget {
  final String? ago;
  const EventCardLeftTime({
    super.key,
    this.ago,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      decoration: BoxDecoration(
          color: GREY_COLOR.withOpacity(0.4),
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(10), bottomStart: Radius.circular(6))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_outlined,
            size: 15,
            color: Color.fromARGB(255, 86, 86, 86),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "$ago",
            style: TextStyle(
                color: const Color.fromARGB(255, 86, 86, 86), height: 2),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String location;
  final VoidCallback onRegisterPressed;

  EventCard({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.location,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/event_apply_screen'),
      child: Card(
        color: WHITE_COLOR,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imageUrl,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            // Event Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Event Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 8),
                      Text(
                        date,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Event Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      SizedBox(width: 8),
                      Text(
                        location,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // ElevatedButton(
                  //   onPressed: onRegisterPressed,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     padding: EdgeInsets.symmetric(vertical: 12),
                  //   ),
                  //   child: Text(
                  //     'Register Now',
                  //     style: TextStyle(fontSize: 16, color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = 2.0;
    final radius = 20.0;
    final tRadius = 2 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color.fromARGB(255, 0, 0, 0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BarReaderSize {
  static double width = 100;
  static double height = 100;
}
