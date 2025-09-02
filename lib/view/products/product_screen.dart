
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/utilities/localizations/app_language.dart';
import 'package:sagr/widgets/ProductSliderWidget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 243, 243, 243),
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: WHITE_COLOR,
            foregroundColor: BLACK_COLOR,
            
            leading: GestureDetector(onTap: ()=> Get.back(), child: Icon(Icons.arrow_back),),
            title: Text(
              "Product Details".tr,
              style: TextStyle(
                  fontSize: 20, height: 1.6, fontWeight: FontWeight.bold),
            ),
            actions: [
              Container(
                // width: 80,
                padding: EdgeInsetsDirectional.only(end: 20),
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/icons/heart.svg'),
                    SizedBox(width: 5),
                    SvgPicture.asset('assets/icons/share.svg')
                  ],
                ),
              )
            ],
          ),
          body: GetBuilder<AppLanguage>(
              init: AppLanguage(),
              builder: (controller) {
                return Column(
                  children: [
                    // AppLocaleSwitcher(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 215),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(26),
                                                  topRight:
                                                      Radius.circular(26))),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 20,
                                                    horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("ادوات مقعد",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      GREY_COLOR)),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            " شنيور عادة و دقاق يمين و شمال",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    BLACK_COLOR),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 6.0),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "EGP 150.00",
                                                                  style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          211,
                                                                          51,
                                                                          51),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    "EGP 180.00",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          GREY_COLOR,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                    ))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // RatingBar.builder(
                                                          //   // tapOnlyMode: true,
                                                          //   initialRating: 4,
                                                          //   unratedColor: Color(
                                                          //       0xffEBEBE9),
                                                          //   minRating: 1,
                                                          //   direction:
                                                          //       Axis.horizontal,
                                                          //   allowHalfRating:
                                                          //       true,
                                                          //   itemCount: 5,
                                                          //   itemSize: 17,
                                                          //   itemPadding: EdgeInsets
                                                          //       .symmetric(
                                                          //           horizontal:
                                                          //               0.0),
                                                          //   itemBuilder:
                                                          //       (context, _) =>
                                                          //           Icon(
                                                          //     Icons.star,
                                                          //     color: Color(
                                                          //         0xffFFAD1E),
                                                          //   ),
                                                          //   onRatingUpdate:
                                                          //       (rating) {
                                                          //     print(rating);
                                                          //   },
                                                          // ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 2,
                                                                      right: 2),
                                                              child: Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                          text:
                                                                              '5,485 '),
                                                                      TextSpan(
                                                                          text:
                                                                              'تقييم'),
                                                                    ],
                                                                  ),
                                                                  style: TextStyle(
                                                                      color:
                                                                          GREY_COLOR,
                                                                      fontSize:
                                                                          12)))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                                child: Text(
                                                  "تفاصيل المنتج: ",
                                                  style: TextStyle(
                                                      color: BLACK_COLOR,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 15),
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                                child: Text(
                                                  "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد النصوص الأخرى إضاف إلى زيادة عدد الحروف التى يولدها التطبيق",
                                                  style: TextStyle(
                                                      color: GREY_COLOR,
                                                      fontSize: 12,
                                                      height: 1.6),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 0,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // height: 70,
                                        color: Colors.transparent,
                                        child: ProductSliderWidget(),
                                      )),
                                ],
                              ),

                              // Align(
                              //   alignment: Alignment.center,
                              // child: Image.asset('assets/images/hand-held-circular-saw-bosch.png', width: 196, height: 181,),
                              // ),

                              // create widgets for each tab bar here

                              DefaultTabController(
                                  length: 3, // length of tabs
                                  initialIndex: 0,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: WHITE_COLOR,
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 192, 191, 191),
                                                      width: 0.5))),

                                          //  transform: Matrix4.translationValues(0.0,2.6, 0.0),
                                          child: TabBar(
                                            labelColor: BLACK_COLOR,
                                            indicatorColor: AMBER_COLOR,
                                            indicatorSize:
                                                TabBarIndicatorSize.tab,
                                            indicatorWeight: 2,
                                            unselectedLabelColor: GREY_COLOR,
                                            dragStartBehavior:
                                                DragStartBehavior.start,
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "URW",
                                                fontSize: 13),
                                            unselectedLabelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                fontFamily: "URW",
                                                color: GREY_COLOR),
                                            tabs: [
                                              Tab(
                                                  text:
                                                      'Product Description'.tr),
                                              Tab(
                                                  text:
                                                      'Product Attributes'.tr),
                                              Tab(text: 'Comments'.tr),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            height: 210,
                                            //height of TabBarView
                                            decoration: BoxDecoration(
                                              color: WHITE_COLOR,
                                            ),
                                            child: TabBarView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.all(12),
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      child: Text(
                                                          'إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، إذا كنت تحتاج إلى عدد أكبر من الفقرات',
                                                          style: TextStyle(
                                                              letterSpacing: 2,
                                                              height: 1.9,
                                                              fontSize: 12,
                                                              fontFamily: "URW",
                                                              color: GREY_COLOR,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                  Container(
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          ProductAttributeItem(
                                                              name: 'اسم اللون',
                                                              value: "ازرق",
                                                              color:
                                                                  WHITE_COLOR),
                                                          ProductAttributeItem(
                                                              name: 'الوزن',
                                                              value: "5.000",
                                                              color:
                                                                  FILL_COLOR),
                                                          ProductAttributeItem(
                                                              name:
                                                                  'بلد المنشأ',
                                                              value: "ألمانيا",
                                                              color:
                                                                  WHITE_COLOR),
                                                          ProductAttributeItem(
                                                              name: 'الموديل',
                                                              value:
                                                                  "TA-667739 s",
                                                              color:
                                                                  FILL_COLOR),
                                                          ProductAttributeItem(
                                                              name: 'الماركة',
                                                              value:
                                                                  "توتال تولرز",
                                                              color:
                                                                  WHITE_COLOR),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 10),
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "حسن سعيد",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                BLACK_COLOR,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              12),
                                                                      // RatingBar
                                                                      //     .builder(
                                                                      //   // tapOnlyMode: true,
                                                                      //   initialRating:
                                                                      //       4,
                                                                      //   unratedColor:
                                                                      //       Color(0xffEBEBE9),
                                                                      //   minRating:
                                                                      //       1,
                                                                      //   direction:
                                                                      //       Axis.horizontal,
                                                                      //   allowHalfRating:
                                                                      //       true,
                                                                      //   itemCount:
                                                                      //       5,
                                                                      //   itemSize:
                                                                      //       12,
                                                                      //   itemPadding:
                                                                      //       EdgeInsets.symmetric(horizontal: 0.0),
                                                                      //   itemBuilder:
                                                                      //       (context, _) =>
                                                                      //           Icon(
                                                                      //     Icons
                                                                      //         .star,
                                                                      //     color:
                                                                      //         Color(0xffFFAD1E),
                                                                      //   ),
                                                                      //   onRatingUpdate:
                                                                      //       (rating) {
                                                                      //     print(
                                                                      //         rating);
                                                                      //   },
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    "منذ 10 دقائق",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            GREY_COLOR),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                              child: Text(
                                                                "إذا كنت تحتاج الي عدد اكبر من الفقرات يتيح لك مولد النص العربي زيادة عدد الفقرات كما تريد ، النص لن يبدو مقسماً",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color:
                                                                        GREY_COLOR),
                                                              ),
                                                            ),
                                                            Divider(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "حسن سعيد",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                BLACK_COLOR,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              12),
                                                                      // RatingBar
                                                                      //     .builder(
                                                                      //   // tapOnlyMode: true,
                                                                      //   initialRating:
                                                                      //       4,
                                                                      //   unratedColor:
                                                                      //       Color(0xffEBEBE9),
                                                                      //   minRating:
                                                                      //       1,
                                                                      //   direction:
                                                                      //       Axis.horizontal,
                                                                      //   allowHalfRating:
                                                                      //       true,
                                                                      //   itemCount:
                                                                      //       5,
                                                                      //   itemSize:
                                                                      //       12,
                                                                      //   itemPadding:
                                                                      //       EdgeInsets.symmetric(horizontal: 0.0),
                                                                      //   itemBuilder:
                                                                      //       (context, _) =>
                                                                      //           Icon(
                                                                      //     Icons
                                                                      //         .star,
                                                                      //     color:
                                                                      //         Color(0xffFFAD1E),
                                                                      //   ),
                                                                      //   onRatingUpdate:
                                                                      //       (rating) {
                                                                      //     print(
                                                                      //         rating);
                                                                      //   },
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child: Text(
                                                                    "منذ 10 دقائق",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            GREY_COLOR),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                              child: Text(
                                                                "إذا كنت تحتاج الي عدد اكبر من الفقرات يتيح لك مولد النص العربي زيادة عدد الفقرات كما تريد ، النص لن يبدو مقسماً",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color:
                                                                        GREY_COLOR),
                                                              ),
                                                            ),
                                                            Divider(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () =>
                                                              showModalBottomSheet<
                                                                  void>(
                                                            context: context,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            30),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            30))),
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xfffcfcfc),
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                30),
                                                                        topRight:
                                                                            Radius.circular(30))),
                                                                height: MediaQuery.of(context)
                                                                            .size
                                                                            .height /
                                                                        2 +
                                                                    30,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      height: 3,
                                                                      width: 56,
                                                                      decoration: BoxDecoration(
                                                                          color: GREY_COLOR.withOpacity(
                                                                              0.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12)),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              20,
                                                                              20,
                                                                              0,
                                                                              0),
                                                                      alignment:
                                                                          AlignmentDirectional
                                                                              .centerStart,
                                                                      child:
                                                                          Text(
                                                                        "إضافة تعليق",
                                                                        style: TextStyle(
                                                                            color:
                                                                                BLACK_COLOR,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            20),
                                                                    // RatingBar
                                                                    //     .builder(
                                                                    //   // tapOnlyMode: true,
                                                                    //   initialRating:
                                                                    //       0,
                                                                    //   unratedColor:
                                                                    //       Color(
                                                                    //           0xffEBEBE9),
                                                                    //   minRating:
                                                                    //       1,
                                                                    //   direction:
                                                                    //       Axis.horizontal,
                                                                    //   allowHalfRating:
                                                                    //       true,
                                                                    //   itemCount:
                                                                    //       5,
                                                                    //   itemSize:
                                                                    //       40,
                                                                    //   itemPadding:
                                                                    //       EdgeInsets.symmetric(
                                                                    //           horizontal: 0.0),
                                                                    //   itemBuilder:
                                                                    //       (context, _) =>
                                                                    //           Icon(
                                                                    //     Icons
                                                                    //         .star,
                                                                    //     color: Color(
                                                                    //         0xffFFAD1E),
                                                                    //   ),
                                                                    //   onRatingUpdate:
                                                                    //       (rating) {
                                                                    //     print(
                                                                    //         rating);
                                                                    //   },
                                                                    // ),
                                                                    Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              15),
                                                                      child:
                                                                          Text(
                                                                        "برجاء النقر على النجوم حتى تتمكن من إضافة تقييمك",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                GREY_COLOR,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              20,
                                                                              20,
                                                                              0,
                                                                              0),
                                                                      alignment:
                                                                          AlignmentDirectional
                                                                              .centerStart,
                                                                      child:
                                                                          Text(
                                                                        "تعليقك",
                                                                        style: TextStyle(
                                                                            color:
                                                                                BLACK_COLOR,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10,
                                                                          horizontal:
                                                                              20),
                                                                      child:
                                                                          TextFormField(
                                                                        minLines:
                                                                            3, // any number you need (It works as the rows for the textarea)
                                                                        keyboardType:
                                                                            TextInputType.multiline,
                                                                        maxLines:
                                                                            null,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              "برجاء كتابه تعليقك",
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 12,
                                                                              color: GREY_COLOR),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: GREY_COLOR.withOpacity(0.3)), //<-- SEE HERE
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              WHITE_COLOR,
                                                                          // boxShadow: [
                                                                          //   BoxShadow(
                                                                          //     color: Color(0xfffefefe),
                                                                          //     spreadRadius: 5,
                                                                          //     blurRadius: 10,
                                                                          //     offset: Offset(0, 8), // changes position of shadow
                                                                          //   ),
                                                                          // ],
                                                                          boxShadow: <
                                                                              BoxShadow>[
                                                                            BoxShadow(
                                                                                spreadRadius: 10,
                                                                                color: Color.fromARGB(255, 241, 241, 241),
                                                                                blurRadius: 15.0,
                                                                                offset: Offset(0.5, 0.75))
                                                                          ],
                                                                        ),
                                                                        width:
                                                                            MediaQuery.of(context).size.width -
                                                                                0,
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(25),

                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: PRIMARY_COLOR,
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              "إضافة التعليق",
                                                                              style: TextStyle(color: WHITE_COLOR, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),

                                                                          //       child: ElevatedButton(
                                                                          //   style: ElevatedButton.styleFrom(
                                                                          //         primary: PRIMARY_COLOR,
                                                                          //         // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                                                          //         textStyle: TextStyle(fontSize: 16, color: WHITE_COLOR, fontWeight: FontWeight.bold)),
                                                                          //   child:
                                                                          //         const Text(
                                                                          //       '',
                                                                          //       style:
                                                                          //           TextStyle(fontFamily: "URW"),
                                                                          //   ),
                                                                          //   onPressed:
                                                                          //         () =>
                                                                          //             print("object"),
                                                                          // ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 8),
                                                            alignment: Alignment
                                                                .center,
                                                            height: 42,
                                                            width: double.parse(
                                                                "300"),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color:
                                                                        AMBER_COLOR),
                                                                color: AMBER_COLOR
                                                                    .withOpacity(
                                                                        0.10)),
                                                            child: Text(
                                                              "اكتب تعليقك",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      AMBER_COLOR),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]))
                                      ])),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: WHITE_COLOR,
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    // primary: GetStorage().read('app_type') == 'tools' ? Color(0xffd32026): Color(0xff0A458B),
                                
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  controller.changeLanguage(
                                      controller.selectLocale.toString());
                                  showModalBottomSheet<void>(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30))),
                                      builder: (BuildContext context) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xfffcfcfc),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight:
                                                      Radius.circular(30))),
                                          height: 285,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              // Container(
                                              //   margin: EdgeInsets.only(top: 8),
                                              //   height: 3,
                                              //   width: 56,
                                              //   decoration: BoxDecoration(
                                              //       color: GREY_COLOR
                                              //           .withOpacity(0.5),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               12)),
                                              // ),

                                             Padding(padding: EdgeInsets.only(top: 20), child: SvgPicture.asset('assets/icons/check.svg'),),
                                             
                                              
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 15, horizontal: 30),
                                                    alignment: Alignment.center,
                                                child: Text(
                                                  "تهانينا ! تم إضافة المنتجات المختارة إلى سلة المشتريات",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: BLACK_COLOR,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              
                                              
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: WHITE_COLOR,
                                                    // boxShadow: [
                                                    //   BoxShadow(
                                                    //     color: Color(0xfffefefe),
                                                    //     spreadRadius: 5,
                                                    //     blurRadius: 10,
                                                    //     offset: Offset(0, 8), // changes position of shadow
                                                    //   ),
                                                    // ],
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(
                                                          spreadRadius: 10,
                                                          color: Color.fromARGB(
                                                              255,
                                                              241,
                                                              241,
                                                              241),
                                                          blurRadius: 15.0,
                                                          offset:
                                                              Offset(0.5, 0.75))
                                                    ],
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      0,
                                                  child: Container(
                                                    padding: EdgeInsets.all(25),

                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () => Get.toNamed('/checkout'),
                                                            child: Container(
                                                              alignment:
                                                                  Alignment.center,
                                                              decoration: BoxDecoration(
                                                                color: PRIMARY_COLOR,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(8),
                                                              ),
                                                              child: Text(
                                                                "إتمام عملية الشراء",
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                    color: WHITE_COLOR,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 20,),
                                                         Expanded(
                                                           child:GestureDetector(
                                                             onTap: () => Get.toNamed('/main'),
                                                             child: Container(
                                                              alignment:
                                                                  Alignment.center,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: GREY_COLOR.withOpacity(0.5), width: 1),
                                                                color: FILL_COLOR,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(8),
                                                              ),
                                                              child: Text(
                                                                "منتجات اخري",
                                                                style: TextStyle(
                                                                   fontSize: 16,
                                                                    color: BLACK_COLOR,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                                                                                   ),
                                                           ),
                                                         ),
                                                      ],
                                                    ),

                                                   
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      });

                                  // Get.toNamed('/checkout');
                                },
                                child: InkWell(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Add To Cart".tr,
                                        style: TextStyle(fontFamily: 'URW'),
                                      ),
                                      Text(
                                        "EGP 150.00",
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 54,
                              decoration: new BoxDecoration(
                                  border: Border.all(color: Color(0xffF2F2F2)),
                                  color: Color(0xffFBFBFB),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  )),
                              margin: EdgeInsetsDirectional.only(end: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/min.svg',
                                    width: 30,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 9),
                                    child: Text(
                                      "2",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/add.svg',
                                    width: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              })),
    );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
              //  width: 50.00,
              height: 58.00,

              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                image: new DecorationImage(
                    scale: 7, image: AssetImage("img/tool-01.jpeg")),
                color: Color.fromARGB(255, 228, 228, 228),
              ),
            )),
        SizedBox(
          width: 5,
        ),
        Expanded(
            flex: 7,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "ادوات مقعد",
                  style: TextStyle(fontSize: 10, color: GREY_COLOR),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "شنيور عادة و دقاق يمينس",
                  style: TextStyle(
                      color: BLACK_COLOR,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      Text(
                        "EGP 150.00",
                        style: TextStyle(
                            color: Color(0xffEF3939),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("EGP 180.00",
                          style: TextStyle(
                            fontSize: 11,
                            color: GREY_COLOR,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                          ))
                    ],
                  ),
                )
              ],
            )),
        Container(
          decoration: new BoxDecoration(
              border: Border.all(color: Color(0xffF2F2F2)),
              color: Color(0xffFBFBFB),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
          width: 92,
          margin: EdgeInsetsDirectional.only(end: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/min.svg'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                child: Text(
                  "2",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              SvgPicture.asset('assets/icons/add.svg')
            ],
          ),
        ),
      ],
    );
  }
}

class ProductAttributeItem extends StatelessWidget {
  final String name;
  final String value;
  final Color? color;
  const ProductAttributeItem(
      {Key? key, required this.name, this.color, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: color,
      child: Row(
        children: [
          Expanded(
              child: Text(
            name,
            style: TextStyle(
                fontSize: 12, color: TEXT_COLOR, fontWeight: FontWeight.w600),
          )),
          Expanded(
              child: Text(
            value == "" ? "--" : value,
            style: TextStyle(
                fontSize: 12, color: BLACK_COLOR, fontWeight: FontWeight.w600),
          ))
        ],
      ),
    );
  }
}
