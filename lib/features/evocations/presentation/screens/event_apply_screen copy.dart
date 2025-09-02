import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:sagr/data/colors.dart';
import 'package:get/get.dart';
import 'package:sagr/features/events/presentation/controllers/event_apply_controller.dart';
import 'package:sagr/features/language/presentation/controllers/languages_controller.dart';
import 'package:sagr/view/profile/Total/view.dart';
import 'package:sagr/widgets/bottom_navigation_bar/event_navigation.dart';

import '../../../../view/widgets/Forms/easy_app_text_form_field.dart';
import '../../../../widgets/Common/custom_dropdown.dart';
import '../../../jobs/data/models/job_model.dart';
import '../../../jobs/presentation/controllers/marital_status_controller.dart';
import '../../../language/data/models/language_model.dart';

class EventApplyScreen extends StatelessWidget {
   EventApplyScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<EventApplyController>(
          init: EventApplyController(Get.find()),
          builder: (EventApplyController eventApplyController) {
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: SizedBox(
                  height: constraints.maxHeight * 1, //70 for bottom

                  child: Column(
                    children: [
                      // Container(
                      //   height: 0.0,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           fit: BoxFit.cover,
                      //           image: AssetImage("assets/images/cover.jpg"))),
                      // ),
                      // Positioned(
                      //     top: 80,
                      //     child: Container(
                      //       padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                      //       child: Icon(
                      //         Icons.arrow_back,
                      //         color: WHITE_COLOR,
                      //       ),
                      //     )),

                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
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
                                  SizedBox(height: 50),
                                  SizedBox(
                                    height: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("طلب تقديم علي الفعالية"),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(13, 10, 13, 5),
                                            child: Text("الوظيفة المقدم عليها")),
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 0, 10, 0),
                                            child: Container(
                                              margin:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      3, 0, 3, 0),
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      3, 0, 3, 0),
                                              decoration: BoxDecoration(
                                                  // color: const Color.fromARGB(255, 219, 48, 48),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: const Color.fromARGB(
                                                          255, 192, 192, 192))),
                                              child: GetBuilder<JobsController>(
                                                  init:
                                                      JobsController(Get.find()),
                                                  builder: (jobsController) {
                                                    return CustomDropdownV2<
                                                        JobModel?>(
                                                      leadingIcon: true,
                                                      onChange: (int index) =>
                                                          eventApplyController
                                                              .setSelectedJob(
                                                                  jobsController
                                                                      .jobs
                                                                      .elementAt(
                                                                          index)),
                                                      dropdownButtonStyle: DropdownButtonStyle(
                                                          width: double.infinity,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(200)),
                                                          height: 50,
                                                          elevation: 0,
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(255,
                                                                  255, 255, 255),
                                                          primaryColor:
                                                              const Color
                                                                  .fromARGB(221,
                                                                  205, 205, 205),
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween),
                                                      dropdownStyle:
                                                          DropdownStyle(
                                                              // width: 340,
                                                              color: WHITE_COLOR,
                                                              elevation: 0,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      0),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                      side:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width: 0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8))),
                                                      items: jobsController.jobs
                                                          .asMap()
                                                          .entries
                                                          .map(
                                                            (item) =>
                                                                DropdownItem<
                                                                    JobModel?>(
                                                              value: item.value,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8.0),
                                                                child: Text(item
                                                                    .value.name!),
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(start: 10),
                                                        child: Text(eventApplyController
                                                                    .selectedJob
                                                                    .id !=
                                                                0
                                                            ? eventApplyController
                                                                .selectedJob.name
                                                                .toString()
                                                            : 'الوظيفة'),
                                                      ),
                                                    );
                                                  }),
                                            )),

                                          Container(
                                                  padding:   const EdgeInsetsDirectional
                                                .fromSTEB(15, 0, 10, 10),
                                          
                                              child: Text(eventApplyController.errors.isNotEmpty && eventApplyController.errors.containsKey('job') 
                                              && eventApplyController.errors['job'] != "" ? eventApplyController.errors['job']: "" , style: TextStyle(color: RED_COLOR, fontWeight: FontWeight.w700), ),
                                            ),
                                            
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(13, 0, 13, 5),
                                            child: Text("اللغات المتقنه")),
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 0, 10, 0),
                                            child: Container(
                                              // height: 50,
                                              margin:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      3, 0, 3, 0),
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      3, 0, 3, 0),
                                              decoration: BoxDecoration(
                                                  // color: const Color.fromARGB(255, 219, 48, 48),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: const Color.fromARGB(
                                                          255, 192, 192, 192))),
                                              child: GetBuilder<
                                                      LanguagesController>(
                                                  init: LanguagesController(
                                                      Get.find()),
                                                  builder: (languageController) {
                                                    return SizedBox(
                                                      child: CustomDropdown<
                                                          LanguageModel>.multiSelect(
                                                        decoration:
                                                            CustomDropdownDecoration(),
                                                        hintText: 'Languages'.tr,
                                                        items: languageController
                                                            .languages
                                                            .toList(),
                                                        initialItems: eventApplyController.languages.toList(),
                                                        
                                                        onListChanged: (value)  => eventApplyController.setSelectedLanguages(value),
                                                      ),
                                                    );
                                                  }),
                                            )),

                                             eventApplyController.errors.isNotEmpty && eventApplyController.errors.containsKey('language') && eventApplyController.errors['language'] != "" ? Container(
                                                  padding:   const EdgeInsetsDirectional
                                                .fromSTEB(15, 0, 0, 10),
                                          
                                              child: Text(eventApplyController.errors.isNotEmpty && eventApplyController.errors.containsKey('language') && eventApplyController.errors['language'] != "" ? eventApplyController.errors['language']: ""  ,style: TextStyle(color: RED_COLOR, fontWeight: FontWeight.w700),),
                                            ):Container(),


                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(13, 10, 13, 5),
                                            child: Text("اختيار الفترة")),
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Container(
                                            child: eventApplyController.isLoading ?CircularProgressIndicator() : Column(
                                              children: eventApplyController
                                                  .event!.periods!
                                                  .map((e) => Container(
                                                        child: InkWell(
                                                          onTap: () =>
                                                              eventApplyController
                                                                  .setSelectEventPeriod(
                                                                      e.id),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      border: Border.all(
                                                                          width:
                                                                              2)),
                                                                  child: eventApplyController
                                                                              .periodId ==
                                                                          e.id
                                                                      ? RadioButtonDot(
                                                                          borderRadius:
                                                                              12,
                                                                        )
                                                                      : Container(),
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                Text(
                                                                  e.period,
                                                                  textDirection:
                                                                      TextDirection
                                                                          .ltr,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),

                                                  
                                              // children:
                                              // [
                                              //   Row(
                                              //     crossAxisAlignment: CrossAxisAlignment.center,
                                              //     mainAxisAlignment: MainAxisAlignment.start,
                                              //     children: [
                                              //       Container(
                                              //         width: 20,
                                              //         height: 20,
                                              //         decoration: BoxDecoration(
                                              //           borderRadius: BorderRadius.circular(100),
                                              //           border: Border.all(width: 2)
                                              //         ),
                                              //       ),
                          
                                              //       SizedBox(width: 10),
                                              //       Text("08:00 AM - 04:00 PM", textDirection: TextDirection.ltr,),
                                              //     ],
                                              //   ),
                          
                                              //   SizedBox(height: 15),
                                              //   Row(
                                              //     crossAxisAlignment: CrossAxisAlignment.center,
                                              //     mainAxisAlignment: MainAxisAlignment.start,
                                              //     children: [
                                              //       Container(
                                              //         width: 20,
                                              //         height: 20,
                                              //         decoration: BoxDecoration(
                                              //           borderRadius: BorderRadius.circular(100),
                                              //           border: Border.all(width: 2)
                                              //         ),
                                              //       ),
                          
                                              //       SizedBox(width: 10),
                                              //       Text("08:00 AM - 04:00 PM", textDirection: TextDirection.ltr,),
                                              //     ],
                                              //   )
                                              // ],
                                              
                                            ),
                                            
                                          ),
                                          
                                        ),

                                         Container(
                                                  padding:   const EdgeInsetsDirectional
                                                .fromSTEB(20, 0, 10, 10),
                                          
                                              child: Text(eventApplyController.errors.isNotEmpty && eventApplyController.errors.containsKey('period') && eventApplyController.errors['period'] != "" ? eventApplyController.errors['period']: ""  ,style: TextStyle(color: RED_COLOR, fontWeight: FontWeight.w700),),
                                            ),
                                        
                                        SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 10, 0),
                                          child: EasyAppTextFormField(
                                            required: false,
                                            multiline: 3,
                                            maxLength: 100,
                                            onSave: (value) => eventApplyController.others = value!,
                                            labelText: "Others".tr,
                                            hintText: "",
                          
                                            // onValidate: (value) {
                                            //   if (value?.length == 0) {
                                            //     return "Chronic diseases Required!".tr;
                                            //   } else {
                                            //     return null;
                                            //   }
                                            // },
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 0, 10, 0),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () =>
                                                      eventApplyController
                                                          .toggleTerms(),
                                                  child: Container(
                                                    // color: RED_COLOR,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border: Border.all(
                                                                  width: 1)),
                                                          child:
                                                              eventApplyController
                                                                      .terms
                                                                  ? RadioButtonDot(
                                                                      borderRadius:
                                                                          2)
                                                                  : Container(),
                                                        ),
                                                        SizedBox(width: 3),
                                                        Text(
                                                          "موافق علي الشروط والاحكام للفعاليه",
                                                          style: TextStyle(
                                                              height: 1.4),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 12),
                                                InkWell(
                                                  onTap: () =>
                                                      eventApplyController
                                                          .togglePromise(),
                                                  child: Container(
                                                    // color: RED_COLOR,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(6),
                                                            border: Border.all(
                                                                width: 1),
                                                          ),
                                                          child:
                                                              eventApplyController
                                                                      .promise
                                                                  ? RadioButtonDot(
                                                                      borderRadius:
                                                                          2)
                                                                  : Container(),
                                                        ),
                                                        SizedBox(width: 3),
                                                        Text(
                                                          "اتعهد ان كافة بياناتي صحيحة",
                                                          style: TextStyle(
                                                              height: 1.4),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                                        SizedBox(height: 40),
                                        Align(
                                          alignment: Alignment.center,
                                          child: InkWell(
                          
                                            onTap: () {


                                              
                             _formKey.currentState!.save();
                                    if (_formKey.currentState!.validate()) {
                          
                                      eventApplyController.apply();
                          
                                    }
                                            },
                          
                                          
                                            child: Container(
                                              // width: double.infinity,
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      40, 10, 40, 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.blueGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Text(
                                                "إرسال الطلب",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: WHITE_COLOR),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  EventBottomNavigation()
                                ],
                              )),
                        ),
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
            );
          }),
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

class RadioButtonDot extends StatelessWidget {
  final double borderRadius;

  const RadioButtonDot({
    Key? key,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: RED_COLOR,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
