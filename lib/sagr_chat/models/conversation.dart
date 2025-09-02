import 'package:get/utils.dart';

import 'user.dart';
import 'message.dart';

class Conversation {
  final int id;
  final String? name;
  final String? avatar;
  final String type;
  final int createdBy;
  final List<User> participants;
  final Message? lastMessage;
  final int participantsCount;
  final DateTime updatedAt;
  final Map<String, dynamic>? settings;

  Conversation({
    required this.id,
    this.name,
    this.avatar,
    required this.type,
    required this.createdBy,
    required this.participants,
    this.lastMessage,
    required this.participantsCount,
    required this.updatedAt,
    this.settings,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      type: json['type'],
      createdBy: json['created_by']??0,
      participants: (json['participants'] as List?)
          ?.map((p) => User.fromJson(p))
          .toList() ?? [],
      lastMessage: json['last_message'] != null 
          ? Message.fromJson(json['last_message']) 
          : null,
      participantsCount: json['participants_count'] ?? 0,
      updatedAt: DateTime.parse(json['updated_at']),
      settings: json['settings'],
    );
  }

  bool get isGroupChat => type == 'group';
  bool get isPrivateChat => type == 'private';

  String getDisplayName(int currentUserId) {
    if (isGroupChat) {
      return name ?? 'Group Chat';
    }
    
    // For private chats, return the other participant's name
    final otherParticipant = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => User(id: 0, name: 'Unknown', email: '', status: 'offline'),
    );
    
    return otherParticipant.name;
  }

  String? getDisplayAvatar(int currentUserId) {
    if (isGroupChat) {
      return avatar;
    }
    
    // For private chats, return the other participant's avatar
    final otherParticipant = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => User(id: 0, name: 'Unknown', email: '', status: 'offline'),
    );
    
    return otherParticipant.avatar;
  }
// User? getOtherParticipant(int currentUserId) {
//   if (isPrivateChat) {
//     return participants.firstWhere(
//       (p) => p.id != currentUserId,
//       orElse: () => null,
//     );
//   }
//   return null;
// }

User? getOtherParticipant(int currentUserId) {
  if (isPrivateChat) {
    return participants.firstWhereOrNull((p) => p.id != currentUserId);
  }
  return null;
}


// User getOtherParticipant(int currentUserId) {
//   if (!isPrivateChat) {
//     throw StateError('Cannot get other participant in non-private chat');
//   }
  
//   return participants.firstWhere(
//     (p) => p.id != currentUserId,
//     orElse: () => throw StateError('Other participant not found'),
//   );
// }
}
