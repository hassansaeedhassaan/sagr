import 'dart:convert';


class CategoryModel {
  int? id;
  String? name;
  String? image;

  CategoryModel({ this.id,  this.name, this.image});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'image': image };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> json) {

    return CategoryModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        image: json['image'] ?? '' );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
       image: json['image'] ?? ''
    );
  }
}
