import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/image_constant.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/theme/app_decoration.dart';
import 'package:sagr/theme/custom_text_style.dart';
import 'package:sagr/theme/theme_helper.dart';
import 'package:sagr/widgets/custom_icon_button.dart';
import 'package:sagr/widgets/custom_image_view.dart';

/// A single ad card (image, badges, title, location, price) used in the
/// horizontal product lists on the home screen.
class CardColumn extends StatelessWidget {
  final int id;
  final String negotiable;
  final String cars;
  final String inVar;
  final String mercedesBenz;
  final String dakahliaMansoura;
  final String price;
  final String image;
  final String premium;

  const CardColumn({
    super.key,
    required this.id,
    required this.negotiable,
    required this.cars,
    required this.inVar,
    required this.mercedesBenz,
    required this.dakahliaMansoura,
    required this.price,
    required this.image,
    required this.premium,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => Get.toNamed('/product_detail_screen', arguments: id),

      // onTap: () => Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => AdsDetailsScreen())),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 147.v,
            width: 173.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 147.v,
                  width: 173.h,
                  child: image == ""
                      ? Image.asset("assets/images/logo.png")
                      : ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.h),
                          ),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.h, 8.v, 8.h, 111.v),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          height: 28.adaptSize,
                          width: 28.adaptSize,
                          padding: EdgeInsets.all(4.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgFavorite,
                          ),
                        ),
                      premium != "free"  ?  SizedBox.shrink() : Padding(
                          padding: EdgeInsets.only(left: 0.h),
                          child: CustomIconButton(
                            height: 28.adaptSize,
                            width: 28.adaptSize,
                            padding: EdgeInsets.all(5.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgGroup58519,
                            ),
                          ),
                        ),
                        Container(
                          width: 80.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 4.v,
                          ),
                            decoration: negotiable != 'true' ?  BoxDecoration() : AppDecoration.fillTealA.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder8,
                          ),
                          child: negotiable == 'true' ?  Text(
                            negotiable == 'true' ? "Negotiable" : "",
                            style:
                                CustomTextStyles.labelLargeOnPrimary.copyWith(
                              color: theme.colorScheme.onPrimary.withOpacity(1),
                            ),
                          ): SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 173.h,
            padding: EdgeInsets.symmetric(
              horizontal: 8.h,
              vertical: 6.v,
            ),
            decoration: AppDecoration.fillOnPrimary.copyWith(
              borderRadius: BorderRadiusStyle.customBorderBL12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cars,
                        style: CustomTextStyles.bodySmallOrange400.copyWith(
                          color: appTheme.orange400,
                        ),
                      ),
                      Text(
                        inVar,
                        style: CustomTextStyles.bodySmall10.copyWith(
                          color: appTheme.gray60001,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.v),
                Flexible(
                  child: Text(
                    mercedesBenz,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.titleSmallSemiBold.copyWith(
                      color: appTheme.blueGray90001,
                    ),
                  ),
                ),
                SizedBox(height: 5.v),
                Padding(
                  padding: EdgeInsets.only(right: 13.h),
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgLinkedin,
                        height: 16.adaptSize,
                        width: 16.adaptSize,
                        margin: EdgeInsets.only(
                          top: 1.v,
                          bottom: 2.v,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: FittedBox(
                          child: Container(
                            width: 122,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              dakahliaMansoura,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: appTheme.blueGray90001,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.v),
                Text(
                  price,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
