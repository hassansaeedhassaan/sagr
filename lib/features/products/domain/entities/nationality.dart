import 'package:equatable/equatable.dart';
import 'package:sagr/features/products/data/models/state_model.dart';

class Nationality extends Equatable {
  final int? id;
  final String name;
  final String code;
  final String currency;
  final List<StateModel>? states;
  

  Nationality({
    required this.id,
    required this.name,
    required this.code,
    required this.currency,
    required this.states
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        currency,
        states
      ];
}




