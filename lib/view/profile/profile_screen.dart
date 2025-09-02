
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/view/profile/EditProfile/view.dart';
import 'package:sagr/view/profile/profileWidgets.dart';

import '../../app/view_model/profile/profile_controller.dart';
import '../../data/colors.dart';
import '../widgets/Breadcrumb.dart';
import '../widgets/fixed_app_bottom_bars.dart';
import 'copounsWidget.dart';
import 'ordersWidget.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController _controller;

  String value = 'building';
 
  ProfileScreen(this._controller, {Key? key}) : super(key: key);

  int index = 1;

  Widget button(Function()? function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  onTapFunction(int value) {
    // setState(() {
    index = value;
    // });
    print(index);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (ProfileController controller) {
        return MasterWrapper(
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15),
            children: [
              Breadcrumb(),
              SizedBox(height: 5),
              profileImage(() => Get.to(() => EditProfile())),
              SizedBox(height: 20),
              profileTabs(controller.tabIndex, () {
                controller.changeTabIndex(0);
              }, () {
                controller.changeTabIndex(1);
              }),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Visibility(
                  visible: (controller.tabIndex == 0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (contex, index) => myOrder(3)),
                  replacement: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (contex, index) => couponWidget(index)),
                ),
              )
            ],
          ),
        );
      },
    );

    // return new Scaffold(
    //   body: GoogleMap(
    //     mapType: MapType.hybrid,
    //     initialCameraPosition: _kGooglePlex,
    //     onMapCreated: (GoogleMapController controller) {
    //       _controllerMap.complete(controller);
    //     },
    //   ),
    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: _goToTheLake,
    //     label: Text('To the lake!'),
    //     icon: Icon(Icons.directions_boat),
    //   ),
    // );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("HOME PAGE"),
    //   ),
    //   body: Obx(() => SmartRefresher(
    //         controller: _controller.refreshController,
    //         enablePullDown: true,
    //         enablePullUp: true,
    //         header: WaterDropHeader(),
    //         onRefresh: _controller.onRefresh,
    //         onLoading: _controller.onLoading,
    //         footer: CustomFooter(
    //           builder: (BuildContext context, LoadStatus mode) {
    //             Widget body;
    //             if (mode == LoadStatus.idle) {
    //               body = Text("Pull up load");
    //             } else if (mode == LoadStatus.loading) {
    //               body = CupertinoActivityIndicator();
    //             } else if (mode == LoadStatus.failed) {
    //               body = Text("Load Failed!Click retry!");
    //             } else if (mode == LoadStatus.canLoading) {
    //               body = Text("release to load more");
    //             } else {
    //               body = Text("No more Data");
    //             }

    //             if (_controller.hasMore == false) {
    //               body = Text("No more Data");
    //             }

    //             return Container(
    //               height: 55.0,
    //               child: Center(child: body),
    //             );
    //           },
    //         ),
    //         child: ListView.builder(
    //             itemCount: _controller.users.length,
    //             itemBuilder: (context, index) {
    //               final user = _controller.users[index];
    //               return ListTile(
    //                 leading: Text(user.id),
    //                 title: Text(user.name),
    //                 subtitle: Text(user.username),
    //               );
    //             }),
    //       )),
    //   drawer: Drawer(
    //     child: Column(
    //       children: [
    //         GestureDetector(
    //           onTap: () {
    //             AuthService.logout();
    //           },
    //           child: Container(
    //             child: Text("Logout"),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
      // padding: EdgeInsets.all(20.0),
      height: 110.0,
      width: 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            // color: Colors.grey[400]?.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/baby.png',
            width: 30.0,
          ),
          SizedBox(
            height: 10,
          ),
          Text("ادوية"),
        ],
      ),
    );
  }
}
