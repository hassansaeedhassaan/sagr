import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/categories/domain/entities/category.dart';
import 'package:sagr/features/categories/presentation/controllers/categories_controller.dart';

import '../../../theme/theme_helper.dart';

// ignore: must_be_immutable
class CategorygridItemWidget extends StatelessWidget {
  // Category? category;
  // CategorygridItemWidget(this.category, {Key? key})
  //     : super(
  //         key: key,
  //       );

 final Category? category;
  String? type = 'main';
  
final VoidCallback? onPressed;
  CategorygridItemWidget({
    Key? key,
    this.category,
    this.onPressed,
    this.type
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
      
      init: CategoriesController(Get.find()),
      builder: (categoryController){
      return InkWell(
         onTap: onPressed,
        child: Column(
        children: [
          Container(
            margin:type =='sub'? EdgeInsets.symmetric(horizontal: 5):EdgeInsets.symmetric(horizontal: 2.5),
            height: 70.adaptSize,
            width: 70.adaptSize,
            decoration: BoxDecoration(
              color: PURPLE_COLOR,
              borderRadius: BorderRadius.circular(
                12.h,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: category!.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 0.v),
           
          SizedBox(
            width: 70,
            child: Text(
              
            
              category!.name!,
              textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium!.copyWith(color: BLACK_COLOR),
            ),
          ),
        ],
            ),
      );
    });
  }
}
