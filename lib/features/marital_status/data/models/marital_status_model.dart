import '../../domain/entities/marital_status.dart';

class MaritalStatusModel extends MaritalStatus {

  final int? id;

  final String? name;

   const MaritalStatusModel({ this.id, this.name }) : super( id: id,name: name);
  
  factory MaritalStatusModel.fromJson(Map<String, dynamic> json) {
    return MaritalStatusModel( id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id,'name': name};
  }


  @override
  String toString() {
    return name!;
  }
}