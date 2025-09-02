import 'package:equatable/equatable.dart';

class MaritalStatus extends Equatable {
  
  final int? id;

  final String? name;

  const MaritalStatus({required this.id,this.name});

  @override
  List<Object?> get props => [id,name];



  // Optional: Add copyWith for immutability and easy updates
  MaritalStatus copyWith({
    int? id,
    String? name,
  
  }) {
    return MaritalStatus(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  // Optional: Add factory constructor for JSON parsing
  factory MaritalStatus.fromJson(Map<String, dynamic> json) {
    return MaritalStatus(
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
