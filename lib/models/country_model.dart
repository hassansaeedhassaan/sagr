import 'dart:convert';

class CountryModel {
  int? id;
  String? name;
  String? code;
  String? currency;
  List<CountryModel>? states;

  CountryModel({ this.id,  this.name, this.code, this.currency, this.states});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'code': code, 'currency': currency };
  }

  factory CountryModel.fromMap(Map<String, dynamic> json) {
    // if (json == null) return null;

    List<CountryModel> states = [];

    if (json['states'] != null) {
      json['states'].forEach((child) {
        states.add(CountryModel.fromMap(child));
      });
    }

    return CountryModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        code: json['code'] ?? '',
        currency: json['currency'] ?? '',
        states: states);
  }

  String toJson() => json.encode(toMap());

  factory CountryModel.fromJson(String source) =>
      CountryModel.fromMap(json.decode(source));
}
