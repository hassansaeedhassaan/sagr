import 'package:sagr/features/products/data/models/state_model.dart';

import '../../domain/entities/country.dart';

class CountryModel extends Country {
  CountryModel({
    int? id,
    String? name,
    String? image,
    List<StateModel>? states
  }) : super(
          id: id,
          name: name,
          image: image,
          states: states
        );

  factory CountryModel.fromJson(Map<String, dynamic> json) {


    List<StateModel> states = [];
      if (json['states'] != null) {
      json['states'].forEach((child) {
        states.add(StateModel.fromJson(child));
      });
    }

    return CountryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? "",
      states: states
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'states' : states };
  }



}
