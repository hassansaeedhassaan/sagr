import 'package:equatable/equatable.dart';
import 'package:sagr/features/products/data/models/city_model.dart';

class Zone extends Equatable {
  final int? id;
  final String name;
  final List<CityModel>? cities;

  Zone({
    required this.id,
    required this.name, 
    this.cities,
  });

  @override
  List<Object?> get props => [id, name, cities];
}
