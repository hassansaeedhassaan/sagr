import 'package:sagr/features/products/data/models/state_model.dart';
import 'package:sagr/features/products/domain/entities/nationality.dart';
class NationalityModel extends Nationality {
  NationalityModel({
    int? id,
    required String name,
    required String currency,
    required String code,
    required List<StateModel> states,
  
  }) : super(
            id: id,
            name: name,
            currency: currency,
            code: code,
            states: states
     );

  factory NationalityModel.fromJson(Map<String, dynamic> json) {


    List<StateModel> states = [];

    if (json['states'] != null) {
      json['states'].forEach((child) {
        states.add(StateModel.fromMap(child));
      });
    }
    return NationalityModel(
      id: json['id'],
      name: json['name'],
      currency: json['currency'],
      code: json['code'],
      states: states

    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'currency': currency, 'code': code, 'states': states};
  }
}
