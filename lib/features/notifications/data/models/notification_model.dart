import '../../domain/entities/notification.dart';

  // final int? id;
  // final String? title;
  // final String? content;
  // final String? image;
  // final String? created_at;
  // final String? action;
  // final bool? is_read;

  
class NotificationModel extends Notification {
  NotificationModel(
      {
      String? id,
      String? title,
      String? content,
      String? image,
      String? created_at,
      String? action,
      bool? is_read})
      : super(
            id: id,
            title: title,
            content: content,
            image: image,
            created_at: created_at,
            action: action,
            is_read: is_read);

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id']?.toString(),
        title: json['title']?.toString(),
        content: json['content']?.toString(),
        image: json['image']?.toString(),
        created_at: json['created_at']?.toString(),
        action: json['action']?.toString(),
        is_read: json['is_read'] == true ||
            json['is_read'] == 1 ||
            (json['is_read'] == null && json['read_at'] != null));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image': image,
      'created_at': created_at,
      'action': action,
      'is_read': is_read,

    };
  }
}

// class Payload {
//   String? id;
//   String? name;

//   Payload({this.id, this.name});

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'name': name};
//   }

//   factory Payload.fromMap(Map<String, dynamic> json) {
//     return Payload(id: json['id'] ?? 0, name: json['name'] ?? '');
//   }

//   String toJson() => json.encode(toMap());

//   factory Payload.fromJson(Map<String, dynamic> json) {
//     return Payload(id: json['id'], name: json['name']);
//   }
// }
