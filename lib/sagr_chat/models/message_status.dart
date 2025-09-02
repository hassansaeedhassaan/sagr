class MessageStatus {
  final int id;
  final int messageId;
  final int userId;
  final String status;
  final DateTime statusUpdatedAt;

  MessageStatus({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.status,
    required this.statusUpdatedAt,
  });

  factory MessageStatus.fromJson(Map<String, dynamic> json) {
    return MessageStatus(
      id: json['id'],
      messageId: json['message_id'],
      userId: json['user_id'],
      status: json['status'],
      statusUpdatedAt: DateTime.parse(json['status_updated_at']),
    );
  }

  bool get isSent => status == 'sent';
  bool get isDelivered => status == 'delivered';
  bool get isRead => status == 'read';
}