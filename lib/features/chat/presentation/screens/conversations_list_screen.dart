import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/chat/presentation/controllers/conversations_controller.dart';
import 'package:sagr/features/chat/presentation/widgets/chat_item_widget.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_search_view.dart';

import 'package:flutter/material.dart';

class ConversationListScreen extends StatelessWidget {
  final ConversationsController _controller;
  ConversationListScreen(this._controller, {Key? key})
      : super(
          key: key,
        );

  final TextEditingController searchController = TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: WHITE_COLOR,
            leadingWidth: 39.h,
            toolbarHeight: 66,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgArrowDown,
              margin: EdgeInsets.only(
                left: 16.h,
                top: 16.v,
                bottom: 16.v,
              ),
            ),
            title: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Message ",
                      style: CustomTextStyles.titleLargeff333333,
                    ),
                    TextSpan(
                      text: "(${_controller.conversations.length})",
                      style: CustomTextStyles.titleMediumffd20653,
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            )),
        body: Obx(() =>  _controller.isLoadingList == true ?  Center(child: CircularProgressIndicator(),) : _controller.conversations.length == 0
            ? SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.v),
                    CustomImageView(
                      imagePath: ImageConstant.imgNoMessage,
                      height: 172.v,
                      width: 212.h,
                    ),
                    SizedBox(height: 12.v),
                    Text(
                      "There are no messages",
                      style: CustomTextStyles.bodyMediumGray60001,
                    ),
                  ],
                ),
              )
            : Container(
                // width: double.maxFinite,
                padding: EdgeInsets.all(16.h),
                child: Column(
                  children: [
                    CustomSearchView(
                      controller: searchController,
                      hintText: "Search Direct Messages ...",
                      hintStyle: theme.textTheme.bodySmall!,
                    ),
                    SizedBox(height: 8.v),
                    Expanded(child: _buildUserProfile(context)),
                  ],
                ),
              )),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return Obx(() => SmartRefresher(
        controller: _controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        onRefresh: _controller.onRefresh,
        onLoading: _controller.onLoading,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = _controller.conversations.length > 0
                  ? Text("Pull up load")
                  : Text("");
            } else if (mode == LoadStatus.loading) {
              body = CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("");
            }

            if (_controller.hasMore == false) {
              body = Text("");
            }

            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (
            context,
            index,
          ) {
            return SizedBox(
              height: 8.v,
            );
          },
          itemCount: _controller.conversations.length,
          itemBuilder: (context, index) {
            return ChatItemWidget(_controller.conversations.elementAt(index));
          },
        )));
  }

}
