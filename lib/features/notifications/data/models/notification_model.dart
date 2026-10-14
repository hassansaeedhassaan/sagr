import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    String? id,
    String? title,
    String? content,
    String? image,
    String? created_at,
    String? action,
    bool? is_read,
    String? type,
    Map<String, dynamic> data = const {},
  }) : super(
            id: id,
            title: title,
            content: content,
            image: image,
            created_at: created_at,
            action: action,
            is_read: is_read,
            type: type,
            data: data);

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return NotificationModel(
        id: json['id']?.toString(),
        title: json['title']?.toString(),
        // API sends the body as `message`; `content` is the legacy key.
        content: (json['message'] ?? json['content'])?.toString(),
        image: json['image']?.toString(),
        created_at: json['created_at']?.toString(),
        action: json['action']?.toString(),
        type: json['type']?.toString(),
        data: data is Map ? Map<String, dynamic>.from(data) : const {},
        is_read: json['is_read'] == true ||
            json['is_read'] == 1 ||
            (json['is_read'] == null && json['read_at'] != null));
  }

  NotificationModel copyWith({bool? is_read}) {
    return NotificationModel(
      id: id,
      title: title,
      content: content,
      image: image,
      created_at: created_at,
      action: action,
      type: type,
      data: data,
      is_read: is_read ?? this.is_read,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': content,
      'image': image,
      'created_at': created_at,
      'action': action,
      'type': type,
      'data': data,
      'is_read': is_read,
    };
  }
}
