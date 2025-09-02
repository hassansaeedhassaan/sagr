import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import 'package:flutter/material.dart';

class MyFavoriteScreen extends StatelessWidget {
  MyFavoriteScreen({Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      
      appBar: AppBar(
        title: Text("My Favorite"),
        scrolledUnderElevation: 0,
        backgroundColor: WHITE_COLOR,
        toolbarHeight: 66,
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(height: 16.v),
            // _buildUserProfile(context),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(context),
    );
  }

}
