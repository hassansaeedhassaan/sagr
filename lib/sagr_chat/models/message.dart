import 'message_status.dart';
import 'user.dart';

class Message {
  final int id;
  final int conversationId;
  final int senderId;
  final int? replyToId;
  final String type;
  final String? content;
  final Map<String, dynamic>? media;
  final bool isEdited;
  final DateTime? editedAt;
  final DateTime createdAt;
  final User? sender;
  final Message? replyTo;
  final List<MessageStatus> statuses;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.replyToId,
    required this.type,
    this.content,
    this.media,
    required this.isEdited,
    this.editedAt,
    required this.createdAt,
    this.sender,
    this.replyTo,
    required this.statuses,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      replyToId: json['reply_to_id'],
      type: json['type'],
      content: json['content'],
      media: json['media'],
      isEdited: json['is_edited'] ?? false,
      editedAt: json['edited_at'] != null ? DateTime.parse(json['edited_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      sender: json['sender'] != null ? User.fromJson(json['sender']) : null,
      // replyTo: json['reply_to') != null ? Message.fromJson(json['reply_to']) : null,
      statuses: (json['statuses'] as List?)
          ?.map((s) => MessageStatus.fromJson(s))
          .toList() ?? [],
    );
  }

  bool get isTextMessage => type == 'text';
  bool get isImageMessage => type == 'image';
  bool get isVideoMessage => type == 'video';
  bool get isAudioMessage => type == 'audio';
  bool get isVoiceMessage => type == 'voice_note';
  bool get isDocumentMessage => type == 'document';
  bool get isMediaMessage => !isTextMessage;

  String get displayContent {
    switch (type) {
      case 'text':
        return content ?? '';
      case 'image':
        return '📷 Photo';
      case 'video':
        return '🎥 Video';
      case 'audio':
        return '🎵 Audio';
      case 'voice_note':
        return '🎤 Voice message';
      case 'document':
        return '📄 ${media?['original_name'] ?? 'Document'}';
      default:
        return 'Message';
    }
  }

  String? get mediaUrl {
    if (media != null && media!['path'] != null) {
      return media!['path'];
    }
    return null;
  }

  String? get fileName {
    return media?['original_name'];
  }

  int? get fileSize {
    return media?['size'];
  }

  int? get duration {
    return int.tryParse(media?['duration']);
  }

  bool hasBeenReadBy(int userId) {
    return statuses.any((s) => s.userId == userId && s.status == 'read');
  }

  bool hasBeenDeliveredTo(int userId) {
    return statuses.any((s) => s.userId == userId && 
        (s.status == 'delivered' || s.status == 'read'));
  }


   void dump() {
    print('═══════════════════════════════════════');
    print('MESSAGE DUMP');
    print('═══════════════════════════════════════');
    print('ID: $id');
    print('Conversation ID: $conversationId');
    print('Sender ID: $senderId');
    print('Type: $type');
    print('Content: $content');
    print('Media URL: $mediaUrl');
    print('Reply To ID: $replyToId');
    print('Created At: $createdAt');
    print('Duration: $duration');
    print('File Name: $fileName');
    print('File Size: $fileSize');
    print('Display Content: $displayContent');
    print('Sender: ${sender?.toJson()}');
    // print('Reply To: ${replyTo?.toJson()}');
    // print('Statuses: ${statuses.map((s) => s.toJson()).toList()}');
    print('═══════════════════════════════════════');
  }


  

}
