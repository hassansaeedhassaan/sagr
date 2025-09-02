import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/features/events/presentation/controllers/events_controller.dart';

import '../../../../data/colors.dart';

class PreviousEventsScreen extends StatelessWidget {
  const PreviousEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventsController>(
        init: EventsController(Get.find()),
        builder: (EventsController eventsController) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Previous Events ii".tr),
              scrolledUnderElevation: 0,
              backgroundColor: WHITE_COLOR,
            ),
            body: ListView.builder(
                itemCount: eventsController.events.length,
                itemBuilder: (cntx, index) {
                  return Container(
                    padding: EdgeInsetsDirectional.only(end: 10),
                    margin: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: WHITE_COLOR,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            child: Image.asset("assets/images/riyad.jpeg",
                                width: 120),
                          ),
                        ),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                        //   child: Image.asset("assets/images/img_rectangle_2.png" ,width: 120),
                        // ),

                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.event,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  eventsController.events.elementAt(index).id.toString(),
                                  style: TextStyle(height: 2),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.home,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text("حديقة المدينة، شارع الثقافة، الرياض",
                                    style: TextStyle(height: 2, fontSize: 12))
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text("الجمعه 20 اغسطس 2024",
                                    style: TextStyle(height: 2, fontSize: 12))
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ))
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
