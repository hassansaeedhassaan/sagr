import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/app/view_model/profile/profile_controller.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sagr/features/profile/presentations/screens/profile_screen.dart';
import 'package:sagr/view/auth/login_screen.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../contact_us_screen/contact_us_screen.dart';

class MoreOneScreen extends StatelessWidget {
  const MoreOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
        body: Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: Size.fromHeight(77.0), child: BuildCoreAppBar()),
      // appBar: AppBar(title: Text("Profile".tr), backgroundColor: WHITE_COLOR,excludeHeaderSemantics: true, scrolledUnderElevation: 0,),
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 0),
        // padding: EdgeInsets.all(16.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              // _controller.isLoading ? CircularProgressIndicator() : Text(_controller.customerModel.name!),

          
          

          GetBuilder<AuthController>(
            init: AuthController(),
            builder: (AuthController authController){

              return authController.isLoading ? CircularProgressIndicator():
                Container(
                 margin: EdgeInsets.all(12.h),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.all(12.h),
                   
                  
                    // decoration: AppDecoration.linear.copyWith(
                    //   borderRadius: BorderRadiusStyle.roundedBorder12,
                    // ),
                  
                    decoration: BoxDecoration(
                        // border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(12),
                        
                         boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.2),
                                    spreadRadius:3,
                                    blurRadius: 3,
                                    offset:
                                        Offset(0, 3), // changes position of shadow
                                  ),
                                ],),
                  
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(65.h),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(65.h),
                              child: Image.asset(
                                'assets/images/avatar.png',
                                width: 65,
                              )),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap:  () => Get.toNamed('/create_account'),
                                  child: Text(
                                    "${authController.authenticatedUser!['firstName']} ${authController.authenticatedUser!['middleName']} ${authController.authenticatedUser!['lastName']}",
                                    style: CustomTextStyles
                                        .titleMediumOnPrimarySemiBold
                                        .copyWith(color: BLACK_COLOR),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${authController.authenticatedUser!['phone']??"--".tr}',
                                        style: CustomTextStyles.titleSmallOnPrimary
                                            .copyWith(color: BLACK_COLOR),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: BLACK_COLOR,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Text(
                                          '${authController.authenticatedUser!['nationalID']??"--"}',
                                          style:
                                              CustomTextStyles.titleSmallOnPrimary,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }),


              
              // GetStorage().read('userData') == null
              //     ? _buildWelcomeFrame(context)
              //     : _buildCardProfileInfo(context),

              SizedBox(height: 8.v),

              Column(
                children: [

// Directionality(
//   textDirection: TextDirection.ltr,
//   child: TimerCountdown(
//     daysDescription: "Days".tr,
//     secondsDescription: "Seconds".tr,
//     minutesDescription: "Minutes".tr,
//     hoursDescription: "Hours".tr,
//             format: CountDownTimerFormat.daysHoursMinutesSeconds,
//             endTime: DateTime.now().add(
//               Duration(
//                 days: 5,
//                 hours: 14,
//                 minutes: 27,
//                 seconds: 34,
//               ),
//             ),
//             onEnd: () {
//               print("Timer finished");
//             },
//           ),
// ),
// TableCalendar(
//           firstDay: DateTime.utc(2020, 1, 1),
//           lastDay: DateTime.utc(2030, 12, 31),
//           // focusedDay: _focusedDay,
//           // selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
     
        
//          focusedDay: DateTime.now(),
//           calendarBuilders: CalendarBuilders(
//             todayBuilder: (context, date, _) => Container(
//               margin: EdgeInsets.all(4),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 2, 17, 30),
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 '${date.day}',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//             selectedBuilder: (context, date, _) => Container(
//               margin: EdgeInsets.all(4),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 '${date.day}',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//             outsideBuilder: (context, date, _) => Container(
//               alignment: Alignment.center,
//               child: Text(
//                 '${date.day}',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ),
//         ),
//                   TableCalendar(

//                     // locale: "ar",
//   firstDay: DateTime.utc(2010, 10, 16),
//   lastDay: DateTime.utc(2030, 3, 14),
//   pageJumpingEnabled: true,
//   focusedDay: DateTime.now(),
//   calendarBuilders: CalendarBuilders(
//               defaultBuilder: (context, day, focusedDay) {
//                 for (DateTime d in widget.toHighlight) {
//                   if (day.day == d.day &&
//                       day.month == d.month &&
//                       day.year == d.year) {
//                     return Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.lightGreen,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${day.day}',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     );
//                   }
//                 }
//                 return null;
//               },
//             ),
// ),


  //               SfCalendar(
  //   view: CalendarView.workWeek,
  //   timeSlotViewSettings: TimeSlotViewSettings(
  //       startHour: 9,
  //       endHour: 16,
  //       nonWorkingDays: <int>[DateTime.friday, DateTime.saturday]),
  // ),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                     boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius:3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                  ),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen()))
                      },
                      child: _buildFrameRow(
                        context,
                        thumbsUpImage: ImageConstant.imgLock,
                        walletLabel: "Personal Info".tr,
                        arrowRightImage: ImageConstant.imgArrowRightGray50001,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.v),
                
                
                  Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                     boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius:3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                  ),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                    onTap: () =>
                        Get.toNamed('/ads', arguments: 'ads'),
                    child: _buildContactFrame(
                      context,
                      callImage: ImageConstant.imgTelevision,
                      label: "Advertisements".tr,
                    )))),
                SizedBox(height: 8.v),
                   Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius:3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                  ),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                    onTap: () =>
                        Get.toNamed('/previous_events', arguments: {'ed':'previous'}),
                    child: _buildContactFrame(
                      context,
                      callImage: ImageConstant.imgCheckmarkIcon,
                      label: "Previous Events".tr,
                    )))),


Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius:3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                  ),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                    onTap: () =>
                        Get.toNamed('/e_calender', arguments: {'ed':'previous'}),
                    child: _buildContactFrame(
                      context,
                      callImage: ImageConstant.imgCheckmarkIcon,
                      label: "Previous Events Calender".tr,
                    )))),


                    
                SizedBox(height: 8.v),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius:3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                  ),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                    onTap: () => Get.toNamed('/events', arguments:{'es':'my-events'}),
                    child: _buildContactFrame(
                      context,
                      callImage: ImageConstant.imgCheckmarkIcon,
                      label: "My Events".tr,
                    )))),
                SizedBox(height: 8.v),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius:3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                  ),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    child: GestureDetector(
                    onTap: () =>
                        Get.toNamed('/events_calender', arguments: 'payment-fees'),
                    child: _buildContactFrame(
                      context,
                      callImage: ImageConstant.imgCheckmarkIcon,
                      label: "Events Calender".tr,
                    )))),
                SizedBox(height: 8.v),
               Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius:3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                  ),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    child:  GestureDetector(
                    onTap: () =>
                        Get.toNamed('/permissions', arguments: 'permissions'),
                    child: _buildContactFrame(
                      context,
                      callImage: ImageConstant.imgCheckmarkIcon,
                      label: "Orders Under Processing".tr,
                    )))),
                SizedBox(height: 8.v),
              ]),
 Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: 

 GestureDetector(
              onTap: (){
               GetStorage().remove ('access_token');
                GetStorage().remove('userData');
                GetStorage().remove('loggedInUserName');
                GetStorage().remove('loggedInUserPhone');
                Get.offAndToNamed("/login");
              },
              child: Container(
                height: 46,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/logout.png',
                          width: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "تسجيل خروج",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GREY_COLOR),
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: GREY_COLOR,
                    )
                  ],
                ),
              ),
            )),
              SizedBox(height: 20),

              Text(
                "الدعم".tr,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    // border: Border.all(width: 0.0),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "+966566467735",
                          style: TextStyle(fontSize: 16),
                          textDirection: TextDirection.ltr,
                        )
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "sagr@mail.com",
                          style: TextStyle(fontSize: 16),
                          textDirection: TextDirection.ltr,
                        )
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.telegram_sharp,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "sagr@mail.com",
                          style: TextStyle(fontSize: 16),
                          textDirection: TextDirection.ltr,
                        )
                      ],
                    )
                  ],
                ),
              )

              // GetStorage().read('userData') == null
              // ? SizedBox.shrink()
              // : Column(
              //     children: [
              //       GestureDetector(
              //         onTap: () => {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => ContactUsScreen()))
              //         },
              //         child: _buildFrameRow(
              //           context,
              //           thumbsUpImage: ImageConstant.imgLock,
              //           walletLabel: "Personal Info".tr,
              //           arrowRightImage:
              //               ImageConstant.imgArrowRightGray50001,
              //         ),
              //       ),
              //       SizedBox(height: 8.v),
              //       GestureDetector(

              //         onTap: () => Get.toNamed('/wallet_screen'),
              //           // onTap: () => {
              //           //       Navigator.push(
              //           //           context,
              //           //           MaterialPageRoute(
              //           //               builder: (context) => WalletScreen()))
              //           //     },
              //           child: _buildFrameRow(
              //             context,
              //             thumbsUpImage: ImageConstant.imgThumbsUpGray60001,
              //             walletLabel: "Wallet",
              //             arrowRightImage:
              //                 ImageConstant.imgArrowRightGray50001,
              //           )),
              //       SizedBox(height: 8.v),
              //       GestureDetector(
              //           onTap: () => Get.toNamed('/commissions_screen'),
              //           child: _buildFrameRow(
              //             context,
              //             thumbsUpImage: ImageConstant.imgSend,
              //             walletLabel: "My Commissions",
              //             arrowRightImage:
              //                 ImageConstant.imgArrowRightGray50001,
              //           )),
              //       SizedBox(height: 8.v),
              //       GestureDetector(
              //           // onTap: () => {
              //           //       Navigator.push(
              //           //           context,
              //           //           MaterialPageRoute(
              //           //               builder: (context) =>
              //           //                   MyCardsScreen()))
              //           //     },

              //           onTap: ()=> Get.toNamed("/cards_screen"),
              //           child: _buildFrameRow(
              //             context,
              //             thumbsUpImage:
              //                 ImageConstant.imgThumbsUpGray6000124x24,
              //             walletLabel: "My Cards",
              //             arrowRightImage:
              //                 ImageConstant.imgArrowRightGray50001,
              //           )),
              //       SizedBox(height: 8.v),
              //       GestureDetector(
              //           onTap: () => Get.toNamed('/my_ads_screen') ,
              //           child: _buildFrameRow(
              //             context,
              //             thumbsUpImage: ImageConstant.imgSearchGray60001,
              //             walletLabel: "My Ads",
              //             arrowRightImage:
              //                 ImageConstant.imgArrowRightGray50001,
              //           )),
              //       SizedBox(height: 8.v),
              //       GestureDetector(
              //           onTap: () => Get.toNamed('/favorite_ads_screen'),
              //           child: _buildFrameRow(
              //             context,
              //             thumbsUpImage: ImageConstant.imgFavoriteGray60001,
              //             walletLabel: "My Favorite",
              //             arrowRightImage:
              //                 ImageConstant.imgArrowRightGray50001,
              //           )),
              //       SizedBox(height: 8.v),
              //       // SizedBox(height: 12.v),
              //     ],
              //   ),
              // GestureDetector(
              //     onTap: () => {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => PreferenceScreen()))
              //         },
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgGlobeGray60001,
              //       label: "Preference",
              //     )),
              // SizedBox(height: 8.v),
              // GestureDetector(
              //     onTap: () => {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => ContactUsFormScreen()))
              //         },
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgCallGray60001,
              //       label: "Contact us",
              //     )),
              // SizedBox(height: 8.v),
              // GestureDetector(
              //     onTap: () => Get.toNamed('/about', arguments: 'about-us'),
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgVideoCamera,
              //       label: "About us",
              //     )),

              // SizedBox(height: 8.v),
              // GestureDetector(
              //     onTap: () => {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => ContactUsThreeScreen()))
              //         },
              //     child: _buildHowToPremiumFrame(context)),

              // SizedBox(height: 8.v),

              // GestureDetector(
              //     onTap: () =>
              //         Get.toNamed('/about', arguments: 'how-to-be-premium'),
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgVideoCamera,
              //       label: "How to a special advertisement?",
              //     )),

              // SizedBox(height: 8.v),

              // GestureDetector(
              //     onTap: () => Get.toNamed('/about',
              //         arguments: 'selling-and-dealing-instructions'),
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgVideoCamera,
              //       label: "Selling and dealing instruction",
              //     )),

              // SizedBox(height: 8.v),

              // GestureDetector(
              //     onTap: () => Get.toNamed('/about', arguments: 'payment-fees'),
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgTelevision,
              //       label: "Payment Fees",
              //     )),

              // SizedBox(height: 8.v),
              // GestureDetector(
              //     onTap: () => Get.toNamed('/about', arguments: "safety-center"),
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgCheckmarkIcon,
              //       label: "A safety center from exploitation",
              //     )),

              // SizedBox(height: 8.v),
              // GestureDetector(
              //     onTap: () =>
              //         Get.toNamed('/about', arguments: "usage-agreement"),
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgVideoCamera,
              //       label: "Usage agreement",
              //     )),
              // SizedBox(height: 8.v),
              // GestureDetector(
              //     onTap: () =>
              //         Get.toNamed('/about', arguments: "privacy-policy"),
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgVideoCamera,
              //       label: "Privacy policy",
              //     )),

              // SizedBox(height: 8.v),
              // GestureDetector(
              //     onTap: () => Get.toNamed('/about',
              //         arguments: 'prohibited-advertisements'),
              //     child: _buildContactFrame(
              //       context,
              //       callImage: ImageConstant.imgVideoCamera,
              //       label: "Prohibited advertisement",
              //     )),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(context),
    ));
  }

  /// Section Widget
  Widget _buildWelcomeFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 11.h,
        vertical: 9.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 1.h),
                child: Text(
                  "Welcome in Sagr",
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 11.v),
              Padding(
                padding: EdgeInsets.only(left: 1.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Th",
                        style: CustomTextStyles.titleMediumff333333,
                      ),
                      TextSpan(
                        text:
                            "e Largest Classifieds Player in Emerging Markets",
                        style: CustomTextStyles.titleMediumff333333,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 12.v),
              CustomElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(Get.find()))),
                text: "Login / Create Account",
                margin: EdgeInsets.only(left: 1.h),
                buttonStyle: CustomButtonStyles.none,
                decoration:
                    CustomButtonStyles.gradientPrimaryToOrangeDecoration,
              )
            ],
          ),

          // return SizedBox.shrink();
          // return Text(snapshot.data.toString()); //👈 Your valid data here

          SizedBox(height: 2.v),
        ],
      ),
    );
  }

  Widget _buildCardProfileInfo(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(Get.find()),
        builder: (controller) {
          return controller.isLoading
              ? Container(
                  decoration: AppDecoration.linear.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder12,
                  ),
                  padding: EdgeInsets.all(12.h),
                  child: Row(
                    children: [
                      Container(
                        height: 48.adaptSize,
                        width: 48.adaptSize,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(56.h),
                            child: ShimmerLoadingWidget()),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.h,
                          top: 2.v,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 10.adaptSize,
                              width: 120.adaptSize,
                              child: ClipRRect(child: ShimmerLoadingWidget()),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 10.adaptSize,
                              width: 230.adaptSize,
                              child: ClipRRect(child: ShimmerLoadingWidget()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(12.h),
                  decoration: AppDecoration.linear.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(56.h),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(56.h),
                            child: controller.authenticatedUser!['image'] == ""
                                ? CircleAvatar()
                                : Image.network(
                                    controller.authenticatedUser!['image'],
                                    fit: BoxFit.cover,
                                    height: 48.adaptSize,
                                    width: 48.adaptSize,
                                  )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.h,
                          top: 2.v,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.authenticatedUser!['name'],
                              style:
                                  CustomTextStyles.titleMediumOnPrimarySemiBold,
                            ),
                            Text(
                              controller.authenticatedUser!['email'],
                              style: CustomTextStyles.titleSmallOnPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        });
  }

  /// Section Widget
  Widget _buildHowToPremiumFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 250.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 48.adaptSize,
                  width: 48.adaptSize,
                  padding: EdgeInsets.all(11.h),
                  decoration: AppDecoration.fillGray50.copyWith(
                    borderRadius: BorderRadiusStyle.circleBorder24,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgVuesaxLinearCrown,
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 11.v),
                  child: Text(
                    "How to become Special",
                    style: CustomTextStyles.titleMediumOnErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRightGray50001,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.symmetric(vertical: 14.v),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildContactFrame(
    BuildContext context, {
    required String callImage,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48.adaptSize,
            width: 48.adaptSize,
            padding: EdgeInsets.all(12.h),
            decoration: AppDecoration.fillGray50.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder24,
            ),
            child: CustomImageView(
              imagePath: callImage,
              height: 24.adaptSize,
              width: 24.adaptSize,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.h,
              top: 11.v,
              bottom: 11.v,
            ),
            child: Text(
              label,
              style: CustomTextStyles.titleMediumOnErrorContainer.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          Spacer(),
          RotatedBox(
            quarterTurns: 90,
            child: CustomImageView(
              imagePath: ImageConstant.imgArrowRightGray50001,
              height: 20.adaptSize,
              width: 20.adaptSize,
              margin: EdgeInsets.symmetric(vertical: 14.v),
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildFrameRow(
    BuildContext context, {
    required String thumbsUpImage,
    required String walletLabel,
    required String arrowRightImage,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 8.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48.adaptSize,
            width: 48.adaptSize,
            padding: EdgeInsets.all(12.h),
            decoration: AppDecoration.fillGray50.copyWith(
              borderRadius: BorderRadiusStyle.circleBorder24,
            ),
            child: CustomImageView(
              imagePath: thumbsUpImage,
              height: 24.adaptSize,
              width: 24.adaptSize,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.h,
              top: 11.v,
              bottom: 11.v,
              right: 10.v,
            ),
            child: Text(
              walletLabel,
              style: CustomTextStyles.titleMediumOnErrorContainer.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          Spacer(),
          RotatedBox(
            quarterTurns: 90,
            child: CustomImageView(
              imagePath: arrowRightImage,
              height: 20.adaptSize,
              width: 20.adaptSize,
              margin: EdgeInsets.symmetric(vertical: 14.v),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 36),
          decoration: AppDecoration.linear.copyWith(
            border: Border.all(width: 0),
            borderRadius: BorderRadiusStyle.roundedBorder12,
          ),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFFEBEBF4),
            Color.fromARGB(255, 243, 243, 243),
            Color(0xFFEBEBF4),
          ],
          stops: [
            0.1,
            0.3,
            0.4,
          ],
          begin: Alignment(-1.0, -0.3),
          end: Alignment(1.0, 0.3),
          tileMode: TileMode.clamp,
        ));
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff8360c3),
                Color(0xff2ebf91),
              ],
            ),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: const Text(
              'My Profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 4 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              children: [
                const Text(
                  'Check out my Profile',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SizedBox(
                    height: expandedHeight,
                    width: MediaQuery.of(context).size.width / 2,
                    child: CircularProfileAvatar(
                      '',
                      child: Image.asset(
                        'assets/images/avatar.png',
                        fit: BoxFit.fill,
                      ),
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.yellow,
                      borderWidth: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
