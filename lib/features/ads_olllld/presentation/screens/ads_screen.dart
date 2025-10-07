import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sagr/data/colors.dart';
import 'package:sagr/view/widgets/fixed_app_bottom_bars.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  List<Map<String, dynamic>> ads = [];

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() {
    // Mock data
    ads = List.generate(10, (index) => {
      'id': index.toString(),
      'title': 'صقر لإدارة الفعاليات ${index + 1}',
      'description': 'خلافاً للإعتقاد السائد فإن لوريم إيبسوم ليس نصاً عشوائياً، بل إن له جذور في الأدب اللاتيني الكلاسيكي.',
      'date': '${12 + index}/01/2025',
      'time': '10:30:00 AM',
      'isFavorite': index % 3 == 0,
      'category': index % 2 == 0 ? 'فعاليات' : 'عروض',
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      ads[index]['isFavorite'] = !ads[index]['isFavorite'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ads[index]['isFavorite'] ? 'تم إضافة الإعلان للمفضلة' : 'تم إزالة الإعلان من المفضلة'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareAd(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم مشاركة الإعلان'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteAd(int index) {
    final ad = ads[index];
    setState(() {
      ads.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حذف الإعلان'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {
            setState(() {
              ads.insert(index, ad);
            });
          },
        ),
      ),
    );
  }

  void _viewAdDetails(Map<String, dynamic> ad) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ad['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التصنيف: ${ad['category']}'),
            const SizedBox(height: 8),
            Text('التاريخ: ${ad['date']}'),
            const SizedBox(height: 8),
            Text(ad['description']),
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

  @override
  Widget build(BuildContext context) {
    return MasterWrapper(
      body: Scaffold(
        appBar: AppBar(
          title: Text("الإعلانات".tr),
          scrolledUnderElevation: 0,
          backgroundColor: WHITE_COLOR,
          elevation: 0,
        ),
        backgroundColor: Colors.grey[50],
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Dismissible(
                key: Key(ads[index]['id']),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, color: Colors.white),
                          SizedBox(width: 8),
                          Text('مفضلة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('حذف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.delete, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    _deleteAd(index);
                    return true;
                  } else if (direction == DismissDirection.startToEnd) {
                    _toggleFavorite(index);
                    return false;
                  }
                  return false;
                },
                child: Card(
                  color: WHITE_COLOR,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _viewAdDetails(ads[index]),
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
                              child: Image.asset(
                                "assets/images/sagr-logo.png",
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
                                        ads[index]['category'],
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _toggleFavorite(index),
                                      child: Icon(
                                        ads[index]['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                        color: ads[index]['isFavorite'] ? Colors.red : Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Title
                                Text(
                                  ads[index]['title'],
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
                                  ads[index]['description'],
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
                                          ads[index]['date'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          ads[index]['time'],
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
                                        GestureDetector(
                                          onTap: () => _shareAd(index),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            child: Icon(
                                              Icons.share,
                                              size: 18,
                                              color: Colors.blue[600],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}