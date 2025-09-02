import 'dart:convert';

import 'package:sagr/features/chat/domain/entities/message.dart';


class MessageModel extends Message {
  MessageModel(
      {int? id,
      UserObjectInMessage? sender,
      UserObjectInMessage? receiver,
      String? created_at,
      String? type,
      bool? is_read,
      String? message,
      OfferObjectInMessage? offer,
      })
      : super(
            id: id,
            sender: sender,
            receiver: receiver,
            type: type,
            created_at: created_at,
            offer: offer,
            is_read: is_read,
            message: message);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        id: json['id'],
        sender: UserObjectInMessage.fromJson(json['sender']),
        receiver: UserObjectInMessage.fromJson(json['receiver']),
        is_read: json['is_read'],
        created_at: json['created_at'],
        offer: json['offer'] != null ? OfferObjectInMessage.fromJson(json['offer']) :null,
        type: json['type'],
        message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'is_read': is_read,
      'offer': offer,
      'created_at': created_at,
      'message': message,
      'type': type
    };
  }
  

}

class UserObjectInMessage {
  int? id;
  String? name;
  String? avatar;

  UserObjectInMessage({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory UserObjectInMessage.fromMap(Map<String, dynamic> json) {
    return UserObjectInMessage(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserObjectInMessage.fromJson(Map<String, dynamic> json) {
    return UserObjectInMessage(id: json['id'], name: json['name']);
  }
}



class OfferObjectInMessage {
  int? id;
  String? price;
  String? status;
  AdvertismentInOfferModel? advertisment;

  OfferObjectInMessage({this.id, this.price, this.status, this.advertisment});

  Map<String, dynamic> toMap() {
    return {'id': id, 'price': price, 'status': status, 'advertisement': advertisment} ;
  }

  factory OfferObjectInMessage.fromMap(Map<String, dynamic> json) {
    return OfferObjectInMessage(id: json['id'] ?? 0, price: json['price'] ?? '', status: json['status'], advertisment: AdvertismentInOfferModel.fromJson(json['advertisement']));
  }

  String toJson() => json.encode(toMap());

  factory OfferObjectInMessage.fromJson(Map<String, dynamic> json) {
    return OfferObjectInMessage(id: json['id'], price: json['price'], status: json['status'], advertisment: AdvertismentInOfferModel.fromJson(json['advertisement']));
  }
}


class AdvertismentInOfferModel {
  int? id;
  String? name;
  String? currency;
  String? image;

  AdvertismentInOfferModel({this.id, this.name, this.currency, this.image});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'currency': currency, 'image': image};
  }

  factory AdvertismentInOfferModel.fromMap(Map<String, dynamic> json) {
    return AdvertismentInOfferModel(id: json['id'] ?? 0, name: json['name'] ?? '', currency: json['currency'], image: json['image']);
  }

  String toJson() => json.encode(toMap());

  factory AdvertismentInOfferModel.fromJson(Map<String, dynamic> json) {
    return AdvertismentInOfferModel(id: json['id'], name: json['name'], currency: json['currency'], image: json['image']);
  }
}
