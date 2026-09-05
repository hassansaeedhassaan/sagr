import 'package:flutter/material.dart';
import 'package:sagr/core/utils/size_utils.dart';
import 'package:sagr/features/products/domain/entities/product.dart';

import 'card_column.dart';

/// Horizontal scrolling list of ad cards.
class CardStack extends StatelessWidget {
  final List<Product> products;

  const CardStack({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 258.v,
        width: 398.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 5),
                child: CardColumn(
                  id: products[index].id!,
                  negotiable: products.elementAt(index).isNegotiable.toString(),
                  cars: "#cars",
                  image: products[index].image!,
                  inVar: " in ${products[index].created_at}",
                  mercedesBenz: products[index].name,
                  dakahliaMansoura:
                      "${products[index].nationality.name}, ${products[index].city!.name}",
                  price: "${products[index].price} ${products[index].currency}",
                  premium: "${products[index].type}",
                ),
              );
            }));
  }
}
