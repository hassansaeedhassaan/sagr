import 'package:equatable/equatable.dart';
import 'user.dart';
import 'message.dart';

enum ChatType { individual, group }

class Chat extends Equatable {
  final String id;
  final String? name;
  final String? avatar;
  final ChatType type;
  final List<String> participantIds;
  final Message? lastMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int unreadCount;
  final String? groupAdminId;
  final String? description;
  
  // Additional fields from API
  final List<ChatParticipant>? participants;
  final ChatParticipant? admin;
  final String? displayName;
  final String? displayAvatar;
  final bool? hasUnread;
  final int? participantCount;
  final DateTime? lastActivity;
  
  // For individual chats
  final String? otherUserId;
  final String? otherUserStatus;
  final DateTime? otherUserLastSeen;

  const Chat({
    required this.id,
    this.name,
    this.avatar,
    required this.type,
    this.participantIds = const [],
    this.lastMessage,
    this.createdAt,
    this.updatedAt,
    this.unreadCount = 0,
    this.groupAdminId,
    this.description,
    this.participants,
    this.admin,
    this.displayName,
    this.displayAvatar,
    this.hasUnread,
    this.participantCount,
    this.lastActivity,
    this.otherUserId,
    this.otherUserStatus,
    this.otherUserLastSeen,
  });

  // ✅ Manual JSON parsing
  factory Chat.fromJson(Map<String, dynamic> json) {
    try {
      return Chat(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString(),
        avatar: json['avatar']?.toString(),
        type: _parseChatType(json['type']),
        participantIds: _parseStringList(json['participant_ids']) ?? [],
        lastMessage: json['last_message'] != null 
            ? Message.fromJson(json['last_message']) 
            : null,
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
        unreadCount: _parseInt(json['unread_count']) ?? 0,
        groupAdminId: json['group_admin_id']?.toString(),
        description: json['description']?.toString(),
        participants: _parseParticipants(json['participants']),
        admin: json['admin'] != null 
            ? ChatParticipant.fromJson(json['admin']) 
            : null,
        displayName: json['display_name']?.toString(),
        displayAvatar: json['display_avatar']?.toString(),
        hasUnread: json['has_unread'] as bool?,
        participantCount: _parseInt(json['participant_count']),
        lastActivity: _parseDateTime(json['last_activity']),
        otherUserId: json['other_user_id']?.toString(),
        otherUserStatus: json['other_user_status']?.toString(),
        otherUserLastSeen: _parseDateTime(json['other_user_last_seen']),
      );
    } catch (e) {
      throw FormatException('Failed to parse Chat from JSON: $e');
    }
  }

  // ✅ Manual JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'type': type.name,
    'participant_ids': participantIds,
    'last_message': lastMessage?.toJson(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'unread_count': unreadCount,
    'group_admin_id': groupAdminId,
    'description': description,
    'participants': participants?.map((p) => p.toJson()).toList(),
    'admin': admin?.toJson(),
    'display_name': displayName,
    'display_avatar': displayAvatar,
    'has_unread': hasUnread,
    'participant_count': participantCount,
    'last_activity': lastActivity?.toIso8601String(),
    'other_user_id': otherUserId,
    'other_user_status': otherUserStatus,
    'other_user_last_seen': otherUserLastSeen?.toIso8601String(),
  };

  Chat copyWith({
    String? id,
    String? name,
    String? avatar,
    ChatType? type,
    List<String>? participantIds,
    Message? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadCount,
    String? groupAdminId,
    String? description,
    List<ChatParticipant>? participants,
    ChatParticipant? admin,
    String? displayName,
    String? displayAvatar,
    bool? hasUnread,
    int? participantCount,
    DateTime? lastActivity,
    String? otherUserId,
    String? otherUserStatus,
    DateTime? otherUserLastSeen,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
      groupAdminId: groupAdminId ?? this.groupAdminId,
      description: description ?? this.description,
      participants: participants ?? this.participants,
      admin: admin ?? this.admin,
      displayName: displayName ?? this.displayName,
      displayAvatar: displayAvatar ?? this.displayAvatar,
      hasUnread: hasUnread ?? this.hasUnread,
      participantCount: participantCount ?? this.participantCount,
      lastActivity: lastActivity ?? this.lastActivity,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserStatus: otherUserStatus ?? this.otherUserStatus,
      otherUserLastSeen: otherUserLastSeen ?? this.otherUserLastSeen,
    );
  }

  // Helper methods
  bool get isGroup => type == ChatType.group;
  bool get isIndividual => type == ChatType.individual;
  bool get hasLastMessage => lastMessage != null;
  bool get hasUnreadMessages => unreadCount > 0;
  
  String get effectiveName => displayName ?? name ?? 'Unknown Chat';
  String? get effectiveAvatar => displayAvatar ?? avatar;
  
  DateTime get effectiveLastActivity => 
      lastActivity ?? lastMessage?.timestamp ?? updatedAt ?? createdAt ?? DateTime.now();
  
  String get lastMessagePreview {
    if (lastMessage == null) return 'No messages yet';
    return lastMessage!.displayContent;
  }
  
  bool get isOtherUserOnline => otherUserStatus == 'online';
  
  String get otherUserStatusText {
    if (isGroup) return '${participantCount ?? 0} members';
    
    switch (otherUserStatus) {
      case 'online':
        return 'Online';
      case 'away':
        return 'Away';
      case 'offline':
        if (otherUserLastSeen != null) {
          final difference = DateTime.now().difference(otherUserLastSeen!);
          if (difference.inMinutes < 1) {
            return 'Last seen just now';
          } else if (difference.inHours < 1) {
            return 'Last seen ${difference.inMinutes}m ago';
          } else if (difference.inDays < 1) {
            return 'Last seen ${difference.inHours}h ago';
          } else {
            return 'Last seen ${difference.inDays}d ago';
          }
        }
        return 'Offline';
      default:
        return 'Unknown';
    }
  }

  // Static helper methods
  static ChatType _parseChatType(dynamic value) {
    if (value == null) return ChatType.individual;
    
    final stringValue = value.toString().toLowerCase();
    switch (stringValue) {
      case 'group':
        return ChatType.group;
      case 'individual':
      default:
        return ChatType.individual;
    }
  }

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    
    return null;
  }

  static List<ChatParticipant>? _parseParticipants(dynamic value) {
    if (value == null) return null;
    
    if (value is List) {
      return value
          .map((e) => ChatParticipant.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    
    try {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    } catch (e) {
      print('Error parsing datetime: $e');
    }
    
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    
    try {
      if (value is int) return value;
      if (value is String) return int.parse(value);
    } catch (e) {
      print('Error parsing int: $e');
    }
    
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        type,
        participantIds,
        lastMessage,
        createdAt,
        updatedAt,
        unreadCount,
        groupAdminId,
        description,
      ];
}

// Chat participant info
class ChatParticipant extends Equatable {
  final String id;
  final String name;
  final String? avatar;
  final String? status;
  final DateTime? lastSeen;
  final DateTime? joinedAt;

  const ChatParticipant({
    required this.id,
    required this.name,
    this.avatar,
    this.status,
    this.lastSeen,
    this.joinedAt,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) => ChatParticipant(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    avatar: json['avatar']?.toString(),
    status: json['status']?.toString(),
    lastSeen: json['last_seen'] != null ? DateTime.parse(json['last_seen']) : null,
    joinedAt: json['joined_at'] != null ? DateTime.parse(json['joined_at']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'status': status,
    'last_seen': lastSeen?.toIso8601String(),
    'joined_at': joinedAt?.toIso8601String(),
  };

  bool get isOnline => status == 'online';

  @override
  List<Object?> get props => [id, name, avatar, status, lastSeen, joinedAt];
}