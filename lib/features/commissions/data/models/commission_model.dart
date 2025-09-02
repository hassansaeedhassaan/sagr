import 'dart:convert';

import '../../domain/entities/commission.dart';

class CommissionModel extends Commission {
  CommissionModel(
      {int? id,
      Advertisment? advertisement,
      String? amount,
      String? commission,
      String? amount_after_commission,
      String? currency,
      String? is_paid})
      : super(
            id: id,
            advertisement: advertisement,
            amount: amount,
            commission: commission,
            amount_after_commission: amount_after_commission,
            currency: currency,
            is_paid: is_paid);

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    return CommissionModel(
        id: json['id'],
        advertisement: Advertisment.fromJson(json['advertisement']),
        amount: json['amount'],
        commission: json['commission'],
        amount_after_commission: json['amount_after_commission'],
        currency: json['currency'],
        is_paid: json['is_paid']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'advertisement': advertisement,
      'amount': amount,
      'commission': commission,
      'amount_after_commission': amount_after_commission,
      'currency': currency,
      'is_paid': is_paid,

    };
  }
}

class Advertisment {
  String? id;
  String? name;

  Advertisment({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Advertisment.fromMap(Map<String, dynamic> json) {
    return Advertisment(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Advertisment.fromJson(Map<String, dynamic> json) {
    return Advertisment(id: json['id'], name: json['name']);
  }
}
