import '../../domain/entities/marital_status.dart';

class MaritalStatusModel extends MaritalStatus {
  const MaritalStatusModel({  int? id, String? name })  : super(  id: id,  name: name );

  factory MaritalStatusModel.fromJson(Map<String, dynamic> json) {
    return MaritalStatusModel(
        id: json['id'],
        name: json['name'],
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
    };
  }
}
