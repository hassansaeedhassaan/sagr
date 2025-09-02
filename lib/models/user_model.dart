import 'dart:convert';


class UserModel {
  int id;
  String? name;
  String? username;

  UserModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }


  factory UserModel.fromMap(Map<String, dynamic> json) {
    // if (json == null) return UserModel();

    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) =>
  //     UserModel.fromMap(json.decode(source));


   factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name']
    );
  }
}
