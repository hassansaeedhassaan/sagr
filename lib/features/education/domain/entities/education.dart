import 'package:equatable/equatable.dart';

class Education extends Equatable {
  
  final int? id;

  final String? name;

  const Education({required this.id,this.name});

  @override
  List<Object?> get props => [id,name];



  // Optional: Add copyWith for immutability and easy updates
  Education copyWith({
    int? id,
    String? name,
  
  }) {
    return Education(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  // Optional: Add factory constructor for JSON parsing
  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
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
