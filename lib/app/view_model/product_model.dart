import 'dart:convert';

class ProductModel {
  int? product_id;
  double? rating;
  String? name;
  String? barcode;
  String? price;
  String? image;
  String? attachment;
  // String? special;
  // String? specialPrice;

  ProductModel({
    this.product_id,
    this.rating,
    this.name,
    this.barcode,
    this.price,
    this.image,
    this.attachment,
    // this.special,
    // this.specialPrice
  });

  Map<String, dynamic> toMap() {
    return {
      'id': product_id,
      'name': name,
      'rating': rating,
      'barcode': barcode,
      'price': price,
      'image': image,
      'attachment': attachment,
      // 'special': special,
      // 'special_price': specialPrice,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    // if (map == null) return null;

    return ProductModel(
      product_id: map['product_id'] ?? 0,
      rating: map['rating'].toDouble(),
      name: map['name'] ?? '',
      barcode: map['barcode'] ?? '',
      price: map['price_formated'] ?? '',
      image: map['thumb'] ?? map['image'],
      // image: "",
      attachment: map['attachment'] ?? '',
      // special: map['special']??"",
      // specialPrice: map['special_price'] ?? '',

    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
