import 'package:equatable/equatable.dart';

class Card extends Equatable {
  final String? id;
  final String? name;
  final int? expire_month;
  final int? expire_year;
  final String? last_four_numbers;
  final String? brand;
  final bool? is_default;

  Card(
      {
       required this.id,
      this.name,
      this.expire_month,
      this.expire_year,
      this.last_four_numbers,
      this.brand,
      this.is_default});

  @override
  List<Object?> get props =>
      [id, name, expire_year, last_four_numbers, brand, is_default];
}
