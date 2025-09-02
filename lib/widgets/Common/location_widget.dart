import 'package:flutter/widgets.dart';
import 'package:sagr/core/utils/size_utils.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/theme_helper.dart';
import '../custom_image_view.dart';

class LocationWidget extends StatelessWidget {


final String location;

 LocationWidget({required this.location});  

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgLinkedin,
          height: 20.adaptSize,
          width: 20.adaptSize,
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.h),
          child: Text(
            "$location",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
