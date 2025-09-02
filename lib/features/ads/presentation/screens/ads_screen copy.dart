import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  MasterWrapper(
      body: Scaffold(
        appBar: AppBar(
          title: Text("Advertisements".tr),
          scrolledUnderElevation: 0,
          backgroundColor: WHITE_COLOR,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index){
          return    

          Container(
            // height: 120,
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        padding: EdgeInsets.only(bottom: 5, right: 10, left: 10),
          
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
              // color: const Color.fromARGB(255, 241, 241, 241),
          
              
           borderRadius: BorderRadiusDirectional.all(Radius.circular(10))
            ),
            child: Material(
              color: WHITE_COLOR,
              
              borderRadius: BorderRadius.circular(12),
              elevation: 4,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Column(
                    children: [
                       Container(
                     decoration: BoxDecoration(
                       color: GREY_COLOR.withOpacity(0.3),
                       borderRadius: BorderRadius.circular(8)
                     ),
                    //  padding: EdgeInsets.all(4),
                     margin: EdgeInsetsDirectional.fromSTEB(0,0,0,0),
                      child: Image.asset("assets/images/sagr-logo.png", width: 90),
                     ),
                            
                     Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Column(
                     
                        children: [
                          Text("12/01/2025"),
                          Text("10:30:00 AM"),
                          
                        ],
                      ),
                     )
                    ],
                   ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      decoration: BoxDecoration(
                        // color: BLACK_COLOR
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                         Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                          decoration: BoxDecoration(
                            // color: BLACK_COLOR,
                            borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), bottomEnd: Radius.circular(20))
                          ),
                          child:  Text("صقر لإدارة العفاليات", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:BLACK_COLOR)),
                         ),
                         SizedBox(height: 10),
                         Text("خلافاَ للإعتقاد السائد فإن لوريم إيبسوم ليس نصاَ عشوائياً.", style: TextStyle(color: BLACK_COLOR, fontSize: 12),),
                         
                          SizedBox(height: 10),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: GREY_COLOR.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(6)
                              ),
                              child: Text(" عرض المزيد", style: TextStyle(color: BLACK_COLOR.withOpacity(0.6), fontSize: 12),),),
                          )
                         
                          ],
                      ),
                    ),),
                     
                   
                ],
                            ),
              ),
            ));
          // Container(
          //   height: 220,
          //   margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          //   decoration: BoxDecoration(
          //     color: BLACK_COLOR,
          //     borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(60))
          //   ),
          //   child: Row(
          //   children: [
          //       Image.asset("assets/images/gift_icon.png", width: 100),
          //       SizedBox(width: 20),
          //       Expanded(
          //         child: Container(
          //           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
          //         decoration: BoxDecoration(
          //           // color: BLACK_COLOR
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //            Container(
          //             margin: EdgeInsets.only(top: 20),
          //             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //             decoration: BoxDecoration(
          //               color: WHITE_COLOR,
          //               borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20), bottomEnd: Radius.circular(20))
          //             ),
          //             child:  Text("صقر لإدارة العفاليات ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          //            ),
          //            SizedBox(height: 10),
          //                   Text("خلافاَ للإعتقاد السائد فإن لوريم إيبسوم ليس نصاَ عشوائياً، بل إن له جذور في الأدب اللاتيني الكلاسيكي منذ العام 45 قبل الميلاد، مما يجعله أكثر من 2000 عام في القدم.", style: TextStyle(color: WHITE_COLOR),),
          //                                        SizedBox(height: 10),
          //             Align(
          //               alignment: AlignmentDirectional.bottomEnd,
          //               child: Text("تقديم وعرض المزيد", style: TextStyle(color: WHITE_COLOR),),
          //             )
          //             ],
          //         ),
          //       ),)
          //   ],
          // )) 
          
          
          // Container(
          //   height: 200,
          //   margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          //   decoration: BoxDecoration(
          //     color: RED_COLOR,
          //     borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(60))
          //   ),
          //   child: Row(
          //   children: [
          //       Expanded(child: Container(
          //         padding: EdgeInsetsDirectional.only(start: 25),
          //         decoration: BoxDecoration(
          //           // color: BLACK_COLOR
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text("شركة عبد العظيم "),
          //                   Text("شركة عبد العظيم "),
          //                         Text("شركة عبد العظيم "),
          //             ],
          //         ),
          //       )),
          //         Image.asset("assets/images/gift_icon.png", width: 100,),

          //   ],
          // ));
        })),
      ),
    );
  }
}