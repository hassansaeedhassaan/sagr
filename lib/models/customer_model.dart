import 'dart:convert';

class CustomerModel {
  int? id;
  String? name;
  String? firstName;
  String? middleName;
  String? lastName;
  String? nationalID;
  String? phone;


  CustomerModel({ this.id,  this.name, this.firstName, this.middleName, this.lastName, this.nationalID, this.phone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'firstName': firstName, 'middleName': middleName, 'lastName': lastName,'nationalID': nationalID, 'phone': phone };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> json) {

    return CustomerModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        firstName: json['firstName'] ?? '',
        middleName: json['middleName'] ?? '',
        lastName: json['lastName'] ?? '',
        phone: json['phone']??'',
        nationalID: json['nationalID'] ?? ''
        );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone']??'',
      nationalID: json['nationalID'] ?? ''
    );
  }
}





