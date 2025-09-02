import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/features/events/presentation/widgets/card_info.dart';

import '../../../../data/colors.dart';
import '../controllers/events_controller.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Events".tr),
        scrolledUnderElevation: 0,
        backgroundColor: WHITE_COLOR,
        centerTitle: false,
      ),
    body: GetBuilder<EventsController>(builder: (EventsController eventController){
        return ListView.builder(
          itemCount: eventController.events.length,
          itemBuilder: (cntx, index) {


            return GestureDetector(
               onTap: () {

                if(eventController.events.elementAt(index).appliedStatus == 'accepted'){
                  Get.toNamed('/event_accept_screen', arguments: eventController.events.elementAt(index).id);
                }
                //  Get.toNamed('/event_processing_screen', arguments: eventController.events.elementAt(index).id);
               },
              child: InfoCard(
                imageUrl: 'https://img.freepik.com/premium-photo/waves-pastel-colors-waves-background_476363-7444.jpg',
                title: eventController.events.elementAt(index).name!,
                address: eventController.events.elementAt(index).description!,
                status: eventController.events.elementAt(index).appliedStatus!,
                date: "${eventController.events.elementAt(index).date} ${eventController.events.elementAt(index).time}" ,
                eventStatus: eventController.events.elementAt(index).startDateTime!.status.toString(),
              ),
            );
    });
    })


   
    );
  }
}
