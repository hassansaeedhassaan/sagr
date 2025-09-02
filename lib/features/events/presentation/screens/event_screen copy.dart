import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';
import 'package:get/get.dart';

import '../../../home/presentation/screens/home_screen.dart';
class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                                Text("القبول المبدئي"),
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
                  painter: BorderPainter(),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    // width: BarReaderSize.width,
                    height: BarReaderSize.height + 100,
                    width: MediaQuery.of(context).size.width - 80,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 90,
                                    padding:
                                        EdgeInsets.fromLTRB(30, 20, 30, 20),
                                    decoration: BoxDecoration(
                                        color: GREY_COLOR.withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("تاريخ مباشرة العمل", style: TextStyle(),),
                                            Text("22/03/2025",      style: TextStyle(fontSize: 12),)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("ساعات العمل"),
                                            Text(
                                              "08:00 AM - 05:00 PM",
                                              textDirection: TextDirection.ltr,
                                                    style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),

                                        SizedBox(height: 30),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("المبلغ المقدم"),
                                            Text(
                                              "500 ريال",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
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
                )),
                                SizedBox(height: 40),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    height: MediaQuery.of(context).size.height * 0.73,
    decoration: new BoxDecoration(
      color: Colors.white,
      borderRadius: new BorderRadius.only(
        topLeft: const Radius.circular(25.0),
        topRight: const Radius.circular(25.0),
      ),
    ),
    child: Center(
      child: Text("شروط العقد"),
    ),
  ),
),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: BLACK_COLOR,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      "شروط العقد",
                                      style: TextStyle(
                                          color: WHITE_COLOR, fontSize: 16),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 10),
                                        decoration: BoxDecoration(
                                            // color: BLACK_COLOR,
                                            border: Border.all(
                                                width: 1.5, color: Colors.green),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          "اوافق",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 10),
                                        decoration: BoxDecoration(
                                            // color: BLACK_COLOR,
                                            border: Border.all(
                                                width: 1.5, color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          "ارفض",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
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
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select an Option', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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


