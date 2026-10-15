import 'package:flutter/material.dart';

import '../../data/colors.dart';

class Price extends StatelessWidget {
  final String price;
  final double? priceFontSize;

  const Price({Key? key, required this.price,  this.priceFontSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: '₪',
          style: const TextStyle(
            color: BLACK_COLOR,
            fontFamily: 'URW',
            fontSize: 12.0,
          ),
          children: <TextSpan>[
            TextSpan(
                text: price,
                style: TextStyle(
                  fontFamily: 'URW',
                  color: BLACK_COLOR,
                  fontWeight: FontWeight.w600,
                  fontSize: priceFontSize,
                )),
          ]),
    );
  }
}
