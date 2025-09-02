import 'dart:convert';

import '../../domain/entities/card.dart';

class CardModel extends Card {
  CardModel(
      {String? id,
      String? name,
      int? expire_month,
      int? expire_year,
      String? last_four_numbers,
      String? brand,
      bool? is_default})
      : super(
            id: id,
            name: name,
           expire_month:expire_month,
           expire_year:expire_year,
            last_four_numbers: last_four_numbers,
            brand: brand,
            is_default: is_default);

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
        id: json['id'],
        name:json['name'],
        expire_month: json['expire_month'],
        expire_year: json['expire_year'],
        last_four_numbers: json['last_four_numbers'],
        brand: json['brand'],
        is_default: json['is_default']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'expire_month': expire_month,
      'expire_year': expire_year,
      'last_four_numbers': last_four_numbers,
      'brand': brand,
      'is_default': is_default,

    };
  }
}

class Advertisment {
  String? id;
  String? name;

  Advertisment({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Advertisment.fromMap(Map<String, dynamic> json) {
    return Advertisment(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Advertisment.fromJson(Map<String, dynamic> json) {
    return Advertisment(id: json['id'], name: json['name']);
  }
}
