import 'package:equatable/equatable.dart';
import 'package:sagr/features/countries/data/models/country_model.dart';
import 'package:sagr/features/products/data/models/state_model.dart';



class Country extends Equatable {
  final int? id;
  final String? name;
  final String? image;
  List<StateModel>? states;


  Country({
    required this.id,
    required this.name,
    this.image,
    this.states

  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        states
      ];
}
