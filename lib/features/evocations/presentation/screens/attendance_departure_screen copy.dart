import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';

class AttendanceAndDepartureScreen extends StatelessWidget {
  AttendanceAndDepartureScreen({super.key});
  final _key = GlobalKey<ExpandableFabState>();
  final Completer<GoogleMapController> googleMapController = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: ExpandableFab.location,
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(bottom: 90),
      //   child: ExpandableFab(
      //     initialOpen: false,
      //     key: _key,
      //     type: ExpandableFabType.up,
      //     childrenAnimation: ExpandableFabAnimation.none,
      //     distance: 70,
      //     overlayStyle: ExpandableFabOverlayStyle(
      //       color: Colors.white.withOpacity(0.9),
      //     ),
      //     children: const [
      //       Row(
      //         textDirection: TextDirection.ltr,
      //         children: [
      //           Text('Remind'),
      //           SizedBox(width: 20),
      //           FloatingActionButton.small(
      //             heroTag: null,
      //             onPressed: null,
      //             child: Icon(Icons.notifications),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         textDirection: TextDirection.ltr,
      //         children: [
      //           Text('Email'),
      //           SizedBox(width: 20),
      //           FloatingActionButton.small(
      //             heroTag: null,
      //             onPressed: null,
      //             child: Icon(Icons.email),
      //           ),
      //         ],
      //       ),
      //       Row(
      //         textDirection: TextDirection.ltr,
      //         children: [
      //           Text('Star'),
      //           SizedBox(width: 20),
      //           FloatingActionButton.small(
      //             heroTag: null,
      //             onPressed: null,
      //             child: Icon(Icons.star),
      //           ),
      //         ],
      //       ),
      //       // FloatingActionButton.small(
      //       //   heroTag: null,
      //       //   onPressed: null,
      //       //   child: Icon(Icons.add),
      //       // ),
      //     ],
      //   ),
      // ),
      backgroundColor: WHITE_COLOR,
      appBar: AppBar(
        title: Text("Attendance And Departure".tr),
        scrolledUnderElevation: 0,
        backgroundColor: WHITE_COLOR,
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Text("معرض الكتاب",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 10),
                  child: Text(
                    "09:00 AM",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/map.png'),
                  ),
                ),

                SizedBox(height: 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      type: MaterialType.card,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadiusDirectional.only(
                              topEnd: Radius.circular(30)),
                          //                                    boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius:5,
                          //     blurRadius: 7,
                          //     offset: Offset(0, 3), // changes position of shadow
                          //   ),
                          // ],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.present_to_all,
                              color: WHITE_COLOR,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "تسجيل الحضور",
                              style: TextStyle(color: WHITE_COLOR),
                            )
                          ],
                        ),
                      ),
                    ),
                    Material(
                      type: MaterialType.card,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text(
                              "تسجيل الحضور",
                              style: TextStyle(color: WHITE_COLOR),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.logout,
                              color: WHITE_COLOR,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text("الاستئذانات"),
                  ),
                )
                //             SizedBox(
                //   height: 224.v,
                //   width: 374.h,
                //   child: GoogleMap(
                //     //TODO: Add your Google Maps API key in AndroidManifest.xml and pod file
                //     mapType: MapType.normal,
                //     initialCameraPosition: CameraPosition(
                //       target: LatLng(
                //         37.43296265331129,
                //         -122.08832357078792,
                //       ),
                //       zoom: 14.4746,
                //     ),
                //     onMapCreated: (GoogleMapController controller) {
                //       googleMapController.complete(controller);
                //     },
                //     zoomControlsEnabled: false,
                //     zoomGesturesEnabled: false,
                //     myLocationButtonEnabled: false,
                //     myLocationEnabled: false,
                //   ),
                // )
              ],
            )), 
            
            
            Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: EventBottomNavigation(),)
             ],
        ),
      ),
    );
  }
}
