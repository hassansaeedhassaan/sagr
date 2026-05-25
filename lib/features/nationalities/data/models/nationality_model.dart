import '../../domain/entities/nationality.dart';

class NationalityModel extends Nationality {
  const NationalityModel({
    super.id,
    super.name,
  });

  factory NationalityModel.fromJson(Map<String, dynamic> json) {
    return NationalityModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  bool get isNull => id == null && name == null;
  
  // Alternative: check if it's "empty" or invalid
  bool get isValid => id != null || name != null;

  // Optionally convert model to entity
  Nationality toEntity() => Nationality(id: id, name: name);
}