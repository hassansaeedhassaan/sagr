import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final int? id;
  final String? sender_name;
  final String? sender_avatar;
  final int? unread_count;
  final String? created_at;
  final String? message;



  Conversation({
    required this.id,
    this.sender_name,
    this.sender_avatar,
    this.unread_count,
    this.created_at,
    this.message
  });
  

  @override
  List<Object?> get props => [
        id,
        sender_name,
        sender_avatar,
        unread_count,
        created_at,
        message
      ];
}
