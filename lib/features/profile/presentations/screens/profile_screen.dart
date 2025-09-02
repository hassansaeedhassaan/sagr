import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/app/view_model/profile/profile_controller.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/auth/login_screen.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../view/contact_us_screen/contact_us_screen.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_image_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    // Widget listCardWidget({required String text1, required text2}) {
    //   return Card(
    //     margin: const EdgeInsets.all(8.0),
    //     elevation: 5.0,
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           Flexible(
    //               fit: FlexFit.tight,
    //               child: Text(
    //                 text1,
    //                 style: const TextStyle(fontSize: 18),
    //               )),
    //           Flexible(
    //             flex: 2,
    //             fit: FlexFit.tight,
    //             child: Text(
    //               text2,
    //               style: const TextStyle(
    //                   fontSize: 20.0, fontWeight: FontWeight.bold),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

// return CustomScrollView(
//         slivers: [
//           SliverPersistentHeader(
//             pinned: true,
//             delegate: MySliverAppBar(expandedHeight: 200.0),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate([
//               const SizedBox(
//                 height: 120,
//               ),
//               listCardWidget(text1: 'Full Name:', text2: 'George John Carter'),
//               listCardWidget(text1: 'Father\'s Name:', text2: 'John Carter'),
//               listCardWidget(text1: 'Gender:', text2: 'Male'),
//               listCardWidget(text1: 'Marital Status:', text2: 'Single'),
//               listCardWidget(text1: 'Email:', text2: 'jane123@123.com'),
//               listCardWidget(text1: 'Username:', text2: 'misty123'),
//               listCardWidget(text1: 'Phone:', text2: '0987654321'),
//               listCardWidget(text1: 'Country', text2: 'India'),
//               listCardWidget(text1: 'City', text2: 'Hyderabad'),
//               listCardWidget(text1: 'Pincode:', text2: '500014'),
//               listCardWidget(text1: 'Company:', text2: 'All Shakes'),
//               listCardWidget(text1: 'Website:', text2: 'allshakes.com'),
//               listCardWidget(text1: 'Position', text2: 'Manager'),
//               listCardWidget(text1: 'LinkedIn Id:', text2: 'misty123'),
//               listCardWidget(text1: 'Interest:', text2: 'Swimming,Cycling'),
//             ]),
//           )
//         ],
//       );
    // return MasterWrapper(body: CustomScrollView(
    //   slivers: [
    //     SliverAppBar(
    //       backgroundColor: BLACK_COLOR,
    //         expandedHeight: 140.0,
    //         pinned: true,
    //         flexibleSpace: FlexibleSpaceBar(
    //           title:  Text(" حسابي", style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),),
    //           expandedTitleScale: 1.6,
    //           collapseMode: CollapseMode.parallax,
    //           titlePadding: EdgeInsets.only(bottom: 15, right: 15),
    //           centerTitle: false,
    //           background: Stack(
    //             fit: StackFit.expand,
    //             children: [
    //               Image.asset(
    //                 "assets/images/cover.jpg",
    //                 fit: BoxFit.cover,
    //               ),
    //               Container(
    //                 color: Colors.black.withOpacity(0.4), // Adds transparency
    //               ),
    //             ],
    //           ),
    //         ),
    //         actions: [
    //           IconButton(
    //             color: WHITE_COLOR,
    //             icon: const Icon(Icons.settings),
    //             onPressed: () {
    //               // Add settings action
    //             },
    //           ),
    //         ],
    //       ),

    //       SliverList(
    //         delegate: SliverChildListDelegate(
    //           [
    //             const SizedBox(height: 20),
    //             Center(
    //               child: CircleAvatar(
    //                 radius: 60,
    //                 backgroundColor: WHITE_COLOR,
    //                 backgroundImage: AssetImage(
    //                   "assets/images/sagr-logo.png",

    //                 ),
    //               ),
    //             ),
    //             const SizedBox(height: 10),
    //             const Center(
    //               child: Text(
    //                 "عوض عمار بريكة",
    //                 style: TextStyle(
    //                   fontSize: 24,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),

    //             ),

    //              const SizedBox(height: 10),
    //             const Center(
    //               child: Text(
    //                 "20093885",
    //                 style: TextStyle(
    //                   fontSize: 14,
    //                   color: Colors.grey,
    //                 ),
    //               ),
    //             ),

    //             const SizedBox(height: 10),
    //             const Center(
    //               child: Text(
    //                 "0096659948387",
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   color: Colors.grey,
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(height: 30),
    //             ListTile(
    //               leading: const Icon(Icons.email),
    //               title: const Text("Email"),
    //               subtitle: const Text("john.doe@example.com"),
    //               onTap: () {
    //                 // Add action
    //               },
    //             ),
    //             ListTile(
    //               leading: const Icon(Icons.phone),
    //               title: const Text("Phone"),
    //               subtitle: const Text("+1234567890"),
    //               onTap: () {
    //                 // Add action
    //               },
    //             ),
    //             ListTile(
    //               leading: const Icon(Icons.location_on),
    //               title: const Text("Address"),
    //               subtitle: const Text("123, Main Street, City, Country"),
    //               onTap: () {
    //                 // Add action
    //               },
    //             ),
    //              ListTile(
    //               leading: const Icon(Icons.location_on),
    //               title: const Text("Address"),
    //               subtitle: const Text("123, Main Street, City, Country"),
    //               onTap: () {
    //                 // Add action
    //               },
    //             ),

    //              ListTile(
    //               leading: const Icon(Icons.location_on),
    //               title: const Text("Address"),
    //               subtitle: const Text("123, Main Street, City, Country"),
    //               onTap: () {
    //                 // Add action
    //               },
    //             ),

    //              ListTile(
    //               leading: const Icon(Icons.location_on),
    //               title: const Text("Address"),
    //               subtitle: const Text("123, Main Street, City, Country"),
    //               onTap: () {
    //                 // Add action
    //               },
    //             ),

    //              ListTile(
    //               leading: const Icon(Icons.location_on),
    //               title: const Text("Address"),
    //               subtitle: const Text("123, Main Street, City, Country"),
    //               onTap: () {
    //                 // Add action
    //               },
    //             ),

    //              ListTile(
    //               leading: const Icon(Icons.location_on),
    //               title: const Text("Address"),
    //               subtitle: const Text("123, Main Street, City, Country"),
    //               onTap: () {
    //                 // Add action
    //               },
    //             ),
    //             const SizedBox(height: 30),
    //             Center(
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   // Add button action
    //                 },
    //                 child: const Text("Edit Profile"),
    //               ),
    //             ),
    //             const SizedBox(height: 30),
    //           ],
    //         ),
    //       ),

    //   ],
    // ));

    return MasterWrapper(
        body: Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: Size.fromHeight(77.0), child: BuildCoreAppBar()),
      // appBar: AppBar(title: Text("Profile".tr), backgroundColor: WHITE_COLOR,excludeHeaderSemantics: true, scrolledUnderElevation: 0,),
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 0),
        padding: EdgeInsets.all(16.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              // _controller.isLoading ? CircularProgressIndicator() : Text(_controller.customerModel.name!),

              Container(
                padding: EdgeInsets.all(12.h),

                // decoration: AppDecoration.linear.copyWith(
                //   borderRadius: BorderRadiusStyle.roundedBorder12,
                // ),

                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(12)),
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
                            Text(
                              "Ahmed Alayshy",
                              style: CustomTextStyles
                                  .titleMediumOnPrimarySemiBold
                                  .copyWith(color: BLACK_COLOR),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '+9665746663478',
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
                                      '78236478',
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
              // GetStorage().read('userData') == null
              //     ? _buildWelcomeFrame(context)
              //     : _buildCardProfileInfo(context),

              SizedBox(height: 15.v),

              Column(children: [
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactUsScreen()))
                  },
                  child: _buildFrameRow(
                    context,
                    thumbsUpImage: ImageConstant.imgLock,
                    walletLabel: "Edit Profile".tr,
                    arrowRightImage: ImageConstant.imgArrowRightGray50001,
                  ),
                ),

                
                SizedBox(height: 12),
      
                Container(
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
                          imagePath: ImageConstant.imgVuesaxTwotoneCard,
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
                          "My Resume".tr,
                          style: CustomTextStyles.titleMediumOnErrorContainer
                              .copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      Spacer(),
                    
                    Icon(Icons.download)
                    ],
                  ),
                ),

// _buildFrameRow(
//                             context,
//                             thumbsUpImage: ImageConstant.imgVuesaxTwotoneStar,
//                             walletLabel: "Ratings".tr,
//                             arrowRightImage:
//                                 ImageConstant.imgArrowRightGray50001,
//                           ),

                SizedBox(height: 12),
                Container(
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
                          imagePath: ImageConstant.imgVuesaxTwotoneStar,
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
                          "Ratings".tr,
                          style: CustomTextStyles.titleMediumOnErrorContainer
                              .copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      Spacer(),
                      RotatedBox(
                        quarterTurns: 180,
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                        // child: CustomImageView(
                        //   imagePath: arrowRightImage,
                        //   height: 20.adaptSize,
                        //   width: 20.adaptSize,
                        //   margin: EdgeInsets.symmetric(vertical: 14.v),
                        // ),
                      ),
                    ],
                  ),
                ),


                 SizedBox(height: 12),
                Container(
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
                          imagePath: ImageConstant.imgShare,
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
                          "My Shares".tr,
                          style: CustomTextStyles.titleMediumOnErrorContainer
                              .copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                      Spacer(),
                     Text("5", style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ),


//                           GestureDetector(
//                   onTap: () => Get.toNamed('/about', arguments: 'payment-fees'),
//                   child: _buildContactFrame(
//                     context,
//                     callImage: ImageConstant.imgTelevision,
//                     label: "Advertisements".tr,
//                   )),

//               SizedBox(height: 8.v),

//                 GestureDetector(
//                   onTap: () => Get.toNamed('/about', arguments: 'payment-fees'),
//                   child: _buildContactFrame(
//                     context,
//                     callImage: ImageConstant.imgCheckmarkIcon,
//                     label: "Previous Events".tr,
//                   )),

//               SizedBox(height: 8.v),

//                 GestureDetector(
//                   onTap: () => Get.toNamed('/about', arguments: 'payment-fees'),
//                   child: _buildContactFrame(
//                     context,
//                     callImage: ImageConstant.imgCheckmarkIcon,
//                     label: "My Events".tr,
//                   )),

//               SizedBox(height: 8.v),

//   GestureDetector(
//                   onTap: () => Get.toNamed('/about', arguments: 'payment-fees'),
//                   child: _buildContactFrame(
//                     context,
//                     callImage: ImageConstant.imgCheckmarkIcon,
//                     label: "Events Calender".tr,
//                   )),

//               SizedBox(height: 8.v),

// GestureDetector(
//                   onTap: () => Get.toNamed('/about', arguments: 'payment-fees'),
//                   child: _buildContactFrame(
//                     context,
//                     callImage: ImageConstant.imgCheckmarkIcon,
//                     label: "Orders Under Processing".tr,
//                   )),

//               SizedBox(height: 8.v),
              ]),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(context),
    ));
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
