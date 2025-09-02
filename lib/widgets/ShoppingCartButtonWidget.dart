import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sagr/data/colors.dart';
import 'package:get/get.dart';




class ShoppingCartButtonWidget extends StatelessWidget {
  const ShoppingCartButtonWidget({
    required this.iconColor,
    required this.labelColor,
    this.labelCount = 0,
    Key? key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;
  final int labelCount;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.toNamed('/cart'),
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: SvgPicture.asset("assets/icons/noun_cart.svg",),
                                      
          ),
          Container(

            decoration: BoxDecoration(
              border: Border.all(width: 1, color: WHITE_COLOR),

                color: Color(0xffFFAD1E),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(
                minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
            child: Text(
              "2",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.merge(
                    TextStyle(
                        color: WHITE_COLOR, fontSize: 9.2),
                  ),
            ),
          ),
        ],
      ),
      // color: Colors.transparent,
    );
  }
}
