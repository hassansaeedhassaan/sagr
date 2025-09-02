import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../../features/categories/data/models/category_model.dart';
import '../../../theme/theme_helper.dart';

// ignore: must_be_immutable
class CategoryItemWidget extends StatelessWidget {

  final CategoryModel category;
  const CategoryItemWidget(this.category);
     

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          // color: RED_COLOR,
          padding: EdgeInsets.all(0),
          child:ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:  CachedNetworkImage(
            imageUrl: category.image!,
            width: 76.adaptSize,
            height: 65.adaptSize,
            fit: BoxFit.cover,
          ),
          ),
        ),
        // CustomImageView(
        //   imagePath: ImageConstant.imgRectangle3925476x76,
        //   height: 76.adaptSize,
        //   width: 76.adaptSize,
        //   radius: BorderRadius.circular(
        //     12.h,
        //   ),
        // ),
        SizedBox(height: 6.v),
        Text(
          category.name!,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelLarge,
        ),
      ],
    );
  }
}
