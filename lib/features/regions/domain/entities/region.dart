import 'package:equatable/equatable.dart';

class Region extends Equatable {
  
  final int? id;

  final String? name;

  final String? code;

  const Region({required this.id,this.name,this.code});

  @override
  List<Object?> get props => [id,name,code];



  // Optional: Add copyWith for immutability and easy updates
  Region copyWith({
    int? id,
    String? name,
    String? code
  
  }) {
    return Region(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }

  // Optional: Add factory constructor for JSON parsing
  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code
    };
  }
}
