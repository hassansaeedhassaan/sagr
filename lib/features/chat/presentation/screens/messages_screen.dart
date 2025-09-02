import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sagr/features/chat/data/models/message_model.dart';
import 'package:sagr/features/chat/presentation/controllers/messages_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_button_style.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../../../widgets/app_bar/appbar_title_circleimage.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../../../../widgets/custom_image_view.dart';
import '../../../../widgets/custom_outlined_button.dart';
import '../../../../widgets/custom_text_form_field.dart';

class MessagesScreen extends StatelessWidget {
  final MessagesController _controller;

  MessagesScreen(this._controller, {Key? key})
      : super(
          key: key,
        );

  final TextEditingController descriptionEditTextController =
      TextEditingController();

  final TextEditingController messageEditTextController =
      TextEditingController();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
        body: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leadingWidth: 39.h,
          toolbarHeight: 77.h,
          scrolledUnderElevation: 0,
          leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowDown,
            margin: EdgeInsets.only(
              left: 16.h,
              top: 22.v,
              bottom: 22.v,
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Row(
              children: [
                AppbarTitleCircleimage(
                  imagePath: ImageConstant.imgEllipse133,
                ),
                Container(
                  height: 36.199997.v,
                  width: 114.h,
                  margin: EdgeInsets.only(left: 13.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AppbarSubtitleOne(
                        text: "Ahmed Mohamed",
                        margin: EdgeInsets.only(bottom: 16.v),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 21.v,
                            right: 102.h,
                            bottom: 2.v,
                          ),
                          padding: EdgeInsets.all(2.h),
                          decoration: AppDecoration.fillGray5001.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: Container(
                            height: 8.adaptSize,
                            width: 8.adaptSize,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                4.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      AppbarSubtitleTwo(
                        text: "Online",
                        margin: EdgeInsets.only(
                          left: 16.h,
                          top: 19.v,
                          right: 62.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      body: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (AuthController _authController) {
            return Obx(() => SizedBox(
                width: double.maxFinite,
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.h),
                  decoration: AppDecoration.fillOnPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder12,
                    // color: RED_COLOR
                  ),
                  child: SmartRefresher(
                    key: Key('untriggered'),
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
                          body = Text("No more Data");
                        }

                        if (_controller.hasMore == false) {
                          body = Text("No more Data");
                        }

                        return Container(
                          height: 80.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: _controller.conversations.length,
                        itemBuilder: (context, index) {
                          if (_controller.conversations.elementAt(index).type ==
                                  'text' &&
                              _controller.conversations.elementAt(index).sender!.id !=
                                  int.tryParse(_authController
                                      .authenticatedUser!['id']
                                      .toString())) {
                            return chatLeftMessage(context,
                                _controller.conversations.elementAt(index));
                          } else if (_controller.conversations
                                      .elementAt(index)
                                      .type ==
                                  'text' &&
                              _controller.conversations.elementAt(index).sender!.id ==
                                  int.tryParse(_authController
                                      .authenticatedUser!['id']
                                      .toString())) {
                            return chatRightMessage(context,
                                _controller.conversations.elementAt(index));
                          } else if (_controller.conversations
                                      .elementAt(index)
                                      .type !=
                                  'text' &&
                              _controller.conversations
                                      .elementAt(index)
                                      .sender!
                                      .id !=
                                  _authController.authenticatedUser!['id']
                                      .toString()) {
                            return advertismentBlock(
                                context,
                                _controller.conversations.elementAt(index),
                                _authController.authenticatedUser!['id']);
                          } else {
                            return Container(
                              child: Text("Empty "),
                            );
                          }
                        }),
                  ),
                )));
          }),
      bottomNavigationBar: _buildMessageEditText(context),
    ));
  }

  /// Section Widget
  Widget _buildRelayButton(BuildContext context, int adId, int offerId) {
    return CustomElevatedButton(
      onPressed: () => _controller.replyOnOffer(context, adId, offerId),
      height: 40.v,
      text: "Relay",
      margin: EdgeInsets.only(right: 4.h),
      leftIcon: Container(
        margin: EdgeInsets.only(right: 8.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgCheckmarkOnprimary,
          height: 22.adaptSize,
          width: 22.adaptSize,
        ),
      ),
      buttonStyle: CustomButtonStyles.none,
      decoration: CustomButtonStyles.gradientPrimaryToOrangeTL8Decoration,
      buttonTextStyle: CustomTextStyles.titleSmallOnPrimarySemiBold,
    );
  }

  /// Section Widget
  Widget _buildRejectButton(BuildContext context, int adId, int offerId) {
    return CustomOutlinedButton(
      onPressed: () => _controller.rejectOnOffer(context, adId, offerId),
      height: 40.v,
      text: "Reject ",
      margin: EdgeInsets.only(left: 0.h),
      leftIcon: Container(
        // color: PURPLE_COLOR,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(right: 4.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgClosePink600,
          height: 22.adaptSize,
          width: 22.adaptSize,
        ),
      ),
      buttonStyle: CustomButtonStyles.outlinePinkTL8,
      buttonTextStyle: CustomTextStyles.titleSmallPrimary,
    );
  }

  /// Section Widget
  Widget _buildLoremIpsumDolorSitAmetButton(BuildContext context) {
    return CustomElevatedButton(
      height: 40.v,
      width: 216.h,
      text: "Lorem ipsum dolor sit amet, ",
      buttonStyle: CustomButtonStyles.none,
      decoration:
          CustomButtonStyles.gradientSecondaryContainerToOrangeDecoration,
      buttonTextStyle: theme.textTheme.bodyLarge!,
      alignment: Alignment.centerRight,
    );
  }

  /// Section Widget
  Widget _buildDescriptionEditText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 108.h),
      child: CustomTextFormField(
        controller: descriptionEditTextController,
        hintText: "Lorem ipsum dolor sit amet, ",
        hintStyle: theme.textTheme.bodyLarge!,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 8.h,
          vertical: 9.v,
        ),
        borderDecoration: TextFormFieldStyleHelper.fillGrayTL12,
        filled: true,
        fillColor: appTheme.gray10001,
      ),
    );
  }

  /// Section Widget
  Widget _buildMessageEditText(BuildContext context) {
    return Container(
      color: WHITE_COLOR,
      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
      child: CustomTextFormField(
        controller: messageEditTextController,
        hintText: "Your message ".tr,
        hintStyle: theme.textTheme.bodySmall!,
        textInputAction: TextInputAction.done,
        onChanged: (value) => _controller.setTextMessage(value),
        prefix: Container(
          margin: EdgeInsets.fromLTRB(14.h, 18.v, 18.h, 17.v),
          child: CustomImageView(
            imagePath: ImageConstant.imgTelevision,
            height: 20.adaptSize,
            width: 20.adaptSize,
          ),
        ),
        prefixConstraints: BoxConstraints(
          maxHeight: 56.v,
        ),
        suffix: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 30.h,
            vertical: 16.v,
          ),
          child: GestureDetector(
            onTap: () => _controller
                .sendMessage(context)
                .then((value) => messageEditTextController.clear()),
            child: Icon(Icons.send, size: 22, color: ZAHRA_RED),
          ),
        ),
        suffixConstraints: BoxConstraints(
          maxHeight: 56.v,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 19.v),
      ),
    );
  }

  Widget advertismentBlock(context, MessageModel message, int authID) {
    return Container(
      margin: EdgeInsets.only(right: 93.h),
      padding: EdgeInsets.all(4.h),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL121,
      ),
      child: Container(
        padding: EdgeInsets.all(8.h),
        decoration: AppDecoration.fillOnPrimary.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  8.h,
                ),
                child: Image.network(
                  message.offer!.advertisment!.image!,
                  height: 155.v,
                  width: 257.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 7.v),
            Text(
              "${message.offer!.advertisment!.name}",
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(height: 4.v),
            Padding(
              padding: EdgeInsets.only(right: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4.v,
                      bottom: 3.v,
                    ),
                    child: Text(
                      "Offer",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${message.offer!.price}",
                          style: CustomTextStyles.titleMediumffd20653SemiBold,
                        ),
                        TextSpan(
                          text: " ${message.offer!.advertisment!.currency}",
                          style: CustomTextStyles.bodyMediumff292d32,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(height: 13.v),
            authID == message.sender!.id
                ? SizedBox.shrink()
                : Obx(() {
                    if (message.offer!.status == "pending" &&
                        _controller.status == 'pendding') {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: _buildRelayButton(
                                  context,
                                  message.offer!.advertisment!.id!,
                                  message.offer!.id!)),
                          Expanded(
                              child: _buildRejectButton(
                                  context,
                                  message.offer!.advertisment!.id!,
                                  message.offer!.id!)),
                        ],
                      );
                    } else if (_controller.status == 'approved' ||
                        message.offer!.status == "approved") {
                      return _buildConfirmedWidget(context);
                    } else if (_controller.status == 'rejected' ||
                        message.offer!.status == "rejected") {
                      return _buildRejectedWidget(context);
                    } else {
                      return Text("Not Defindded");
                    }
                  }),
            SizedBox(height: 8.v),
            Text(
              "${message.created_at}",
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget chatRightMessage(context, MessageModel message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.v),
        Align(
          child: Container(
            // width: MediaQuery.of(context).size.width - 180,
            padding:
                EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              "${message.message}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  8.h,
                ),
                topRight: Radius.circular(
                  8.h,
                ),
                bottomLeft: Radius.circular(
                  8.h,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment(0.0, 1),
                end: Alignment(1.0, 1),
                colors: [
                  theme.colorScheme.secondaryContainer,
                  appTheme.orange400.withOpacity(0.1),
                ],
              ),
            ),
          ),
          alignment: Alignment.centerRight,
        ),
        SizedBox(height: 4.v),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.v),
                child: Text(
                  "${message.created_at}",
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: CustomIconButton(
                  height: 20.adaptSize,
                  width: 20.adaptSize,
                  padding: EdgeInsets.all(4.h),
                  decoration: IconButtonStyleHelper.fillOrange,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgFiCheck,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget chatLeftMessage(context, MessageModel message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.v),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          child: Text("${message.message}", style: TextStyle(fontSize: 15)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)),
            color: GREY_COLOR.withOpacity(0.1),
          ),
        ),
        // _buildDescriptionEditText(context),
        SizedBox(height: 8.v),
        Text(
          "${message.created_at}",
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildRejectedWidget(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: Colors.red)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.red),
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color: Colors.red,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Rejected".tr,
              style: TextStyle(
                  fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
            )
          ],
        ));
  }

  Widget _buildConfirmedWidget(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: Colors.green)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_outlined,
              size: 25,
              color: Colors.green,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Confirm".tr,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}
