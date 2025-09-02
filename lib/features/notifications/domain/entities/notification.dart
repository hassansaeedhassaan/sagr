import 'package:equatable/equatable.dart';





// "payload": {
//   "comment": "child 3",
//   "user_id": 29,
//   "comment_id": 50,
//   "advertisement_id": 125
//  }

class Notification extends Equatable {
  final int? id;
  final String? title;
  final String? content;
  final String? image;
  final String? created_at;
  final String? action;
  final bool? is_read;



  Notification({
    required this.id,

    this.title,
    this.content,
    this.image,
    this.created_at,
    this.action,
    this.is_read
  });
  

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        image,
        created_at,
        action,
        is_read
      ];
}
