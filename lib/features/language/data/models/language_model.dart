import '../../domain/entities/language.dart';

class LanguageModel extends Language {

  final int? id;

  final String? name;

  final String? code;

  const LanguageModel({ this.id, this.name, this.code }) : super( id: id,name: name);
  
  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel( id: json['id'], name: json['name']);
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