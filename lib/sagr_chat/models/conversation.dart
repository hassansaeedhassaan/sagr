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
  final int unreadCount;

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
    this.unreadCount = 0,
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
      unreadCount: json['unread_count'] ?? json['unread'] ?? 0,
    );
  }

  bool get isGroupChat => type == 'group';
  bool get isPrivateChat => type == 'private';

  String getDisplayName(int currentUserId) {
    if (isGroupChat) {
      return name ?? 'Group Chat';
    }

    // Prefer the other participant's name, but the conversations index may
    // omit `participants` — the backend already resolves the private-chat
    // title into `name`, so fall back to that before giving up.
    final otherParticipant =
        participants.firstWhereOrNull((p) => p.id != currentUserId);

    return otherParticipant?.name ?? name ?? 'Unknown';
  }

  String? getDisplayAvatar(int currentUserId) {
    if (isGroupChat) {
      return avatar;
    }

    // Same fallback logic as getDisplayName — top-level `avatar` carries the
    // other user's image when `participants` is absent.
    final otherParticipant =
        participants.firstWhereOrNull((p) => p.id != currentUserId);

    return otherParticipant?.avatar ?? avatar;
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
