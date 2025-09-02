import '../../domain/entities/education.dart';

class EducationModel extends Education {

  final int? id;

  final String? name;

  const EducationModel({ this.id, this.name }) : super( id: id,name: name);
  
  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel( id: json['id'], name: json['name']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id,'name': name};
  }

  @override
  String toString() {
    return name!;
  }
}