import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/features/pages/data/models/page_model.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../theme/app_decoration.dart';
import '../../../../theme/custom_text_style.dart';
import '../../../../theme/theme_helper.dart';
import '../../../../widgets/custom_image_view.dart';
import '../controllers/pages_controller.dart';

class StaticPage extends StatelessWidget {
  StaticPage({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: GetBuilder<PagesController>(
        init: PagesController(Get.find(), 'prohibited-advertisements'),
        builder: (PagesController controller){
          return    Scaffold(
        appBar: AppBar(
          title: controller.isLoading ? Center(child: Text(""),) : Text(controller.pageData!.title!),
          scrolledUnderElevation: 0,
          backgroundColor: WHITE_COLOR,
        ),
        body: controller.isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(16.h),
                child: Column(
                  children: [
          
                    _buildFrame(context, controller.pageData!),
                    SizedBox(height: 12.v),
                    _buildFrame1(context),
                    SizedBox(height: 5.v),
                  ],
                ),
              ),
        ),
        // bottomNavigationBar: _buildBottomBar(context),
      );
        }),
      
    );
  }

  

  /// Section Widget
  Widget _buildFrame(BuildContext context,PageModel page) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 11.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.fillOnPrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: page.title,
                  style: CustomTextStyles.titleLargeff333333,
                ),
                // TextSpan(
                //   text: " we are ?",
                //   style: CustomTextStyles.titleLargeff333333,
                // ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 17.v),

          // Text(
          //     ,
          //     maxLines: 14,
          //     overflow: TextOverflow.ellipsis,
          //     textAlign: TextAlign.justify,
          //     style: theme.textTheme.bodyLarge!.copyWith(
          //       height: 1.50,
          //     ),
          //   )



// Text("${page.content}"),
          SizedBox(
            width: 374.h,
            child: HtmlWidget(
  // the first parameter (`html`) is required
  '''
  ${page.content}
  ''',

  // all other parameters are optional, a few notable params:

  // specify custom styling for an element
  // see supported inline styling below
  customStylesBuilder: (element) {
    if (element.classes.contains('foo')) {
      return {'color': 'red'};
    }

    return null;
  },

  

  // this callback will be triggered when user taps a link


  // select the render mode for HTML body
  // by default, a simple `Column` is rendered
  // consider using `ListView` or `SliverList` for better performance
  renderMode: RenderMode.column,

  // set the default styling for text
  textStyle: TextStyle(fontSize: 14),
), 
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFrame1(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Container(
        height: 137.v,
        width: 398.h,
        decoration: AppDecoration.gradientSecondaryContainerToOrange.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder12,
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 24.v),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "we ",
                        style: CustomTextStyles.titleLargeffd20653,
                      ),
                      TextSpan(
                        text: "are global and grow ",
                        style: CustomTextStyles.titleLargeffd20653,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgGroup1000,
              height: 180.v,
            ),
            CustomImageView(
              imagePath: ImageConstant.imgEllipse35,
              height: 42.v,
              width: 51.h,
              radius: BorderRadius.circular(
                16.h,
              ),
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(
                left: 13.h,
                bottom: 19.v,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 30.h,
                  bottom: 0.v,
                  left: 30.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          // right: 303.h,
                          bottom: 23.v,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "+900",
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              "Products",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          // right: 303.h,
                          bottom: 23.v,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "+150",
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              "Sellers",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          // right: 303.h,
                          bottom: 23.v,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "+4",
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              "Countries",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
