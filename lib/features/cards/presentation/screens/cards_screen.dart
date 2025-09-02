import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/cards/presentation/controllers/cards_controller.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/custom_button_style.dart';

import '../../../../widgets/appbar/basic_app_bar.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_image_view.dart';
import './../widgets/userprofile6_item_widget.dart';

import 'package:flutter/material.dart';

class CardsScreen extends StatelessWidget {
  final CardsController _controller;

  CardsScreen(this._controller, {Key? key})
      : super(
          key: key,
        );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(66),
          child: BasicAppBar(title: "My Cards")),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(16.h),
        child: GetBuilder(
            tag: DateTime.now().toString(),
            init: CardsController(Get.find()),
            builder: (CardsController _cardController) {
              return _controller.isLoadingList
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [

                    
                        Expanded(
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
                            itemCount: _controller.cards.length,
                            itemBuilder: (context, index) {
                              return Userprofile6ItemWidget(
                                  card: _controller.cards.elementAt(index));
                            },
                          ),
                        ),
                        SizedBox(height: 24.v),
                        CustomElevatedButton(
                          // onPressed: (){
                          //    _controller.saveCard(context);
                          // },
                          onPressed: () =>
                              Get.toNamed("/create_new_card_screen"),
                          text: "Add new card",
                          leftIcon: Container(
                            margin: EdgeInsets.only(right: 10.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgCloseOnprimary,
                              height: 12.adaptSize,
                              width: 12.adaptSize,
                            ),
                          ),
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles
                              .gradientPrimaryToOrangeDecoration,
                        ),
                        SizedBox(height: 5.v),
                      ],
                    );
            }),
      ),
      // bottomNavigationBar: _buildBottomBar(context),
    );
  }

  /// Section Widget
  Widget _buildCardsList(BuildContext context) {
    return Obx(() => ListView.separated(
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
          itemCount: _controller.cards.length,
          itemBuilder: (context, index) {
            return Userprofile6ItemWidget(
                card: _controller.cards.elementAt(index));
          },
        ));
  }
}
