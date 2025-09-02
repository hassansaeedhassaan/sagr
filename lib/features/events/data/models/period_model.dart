import 'dart:convert';

class PeriodModel {
  final int? id;
  final String period;

  PeriodModel({this.id, required this.period});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': period};
  }

  factory PeriodModel.fromMap(Map<String, dynamic> json) {
    // if (json == null) return null;
    return PeriodModel(id: json['id'] ?? 0, period: json['period'] ?? '');
  }

  String toJson() => json.encode(toMap());

 

    factory PeriodModel.fromJson(Map<String, dynamic> json) {
    return PeriodModel(
        id: json['id'], period: json['period']);
  }

}
