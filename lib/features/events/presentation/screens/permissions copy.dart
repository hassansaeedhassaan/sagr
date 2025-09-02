import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/home/presentation/screens/home_screen.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(title: Text("Permissions".tr),scrolledUnderElevation: 0, backgroundColor: WHITE_COLOR, centerTitle: false,),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // SizedBox(height: 50),
                  // Container(
                  //   height: 200,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //       color: BLACK_COLOR.withValues(alpha: 0.5),
                  //       borderRadius: BorderRadiusDirectional.only(
                  //           bottomEnd: Radius.circular(80)),
                  //       image: DecorationImage(
                  //           image: AssetImage("assets/images/sagr-logo.png"))),
                  //   child: Stack(
                  //     children: [
                  //     Positioned(
                  //       top: 50,
                  //       left: 40,
                  //       child: InkWell(
                  //         onTap: () => Get.back(),
                  //         child: Icon(Icons.arrow_forward_ios, color: WHITE_COLOR,),
                  //       )),
                  //       Positioned(
                  //           top: 100,
                  //           right: 0,
                  //           child: Container(
                  //             padding:
                  //                 EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  //             decoration: BoxDecoration(
                  //                 color: WHITE_COLOR,
                  //                 borderRadius: BorderRadiusDirectional.only(
                  //                     topEnd: Radius.circular(40),
                  //                     bottomEnd: Radius.circular(40))),
                  //             child: Text("طلبات قيد الاجراء"),
                  //           ))
                  //     ],
                  //   ),
                  // ),
            
            
            
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    itemBuilder: (cntx, index){
                    return Container(
                      margin: EdgeInsets.only(bottom: 0),
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: RED_COLOR,
                        borderRadius: BorderRadius.circular(12),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            
                      
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Material(
                                                borderRadius: BorderRadius.circular(12),
            
                                elevation: 5,
                                child: Container(
                                
                                
                                
                                                    
                                decoration: BoxDecoration( 
                                  color: WHITE_COLOR,
                                                    borderRadius: BorderRadius.circular(12)
            
                                
                                ),
                                  // margin: EdgeInsetsDirectional.only(start: 200),
                                    padding: EdgeInsetsDirectional.only(start: 135, bottom: 20, top: 20),
                                
                                
                                  // alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    
                                    children: [
                                      Container(
                                        // width: BarReaderSize.width +17,
                                        width: 116,
                                        // color: RED_COLOR,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [   
                                            Text(" الطعام ", style: TextStyle(fontWeight:FontWeight.w600, fontSize: 16 )),
                                            Text("منطقة ٣ "),
                                        
                                            Text("معرض الكتاب الدولي بالرياض" , style: TextStyle(fontSize: 9), overflow: TextOverflow.ellipsis,
  maxLines: 2,
  softWrap: true,)
                                            
                                             
                                        
                                             
                                                   
                                          ],
                                        ),
                                      ),
            
            
                                      Container(
                                        width: 120,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          // color: RED_COLOR
                                        ),
                                        child: Column(
                                          children: [
                                            Text("10:40 AM", textDirection: TextDirection.ltr, style: TextStyle(fontSize: 26, color: BLACK_COLOR, fontWeight: FontWeight.bold),),
                                            Container(
                                            child: Container(
                                              width: BarReaderSize.width,
                                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1, color: Colors.green),
                                                borderRadius: BorderRadius.circular(6)
                                              ),
                                              child: Center(child: Text("مقبول", style: TextStyle(fontSize: 12, color: Colors.green,))),
                                            ),
                                          ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                               Positioned(
                        
                              top: 0,
                            child: Image.asset("assets/images/sagr-logo.png", width: 120,)),
                          ],
                        ),
                      ),
                    );
                  }),
            
                  
                ],
              ),
            ),
          ),
    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:       EventBottomNavigation(),)
        ],
      ),
    );
  }
}
