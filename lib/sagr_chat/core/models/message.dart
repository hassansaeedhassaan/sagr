import 'package:equatable/equatable.dart';

enum MessageType { 
  text, 
  image, 
  video, 
  audio, 
  document 
}

enum MessageStatus { 
  sending, 
  sent, 
  delivered, 
  read 
}

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String? receiverId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final String? mediaUrl;
  final int? audioDuration;
  final bool isGroupMessage;
  final String? replyToId;
  
  // Additional fields from API
  final MessageSender? sender;
  final MessageSender? receiver;
  final Message? replyTo;
  final DateTime? updatedAt;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.receiverId,
    required this.content,
    required this.type,
    required this.status,
    required this.timestamp,
    this.mediaUrl,
    this.audioDuration,
    this.isGroupMessage = false,
    this.replyToId,
    this.sender,
    this.receiver,
    this.replyTo,
    this.updatedAt,
  });

  // ✅ Manual JSON parsing (بدون code generation)
  factory Message.fromJson(Map<String, dynamic> json) {
    try {
      return Message(
        id: json['id']?.toString() ?? '',
        chatId: json['chat_id']?.toString() ?? '',
        senderId: json['sender_id']?.toString() ?? '',
        receiverId: json['receiver_id']?.toString(),
        content: json['content']?.toString() ?? '',
        type: _parseMessageType(json['type']),
        status: _parseMessageStatus(json['status']),
        timestamp: _parseDateTime(json['created_at']) ?? DateTime.now(),
        mediaUrl: json['media_url']?.toString(),
        audioDuration: _parseInt(json['audio_duration']),
        isGroupMessage: json['is_group_message'] == true || json['is_group_message'] == 1,
        replyToId: json['reply_to_id']?.toString(),
        sender: json['sender'] != null ? MessageSender.fromJson(json['sender']) : null,
        receiver: json['receiver'] != null ? MessageSender.fromJson(json['receiver']) : null,
        replyTo: json['reply_to'] != null ? Message.fromJson(json['reply_to']) : null,
        updatedAt: _parseDateTime(json['updated_at']),
      );
    } catch (e) {
      throw FormatException('Failed to parse Message from JSON: $e');
    }
  }

  // ✅ Manual JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'chat_id': chatId,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'content': content,
    'type': type.name,
    'status': status.name,
    'created_at': timestamp.toIso8601String(),
    'media_url': mediaUrl,
    'audio_duration': audioDuration,
    'is_group_message': isGroupMessage,
    'reply_to_id': replyToId,
    'sender': sender?.toJson(),
    'receiver': receiver?.toJson(),
    'reply_to': replyTo?.toJson(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? mediaUrl,
    int? audioDuration,
    bool? isGroupMessage,
    String? replyToId,
    MessageSender? sender,
    MessageSender? receiver,
    Message? replyTo,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      audioDuration: audioDuration ?? this.audioDuration,
      isGroupMessage: isGroupMessage ?? this.isGroupMessage,
      replyToId: replyToId ?? this.replyToId,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      replyTo: replyTo ?? this.replyTo,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get isText => type == MessageType.text;
  bool get isMedia => [MessageType.image, MessageType.video, MessageType.audio, MessageType.document].contains(type);
  bool get isImage => type == MessageType.image;
  bool get isVideo => type == MessageType.video;
  bool get isAudio => type == MessageType.audio;
  bool get isDocument => type == MessageType.document;
  
  bool get isSent => [MessageStatus.sent, MessageStatus.delivered, MessageStatus.read].contains(status);
  bool get isDelivered => [MessageStatus.delivered, MessageStatus.read].contains(status);
  bool get isRead => status == MessageStatus.read;
  bool get isSending => status == MessageStatus.sending;
  
  bool get hasReply => replyToId != null && replyTo != null;
  bool get hasMedia => mediaUrl != null && mediaUrl!.isNotEmpty;
  
  String get displayContent {
    switch (type) {
      case MessageType.text:
        return content;
      case MessageType.image:
        return '📷 Image';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.audio:
        return '🎵 Voice message';
      case MessageType.document:
        return '📄 Document';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }

  // Static helper methods
  static MessageType _parseMessageType(dynamic value) {
    if (value == null) return MessageType.text;
    
    if (value is int) {
      switch (value) {
        case 0: return MessageType.text;
        case 1: return MessageType.image;
        case 2: return MessageType.video;
        case 3: return MessageType.audio;
        case 4: return MessageType.document;
        default: return MessageType.text;
      }
    }
    
    final stringValue = value.toString().toLowerCase();
    switch (stringValue) {
      case 'text': return MessageType.text;
      case 'image': return MessageType.image;
      case 'video': return MessageType.video;
      case 'audio': return MessageType.audio;
      case 'document': return MessageType.document;
      default: return MessageType.text;
    }
  }

  static MessageStatus _parseMessageStatus(dynamic value) {
    if (value == null) return MessageStatus.sent;
    
    if (value is int) {
      switch (value) {
        case 0: return MessageStatus.sending;
        case 1: return MessageStatus.sent;
        case 2: return MessageStatus.delivered;
        case 3: return MessageStatus.read;
        default: return MessageStatus.sent;
      }
    }
    
    final stringValue = value.toString().toLowerCase();
    switch (stringValue) {
      case 'sending': return MessageStatus.sending;
      case 'sent': return MessageStatus.sent;
      case 'delivered': return MessageStatus.delivered;
      case 'read': return MessageStatus.read;
      default: return MessageStatus.sent;
    }
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
        chatId,
        senderId,
        receiverId,
        content,
        type,
        status,
        timestamp,
        mediaUrl,
        audioDuration,
        isGroupMessage,
        replyToId,
      ];
}

// Message sender/receiver info
class MessageSender extends Equatable {
  final String id;
  final String name;
  final String? avatar;

  const MessageSender({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) => MessageSender(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    avatar: json['avatar']?.toString(),
    
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
  };

  @override
  List<Object?> get props => [id, name, avatar];
}
