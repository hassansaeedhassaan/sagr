import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/colors.dart';

class Breadcrumb extends StatelessWidget {
  const Breadcrumb({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        margin: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
              decoration: BoxDecoration(
                  color: DARK_PURPLE_COLOR,
                  borderRadius: BorderRadius.circular(28.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                    child: Icon(
                      Icons.arrow_back_sharp,
                      size: 16.0,
                      color: WHITE_COLOR,
                    ),
                  ),
                  Text(
                    "العودة للخلف",
                    style: TextStyle(
                        color: WHITE_COLOR,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Container(
            //       child: Text(
            //         "القسم الرئيسي",
            //         style: TextStyle(fontSize: 10, color: BLACK_COLOR),
            //       ),
            //     ),
            //     Container(
            //       padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
            //       child: Icon(
            //         Icons.arrow_forward_ios,
            //         color: BLACK_COLOR,
            //         size: 12,
            //       ),
            //     ),
            //     Container(
            //       child: Text(
            //         "القسم الفرعي",
            //         style: TextStyle(fontSize: 10, color: BLACK_COLOR),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
