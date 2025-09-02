import 'package:sagr/features/products/data/models/ad_user_model.dart';
import 'package:sagr/features/products/data/models/city_model.dart';
import 'package:sagr/features/products/data/models/nationality_model.dart';
import 'package:sagr/features/products/data/models/state_model.dart';
import 'package:sagr/models/category_model.dart';

import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    int? id,
    required String name,
    bool? isSold,
    required bool isFavourite,
    required bool isNegotiable,
    String? price_type,
    String? price,
    String? min_price,
    String? max_price,
    String? currency,
    String? phone_number,
    String? whatsapp_number,
    String? type,
    String? image,
    String? latitude,
    String? longitude,
    String? description,
    List? images,
    List? videos,
    CategoryModel? category,
    StateModel? state,
    CityModel? city,
    AdUserModel? adUser,
    required NationalityModel nationality,
    required String created_at,

  }) : super(
            id: id,
            name: name,
            isSold: isSold,
            isFavourite: isFavourite,
            isNegotiable: isNegotiable,
            price_type: price_type,
            price: price,
            min_price: min_price,
            max_price: max_price,
            currency: currency,
            phone_number: phone_number,
            whatsapp_number: whatsapp_number,
            type: type,
            image: image,
            latitude: latitude,
            longitude: longitude,
            description: description,
            images: images,
            videos: videos,
            nationality: nationality,
            category: category,
            adUser: adUser,
            state: state,
            city: city,
            created_at: created_at
            );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        id: json['id'],
        name: json['name'],
        isSold: json['isSold'] ?? false,
        isFavourite: json["is_favourite"],
        isNegotiable: json["is_negotiable"],
        price_type: json['price_type'] ?? "",
        price: json['price'] ?? "0",
        min_price: json['min_price'] ?? "",
        max_price: json['max_price'] ?? "",
        currency: json['currency'] ?? "",
        phone_number: json['phone_number'] ?? "",
        whatsapp_number: json['whatsapp_number'] ?? "",
        type: json['type'] ?? "",
        image: json['image'] ?? "",
        latitude: json['latitude'] ?? "",
        longitude: json['longitude'] ?? "",
        description: json['description'] ?? "",
        images: json['images'] ?? [],
        videos: json['videos'] ?? "",
        created_at: json['created_at'] ?? "",
        category: CategoryModel.fromJson(json['category']),
        state: StateModel.fromJson(json['state']),
        city: CityModel.fromJson(json['city']),
        adUser: AdUserModel.fromJson(json['user']),
        nationality: NationalityModel.fromJson(json['nationality']));
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
