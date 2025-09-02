import 'package:flutter/widgets.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/custom_text_style.dart';
import '../custom_image_view.dart';

class NoResultsWidget extends StatelessWidget {

   final String? title;
   final String? description;

   NoResultsWidget({this.description, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgArtwork,
            height: 184.v,
            width: 185.h,
          ),
          SizedBox(height: 23.v),
          Text(
            title!,
            style: CustomTextStyles.titleMediumBluegray90001SemiBold_1,
          ),
          SizedBox(height: 8.v),
          SizedBox(
            width: 275.h,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Its ",
                    style: CustomTextStyles.bodyMediumff828282,
                  ),
                  TextSpan(
                    text: "Seems we can't find any results on your List",
                    style: CustomTextStyles.bodyMediumff828282,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
