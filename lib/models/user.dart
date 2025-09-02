import 'dart:convert';

// import 'package:meta/meta.dart';

class User {
  int id;
  String email = "";
  String name = "";
  String phone = "";
  String? avatarUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    // if (map == null) return null;

    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  // factory User.fromJson(json) {
  //   return User(
  //       id: json['id'],
  //       email: json['email'] ?? "",
  //       name: json['name'] ?? "",
  //       phone: json['phone'] ?? "");
  // }
}
