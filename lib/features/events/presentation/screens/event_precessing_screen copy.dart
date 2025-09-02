import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:sagr/data/colors.dart';
import 'package:get/get.dart';
import 'package:sagr/features/events/presentation/controllers/events_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../controllers/event_controller.dart';

class EventProcessingScreen extends StatelessWidget {
  const EventProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    //   return Scaffold(
    //   body: Shimmer.fromColors(
    //     baseColor: Colors.grey[300]!,
    //     highlightColor: Colors.grey[100]!,
    //     child: ListView(
    //       padding: const EdgeInsets.all(16),
    //       children: [
    //         // Image/Header
    //         Container(
    //           height: 200,
    //           color: Colors.white,
    //         ),
    //         const SizedBox(height: 20),
    //         // Title
    //         Container(
    //           height: 20,
    //           width: 150,
    //           color: Colors.white,
    //         ),
    //         const SizedBox(height: 10),
    //         // Subtitle
    //         Container(
    //           height: 15,
    //           width: 250,
    //           color: Colors.white,
    //         ),
    //         const SizedBox(height: 20),
    //         // Paragraph
    //         ...List.generate(
    //           3,
    //           (index) => Padding(
    //             padding: const EdgeInsets.only(bottom: 8),
    //             child: Container(
    //               height: 12,
    //               width: double.infinity,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         // Task boxes
    //         Row(
    //           children: [
    //             Expanded(
    //               child: Container(
    //                 height: 100,
    //                 color: Colors.white,
    //               ),
    //             ),
    //             const SizedBox(width: 10),
    //             Expanded(
    //               child: Container(
    //                 height: 100,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(height: 20),
    //         // Time info
    //         Container(
    //           height: 15,
    //           width: 200,
    //           color: Colors.white,
    //         ),
    //         const SizedBox(height: 10),
    //         // Location
    //         Container(
    //           height: 15,
    //           width: 300,
    //           color: Colors.white,
    //         ),
    //         const SizedBox(height: 20),
    //         // Button
    //         Container(
    //           height: 40,
    //           width: double.infinity,
    //           color: Colors.white,
    //         ),
    //         const SizedBox(height: 20),
    //         // Bottom navigation placeholder
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: List.generate(
    //             4,
    //             (_) => Container(
    //               height: 30,
    //               width: 30,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: SizedBox(
            height: constraints.maxHeight * 1, //70 for bottom

            child: GetBuilder<EventController>(
              init: EventController(Get.find()),
              builder: (EventController eventController){
              return  eventController.isLoading ?Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(height: 50),

            // Image/Header
            Container(
              height: 300,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Title
            Container(
              height: 20,
              width: 150,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            // Subtitle
            Container(
              height: 15,
              width: 250,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Paragraph
            ...List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Task boxes
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 100,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Time info
            Container(
              height: 15,
              width: 200,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            // Location
            Container(
              height: 15,
              width: 300,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Button
            Container(
              height: 40,
              width: double.infinity,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Bottom navigation placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (_) => Container(
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ) : Stack(
              children: [


                Container(
                  height: 185.0,
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
                  top: 160.0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 180,
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
                                Text(" تفاصيل الفعالية"  ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Container(
                                  decoration: BoxDecoration(
                                      border: BorderDirectional(
                                          bottom: BorderSide(
                                    width: 2,
                                  ))),
                                  child: Text(
                                    "${eventController.event?.name}" ,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Container(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 0, vertical: 10),
                                  decoration: BoxDecoration(
                                      // color: RED_COLOR
                                      ),
                                  child: ReadMoreText(
                                    '${eventController.event?.description}',
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: "قراءة المزيد",
                                    trimExpandedText: " أقراء اقل ",
                                    trimLines: 2,
                                    colorClickableText: Colors.grey,
                                    annotations: [
                                      Annotation(
                                        regExp: RegExp(r'#([a-zA-Z0-9_]+)'),
                                        spanBuilder: (
                                                {required String text,
                                                TextStyle? textStyle}) =>
                                            TextSpan(
                                          text: text,
                                          style: textStyle?.copyWith(
                                              color: Colors.blue),
                                        ),
                                      ),
                                      Annotation(
                                        regExp: RegExp(r'<@(\d+)>'),
                                        spanBuilder: (
                                                {required String text,
                                                TextStyle? textStyle}) =>
                                            TextSpan(
                                          text: 'User123',
                                          style: textStyle?.copyWith(
                                              color: Colors.green),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Handle tap, e.g., navigate to a user profile
                                            },
                                        ),
                                      ),
                                      // Additional annotations for URLs...
                                    ],
                                    moreStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 233, 233, 233),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      start: 5),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  border: BorderDirectional(
                                                      bottom: BorderSide(
                                                          width: 2))),
                                              child: Text("المهام الاساسية"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Table(
                                                children: [
                                                  TableRow(children: [
                                                    Text("إدارة البوابات")
                                                  ]),
                                                  TableRow(children: [
                                                    Text("إدارة التذاكر")
                                                  ]),
                                                  TableRow(children: [
                                                    Text(
                                                        "التنظيم داخل المهرجان")
                                                  ]),
                                                  TableRow(children: [
                                                    Text("تنظيم الدخول والخروج")
                                                  ])
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                      SizedBox(width: 10),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 233, 233, 233),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      start: 5),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  border: BorderDirectional(
                                                      bottom: BorderSide(
                                                          width: 2))),
                                              child: Text("احتياج الفعالية"),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Table(
                                                children: [
                                                  TableRow(children: [
                                                    Text("٥٠ منظم")
                                                  ]),
                                                  TableRow(children: [
                                                    Text("٢٠ منظمة")
                                                  ]),
                                                  TableRow(children: [
                                                    Text("١٠ مواجهين ")
                                                  ]),
                                                  TableRow(children: [
                                                    Text("١٠ حرس شخصي")
                                                  ])
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      border: BorderDirectional(
                                          bottom: BorderSide(
                                    width: 2,
                                  ))),
                                  child: GestureDetector(
                                    onTap:  () => Get.toNamed('/event_apply_screen', arguments: eventController.event?.id),

                                    
                                    child: Text(
                                      "كيفية التحضير",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 5, 0, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(""),
                                          Flexible(child: Text("${eventController.event?.preparing}"))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                      border: BorderDirectional(
                                          bottom: BorderSide(
                                    width: 2,
                                  ))),
                                  child: Text(
                                    "التفاصيل",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 5, 0, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                              child: Text(
                                                  " الجمعة ٢٠ اغسطس ٢٠٢٤ من الساعة ١٠ صباحاً حتي الساعة ١٠ مساءاً  حديقة المدينة شارع الثقافة الرياض"))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  child: Text("- رابط الوصول لموقع الفعالية",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          color: Colors.green)),
                                ),
                                SizedBox(height: 30),
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    child: Container(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 5, 20, 5),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        "قيد الاجراء",
                                        style: TextStyle(
                                            fontSize: 16, color: WHITE_COLOR),
                                      ),
                                    ),
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
                            margin:
                                EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
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
            );
            })
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
