import '../../domain/entities/region.dart';

class RegionModel extends Region {

  final int? id;

  final String? name;

  final String? code;

  const RegionModel({ this.id, this.name, this.code }) : super( id: id,name: name, code: code);
  
  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel( id: json['id'], name: json['name'], code: json['code']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id,'name': name, 'code': code};
  }
}