import 'package:equatable/equatable.dart';

enum MessageType { text, image, audio, video, document }
enum MessageStatus { sending, sent, delivered, read }

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
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      type: MessageType.values[json['type']],
      status: MessageStatus.values[json['status']],
      timestamp: DateTime.parse(json['timestamp']),
      mediaUrl: json['media_url'],
      audioDuration: json['audio_duration'],
      isGroupMessage: json['is_group_message'] ?? false,
      replyToId: json['reply_to_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'type': type.index,
      'status': status.index,
      'timestamp': timestamp.toIso8601String(),
      'media_url': mediaUrl,
      'audio_duration': audioDuration,
      'is_group_message': isGroupMessage,
      'reply_to_id': replyToId,
    };
  }

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
    );
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