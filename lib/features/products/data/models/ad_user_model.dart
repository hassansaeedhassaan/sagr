import 'dart:convert';

class AdUserModel {
  int? id;
  String? name;
  String? image;

  AdUserModel({this.id, this.name, this.image});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'image': image};
  }

  factory AdUserModel.fromMap(Map<String, dynamic> json) {
    return AdUserModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory AdUserModel.fromJson(Map<String, dynamic> json) {
    return AdUserModel(
        id: json['id'], name: json['name'], image: json['image'] ?? '');
  }
}
