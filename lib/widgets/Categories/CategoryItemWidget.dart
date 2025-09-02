import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sagr/data/colors.dart';
import 'package:get/get.dart';
import 'package:nice_ripple/nice_ripple.dart';

class CategoryItemWidget extends StatelessWidget {
  final int? id;
  final String? title;

  final String? image;
  final VoidCallback? onPressed;

  const CategoryItemWidget({
    Key? key,
    required this.id,
    required this.title,
    required this.image,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed('/products', arguments: id, preventDuplicates: false),
      child: Container(
        margin: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
        constraints: BoxConstraints(
          maxHeight: 110,
          minHeight: 60,
          maxWidth: 100,
          minWidth: 80,
        ),
        child: Column(
          children: [
            Container(


      
              width: 80.00,
              height: 80.00,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: CachedNetworkImage(
                
                
                  imageUrl: image!,
              
                  imageBuilder: (context, imageProvider) => Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
              
                      color: maz_MAIN_COLOR.withOpacity(0.4),
                      image: DecorationImage(
                        scale: 4,
                        image: imageProvider,
                        fit: BoxFit.cover,
                        // colorFilter:
                        //     ColorFilter.mode(maz_DARK_COLOR.withOpacity(0.1), BlendMode.hardLight)
                      ),
                    ),
                  ),
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      width: 25.0,
                      height: 25.0,
                      child: 
                       NiceRipple(
                        rippleColor: WHITE_COLOR,
                        radius: 200,
                        rippleShape: BoxShape.circle,
                        duration: const Duration(seconds: 4),
                        curve: Curves.bounceInOut,
                        onTap: () {
                          // your code here
                        },
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),

                // image: new DecorationImage(
                //   scale: 0.5,
                //   image: NetworkImage(image!)
                // ),
                // color: Color.fromARGB(255, 158, 111, 111),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
