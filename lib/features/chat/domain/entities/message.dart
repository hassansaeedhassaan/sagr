import 'package:equatable/equatable.dart';

import '../../data/models/message_model.dart';

class Message extends Equatable {
  final int? id;
  final UserObjectInMessage? sender;
  final UserObjectInMessage? receiver;
  final String? created_at;
  final String? message;
  final String? type;
  final OfferObjectInMessage? offer;
  final bool? is_read;



  Message({
    required this.id,
    this.sender,
    this.receiver,
    this.type,
    this.offer,
    this.created_at,
    this.message,
    this.is_read
  });
  

  @override
  List<Object?> get props => [
        id,
        sender,
        receiver,
        type,
        offer,
        created_at,
        message,
        is_read
      ];
}
