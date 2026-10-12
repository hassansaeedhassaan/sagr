import 'dart:convert';

class JobModel {
  final int? id;
  final String name;
  final int? quantity;
  final String? displayName;

  JobModel({this.id, required this.name, this.quantity, this.displayName});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'quantity' : quantity, 'display_name': displayName};
  }

  factory JobModel.fromMap(Map<String, dynamic> json) {
    // if (json == null) return null;
    return JobModel(id: json['id'] ?? 0, name: json['name'] ?? '', quantity: json['quantity']??1, displayName: json['display_name']?? "");
  }

  String toJson() => json.encode(toMap());

    factory JobModel.fromJson(Map<String, dynamic> json) {
    // Null-safe: one job without a name used to throw and fail the whole
    // event's parsing.
    return JobModel(
        id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
        name: json['name']?.toString() ?? '',
        quantity: json['quantity'] is int
            ? json['quantity']
            : int.tryParse('${json['quantity']}'),
        displayName: json['display_name']?.toString());
  }

}
