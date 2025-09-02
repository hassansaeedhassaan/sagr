import 'package:equatable/equatable.dart';
import 'user.dart';
import 'message.dart';

enum ChatType { individual, group }

class Chat extends Equatable {
  final String id;
  final String name;
  final String? avatar;
  final ChatType type;
  final List<String> participantIds;
  final Message? lastMessage;
  final DateTime? lastActivity;
  final int unreadCount;
  final String? groupAdminId;
  final String? description;

  const Chat({
    required this.id,
    required this.name,
    this.avatar,
    required this.type,
    required this.participantIds,
    this.lastMessage,
    this.lastActivity,
    this.unreadCount = 0,
    this.groupAdminId,
    this.description,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      avatar: json['avatar'],
      type: json['type'] == 'group' ? ChatType.group : ChatType.individual,
      participantIds: json['participant_ids'] != null 
          ? List<String>.from(json['participant_ids'].map((x) => x.toString()))
          : [],
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      lastActivity: json['last_activity'] != null
          ? DateTime.parse(json['last_activity'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      groupAdminId: json['group_admin_id']?.toString(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'type': type == ChatType.group ? 'group' : 'individual',
      'participant_ids': participantIds,
      'last_message': lastMessage?.toJson(),
      'last_activity': lastActivity?.toIso8601String(),
      'unread_count': unreadCount,
      'group_admin_id': groupAdminId,
      'description': description,
    };
  }

  // إضافة copyWith method
  Chat copyWith({
    String? id,
    String? name,
    String? avatar,
    ChatType? type,
    List<String>? participantIds,
    Message? lastMessage,
    DateTime? lastActivity,
    int? unreadCount,
    String? groupAdminId,
    String? description,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastActivity: lastActivity ?? this.lastActivity,
      unreadCount: unreadCount ?? this.unreadCount,
      groupAdminId: groupAdminId ?? this.groupAdminId,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        type,
        participantIds,
        lastMessage,
        lastActivity,
        unreadCount,
        groupAdminId,
        description,
      ];
}