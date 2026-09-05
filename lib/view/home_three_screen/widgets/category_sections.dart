import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/categories/presentation/controllers/categories_controller.dart';
import 'package:sagr/theme/app_decoration.dart';
import 'package:shimmer/shimmer.dart';

import 'categorygrid_item_widget.dart';

/// Shimmer placeholder row shown while sub-categories load.
List<Widget> _shimmerRow(int count) {
  return List.generate(
      count,
      (i) => Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
            child: SizedBox(
              height: 70,
              width: 70,
              child: Shimmer(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 36),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(248, 250, 124, 124),
                      borderRadius: BorderRadiusStyle.roundedBorder12,
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEBEBF4),
                      Color.fromARGB(255, 243, 243, 243),
                      Color(0xFFEBEBF4),
                    ],
                    stops: [
                      0.1,
                      0.3,
                      0.4,
                    ],
                    begin: Alignment(-1.0, -0.3),
                    end: Alignment(1.0, 0.3),
                    tileMode: TileMode.clamp,
                  )),
            ),
          ))).toList();
}

/// Top-level categories row.
class CategoryGridSection extends StatelessWidget {
  const CategoryGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
        init: CategoriesController(Get.find()),
        builder: (categoryController) {
          return SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: categoryController.categories.length,
              itemBuilder: (context, index) {
                return CategorygridItemWidget(
                  onPressed: () => categoryController
                      .getChildLevelOne(categoryController.categories[index].id!),
                  category: categoryController.categories[index],
                );
              },
            ),
          );
        });
  }
}

/// First level of sub-categories.
class CategoryGridSubSection extends StatelessWidget {
  const CategoryGridSubSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
        init: CategoriesController(Get.find()),
        builder: (categoryController) {
          return categoryController.productsLoading
              ? SizedBox(child: Row(children: _shimmerRow(5)))
              : SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: categoryController.subCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: CategorygridItemWidget(
                          onPressed: () => categoryController.getChildLevelTwo(
                              categoryController.subCategories[index].id!),
                          category: categoryController.subCategories[index],
                          type: "sub",
                        ),
                      );
                    },
                  ),
                );
        });
  }
}

/// Second level of sub-categories.
class CategoryGridSSubSection extends StatelessWidget {
  const CategoryGridSSubSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
        init: CategoriesController(Get.find()),
        builder: (categoryController) {
          return SizedBox(
            height: categoryController.subCategoriesTwo.length > 0 ? 100 : 0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: categoryController.subCategoriesTwo.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => categoryController.getChildLevelThird(
                      categoryController.subCategoriesTwo[index].id!),
                  child: CategorygridItemWidget(
                      category: categoryController.subCategoriesTwo[index]),
                );
              },
            ),
          );
        });
  }
}

/// Third level of sub-categories.
class CategoryGridThSubSection extends StatelessWidget {
  const CategoryGridThSubSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoriesController>(
        init: CategoriesController(Get.find()),
        builder: (categoryController) {
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 90.v,
              crossAxisCount: 5,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.h,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryController.thirdLevelSubCategories.length,
            itemBuilder: (context, index) {
              return CategorygridItemWidget(
                  category: categoryController.thirdLevelSubCategories[index]);
            },
          );
        });
  }
}
