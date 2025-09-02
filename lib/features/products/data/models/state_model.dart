import 'dart:convert';
import 'package:sagr/features/products/data/models/city_model.dart';



class StateModel {
  final int? id;
  final String name;
  final List<CityModel>? cities;

  StateModel({ this.id,  required this.name, this.cities});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name };
  }

  factory StateModel.fromMap(Map<String, dynamic> json) {
    // if (json == null) return null;


    List<CityModel> cities = [];

    if (json['cities'] != null) {
      json['cities'].forEach((child) {
        cities.add(CityModel.fromMap(child));
      });
    }

    return StateModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        cities: cities);
  }

  String toJson() => json.encode(toMap());

  factory StateModel.fromJson(Map<String, dynamic> json) {


     List<CityModel> cities = [];

    if (json['cities'] != null) {
      json['cities'].forEach((child) {
        cities.add(CityModel.fromMap(child));
      });
    }

    return StateModel(
        id: json['id'], name: json['name'], cities: cities);
  }
}
