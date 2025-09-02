import 'package:equatable/equatable.dart';

class Job extends Equatable {
  
  final int? id;

  final String? name;

  const Job({required this.id,this.name});

  @override
  List<Object?> get props => [id,name];



  // Optional: Add copyWith for immutability and easy updates
  Job copyWith({
    int? id,
    String? name,
  
  }) {
    return Job(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  // Optional: Add factory constructor for JSON parsing
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
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
