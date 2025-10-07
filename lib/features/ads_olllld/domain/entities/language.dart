import 'package:equatable/equatable.dart';

class Language extends Equatable {
  
  final int? id;

  final String? name;

  const Language({required this.id,this.name});

  @override
  List<Object?> get props => [id,name];



  // Optional: Add copyWith for immutability and easy updates
  Language copyWith({
    int? id,
    String? name,
  
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  // Optional: Add factory constructor for JSON parsing
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
