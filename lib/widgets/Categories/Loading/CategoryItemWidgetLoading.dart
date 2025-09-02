import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryItemWidgetLoading extends StatelessWidget {
  const CategoryItemWidgetLoading({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/products', preventDuplicates: false),
      child: Container(
        margin: EdgeInsetsDirectional.fromSTEB(5, 0, 4, 0),
        constraints: BoxConstraints(
          maxWidth: 66,
          maxHeight: 100,
          minHeight: 60,
          minWidth: 66,
        ),
        child: Column(
          children: [
            Container(
              width: 64.00,
              height: 64.00,
              padding: EdgeInsets.all(20),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                image: new DecorationImage(
                  image: NetworkImage(""),
                  // fit: BoxFit.fitHeight,
                ),
                color: Color(0xffffffff),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              child: Container(color: Colors.red, height: 7,),
              // child: Text(
              //   title!,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     height: 1.4,
              //     fontSize: 9,
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
