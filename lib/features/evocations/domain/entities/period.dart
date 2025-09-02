import 'package:equatable/equatable.dart';

class Period extends Equatable {
  
  final int? id;

  final String? period;

  const Period({required this.id,this.period});

  @override
  List<Object?> get props => [id,period];


  // Optional: Add copyWith for immutability and easy updates
  Period copyWith({
    int? id,
    String? period
  }) {
    return Period(
      id: id ?? this.id,
      period: period ?? this.period
    );
  }

  // Optional: Add factory constructor for JSON parsing
  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      id: json['id'],
      period: json['period'] 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'period': period,
   
    };
  }
}