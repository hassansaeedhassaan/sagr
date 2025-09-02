import 'dart:convert';

import 'package:sagr/features/chat/domain/entities/conversation.dart';


class ConversationModel extends Conversation {
  ConversationModel(
      {int? id,
  
      String? sender_name,
      String? sender_avatar,
      int? unread_count,
      String? created_at,
      String? message})
      : super(
            id: id,
            sender_name: sender_name,
            sender_avatar: sender_avatar,
            unread_count: unread_count,
            created_at: created_at,
            message: message);

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
        id: json['id'],
        sender_name: json['sender_name'],
        sender_avatar: json['sender_avatar'],
        unread_count: json['unread_count'],
        created_at: json['created_at'],
        message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_name': sender_name,
      'sender_avatar': sender_avatar,
      'unread_count': unread_count,
      'created_at': created_at,
      'message': message,

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
