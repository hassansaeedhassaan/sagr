import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/theme/custom_text_style.dart';
import 'package:sagr/theme/theme_helper.dart';

/// Section header row: a title on the left and a "see more" link on the right.
class FeatureAdsRow extends StatelessWidget {
  final String featureAdsText;
  final String seeMoreText;

  const FeatureAdsRow({
    super.key,
    required this.featureAdsText,
    required this.seeMoreText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          featureAdsText,
          style: theme.textTheme.titleLarge!.copyWith(
            color: appTheme.blueGray90001,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.v),
          child: Text(
            seeMoreText,
            style: CustomTextStyles.titleSmallPrimary_1.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
