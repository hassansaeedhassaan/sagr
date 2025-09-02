import 'package:equatable/equatable.dart';
import 'package:sagr/features/products/data/models/ad_user_model.dart';
import 'package:sagr/features/products/data/models/city_model.dart';
import 'package:sagr/features/products/data/models/nationality_model.dart';
import 'package:sagr/features/products/data/models/state_model.dart';
import 'package:sagr/models/category_model.dart';


class Product extends Equatable {
  final int? id;
  final String name;
  final String? status;
  final bool? isSold;
  final bool isFavourite;
  final bool isNegotiable;
  final String? price_type;
  final String? price;
  final String? min_price;
  final String? max_price;
  final String? currency;
  final String? phone_number;
  final String? whatsapp_number;
  final String? type;
  final String? image;
  final String? latitude;
  final String? longitude;
  final String? description;
  final List? images;
  final List? videos;
  final List? videos_thumbs;
  final NationalityModel nationality;
  final CategoryModel? category;
  final AdUserModel? adUser;
  final String created_at;
  final StateModel? state;
  final CityModel? city;
  

  Product(
      {required this.id,
      required this.name,
      this.status,
      this.isSold,
      required this.isFavourite,
      required this.isNegotiable,
      this.price_type,
      this.price,
      this.min_price,
      this.max_price,
      this.currency,
      this.phone_number,
      this.whatsapp_number,
      this.type,
      this.image,
      this.latitude,
      this.longitude,
      this.description,
      this.images,
      this.videos,
      this.videos_thumbs,
      required this.nationality,
      this.category, 
      this.adUser,
      required this.created_at,
      this.state,
      this.city
      });

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        isSold,
        isFavourite,
        isNegotiable,
        price_type,
        price,
        min_price,
        max_price,
        currency,
        phone_number,
        whatsapp_number,
        type,
        image,
        latitude,
        longitude,
        description,
        images,
        videos,
        videos_thumbs,
        nationality,
        category,
        created_at,
        adUser,
        state,
        city
      ];
}
