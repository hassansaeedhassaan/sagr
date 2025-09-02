import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/myfavorites/presentation/controllers/favorites_controller.dart';
import 'package:sagr/features/products/data/models/product_model.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../view/my_fav_screen/widgets/userprofile4_item_widget.dart';
import '../../../../core/utils/image_constant.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/custom_image_view.dart';

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
      body:  _buildUserProfile(context),
      // bottomNavigationBar: _buildBottomBar(context),
    );
  }

  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: GetBuilder<FavoritesController>(
          init: FavoritesController(Get.find()),
          builder: (FavoritesController _favoriteController) {
            return RefreshIndicator(
               onRefresh: () => _favoriteController.onRefresh(),
              child: _favoriteController.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _favoriteController.products.length == 0
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgArtwork,
                            height: 184.v,
                            width: 185.h,
                          ),
                          SizedBox(height: 23.v),
                          Text(
                            "No Favorites Ads Found",
                            style: CustomTextStyles
                                .titleMediumBluegray90001SemiBold_1,
                          ),
                          SizedBox(height: 8.v),
                          SizedBox(
                            width: 275.h,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Its ",
                                    style:
                                        CustomTextStyles.bodyMediumff828282,
                                  ),
                                  TextSpan(
                                    text:
                                        "Seems we can't find any results on your Favorite List",
                                    style:
                                        CustomTextStyles.bodyMediumff828282,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                      : ListView.separated(
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (
                            context,
                            index,
                          ) {
                            return SizedBox(
                              height: 8.v,
                            );
                          },
                          itemCount: _favoriteController.products.length,
                          itemBuilder: (context, index) {
                            return Userprofile4ItemWidget(
                                _favoriteController.products.elementAt(index)
                                    as ProductModel);
                          },
                        ),
            );
          }),
    );
  }
}
