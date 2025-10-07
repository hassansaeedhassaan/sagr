import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/features/ads/data/models/ad_model.dart';
import 'package:sagr/features/events/presentation/widgets/card_info.dart';
import 'package:sagr/helper/base_url.dart';
import '../../../../data/colors.dart';
import '../controllers/ads_controller.dart';

class AdScreen extends StatelessWidget {
  const AdScreen({super.key});


  @override
  Widget build(BuildContext context) {

    void _viewAdDetails(AdModel ad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ad.name!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('التصنيف: ${ad['category']}'),
            // const SizedBox(height: 8),
            // Text('التاريخ: ${ad['date']}'),
            // const SizedBox(height: 8),
            Text(ad.description!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('اتصال'),
          ),
        ],
      ),
    );
  }
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ads".tr),
        scrolledUnderElevation: 0,
        backgroundColor: WHITE_COLOR,
        centerTitle: false,
      ),
    body: GetBuilder<AdsController>(builder: (AdsController eventController){
        return eventController.isLoading ? CircularProgressIndicator() : ListView.builder(
          itemCount: eventController.ads.length,
          itemBuilder: (cntx, index) {
            return GestureDetector(
               onTap: () {
                // if(eventController.ads.elementAt(index).appliedStatus == 'accepted'){
                //   Get.toNamed('/event_accept_screen', arguments: eventController.ads.elementAt(index).id);
                // }
                //  Get.toNamed('/event_processing_screen', arguments: eventController.events.elementAt(index).id);
               },

              child:Card(
                  color: WHITE_COLOR,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _viewAdDetails(eventController.ads.elementAt(index)),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image container
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: GREY_COLOR.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "$HOSTURL${eventController.ads.elementAt(index).logo}",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Icon(Icons.image, size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category and favorite
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        eventController.ads.elementAt(index).name.toString(),
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    // GestureDetector(
                                    //   // onTap: () => _toggleFavorite(index),
                                    //   child: Icon(
                                    //     ads[index]['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                    //     color: ads[index]['isFavorite'] ? Colors.red : Colors.grey,
                                    //     size: 20,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Title
                                Text(
                                  eventController.ads.elementAt(index).name.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Description
                                Text(
                                  eventController.ads.elementAt(index).description.toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                // Bottom row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Date and time
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventController.ads.elementAt(index).date.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                           eventController.ads.elementAt(index).time.toString(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Action buttons
                                    Row(
                                      children: [
                                        // GestureDetector(
                                        //   // onTap: () => _shareAd(index),
                                        //   child: Container(
                                        //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        //     child: Icon(
                                        //       Icons.share,
                                        //       size: 18,
                                        //       color: Colors.blue[600],
                                        //     ),
                                        //   ),
                                        // ),
                                        // const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[600],
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Text(
                                            'عرض المزيد',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              
              // InfoCard(
              //   imageUrl: 'https://img.freepik.com/premium-photo/waves-pastel-colors-waves-background_476363-7444.jpg',
              //   title: eventController.ads.elementAt(index).name!,
              //   address: eventController.ads.elementAt(index).description!,
              //   status: eventController.ads.elementAt(index).name!,
              //   date: "${eventController.ads.elementAt(index).date} ${eventController.ads.elementAt(index).time}" ,
              //   eventStatus: eventController.ads.elementAt(index).datetime!.toString(),
              // ),
            );
    });
    })
    );
  }
}
