import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/helper/base_url.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';
import 'package:sagr/widgets/Common/no_results.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';
import '../../../../widgets/premium_ad_card.dart';
import '../controllers/ads_controller.dart';

class AdScreen extends StatelessWidget {
  const AdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: AppBar(
          title: Text("Advertisements".tr),
          scrolledUnderElevation: 0,
        ),
        body: GetBuilder<AdsController>(
          builder: (AdsController controller) {
            if (controller.isLoading && controller.ads.isEmpty) {
              return AppLoader.list();
            }
            if (controller.ads.isEmpty) {
              return NoResults(
                title: 'No ads found'.tr,
                message: '',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: controller.ads.length,
              itemBuilder: (context, index) {
                final ad = controller.ads.elementAt(index);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: PremiumAdCard(
                    layout: AdCardLayout.horizontal,
                    onReadMore: () => Get.toNamed(
                      '/product_detail_screen',
                      arguments: ad.id,
                    ),
                    data: AdCardData(
                      companyName: ad.name?.toString() ?? '',
                      title: ad.name?.toString() ?? '',
                      description: ad.description?.toString() ?? '',
                      dateTime:
                          DateTime.tryParse(ad.datetime ?? '') ?? DateTime.now(),
                      imageUrl: "$HOSTURL${ad.logo ?? ''}",
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
