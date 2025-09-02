import 'dart:convert';

class CityModel {
  final int? id;
  final String name;

  CityModel({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory CityModel.fromMap(Map<String, dynamic> json) {
    // if (json == null) return null;
    return CityModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

 

    factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
        id: json['id'], name: json['name']);
  }

}
