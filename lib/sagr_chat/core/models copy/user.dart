import 'package:equatable/equatable.dart';
import 'dart:convert'; // إضافة

enum UserStatus { online, offline, away }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final UserStatus status;
  final DateTime? lastSeen;
  final String? fcmToken;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.status = UserStatus.offline,
    this.lastSeen,
    this.fcmToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      status: UserStatus.values[json['status'] ?? 1],
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'])
          : null,
      fcmToken: json['fcm_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'status': status.index,
      'last_seen': lastSeen?.toIso8601String(),
      'fcm_token': fcmToken,
    };
  }

  // إضافة copyWith method
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    UserStatus? status,
    DateTime? lastSeen,
    String? fcmToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatar,
        status,
        lastSeen,
        fcmToken,
      ];
}