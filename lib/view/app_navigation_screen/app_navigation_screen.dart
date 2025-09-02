import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFFFFFFF),
        body: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              _buildAppNavigation(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF),
                    ),
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "feature ads - Container",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Login One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Choose Language",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Login",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create account One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create account Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Create account",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Ads Details One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Ads Details Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Ads Details",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Ads Details Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Home One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Filter Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up Seven",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Filter Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Filter",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Filter One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Search One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Search",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Search Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up Six",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Notification",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Notification One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "More One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "More",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "contact us",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "contact us One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "contact us Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "My ads",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "My fav",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "preference",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Wallet Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Wallet",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Wallet Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Wallet One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Wallet Five",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Wallet Four",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up Five",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up Four",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Message One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "messge Two",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "message Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "message Four",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "message Five",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "message Six",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "message Seven",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "contact us Five",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "contact us Four",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "contact us Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Share your adds",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Share your adds Two - Tab Container",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Share your adds Three",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Share your adds Five",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Share your adds Seven",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "Share your adds One",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up Eight",
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "pop up Nine",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "App Navigation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "Check your app's UI from the below demo screens of your app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF888888),
                  fontSize: 16.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: Color(0XFF000000),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF000000),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: Color(0XFF888888),
          ),
        ],
      ),
    );
  }

  /// Common click event
  void onTapScreenTitle(
    BuildContext context,
    String routeName,
  ) {
    Navigator.pushNamed(context, routeName);
  }
}
