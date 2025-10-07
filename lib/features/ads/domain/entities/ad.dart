import 'package:equatable/equatable.dart';

class Ad extends Equatable {
  
  final int? id;

  final String? name;

  final String? address;

  final String? description;

  final String? logo;
  
  final String? datetime;

  final String? date;
  
  final String? time;

  final String? ago;

  final String? preparing;

  final List? periods;

  final String? appliedStatus;
  final String? nationalID;

  const Ad({required this.id,this.name, this.description, this.logo,this.datetime, this.date, this.time, this.preparing, this.address, this.ago, this.periods, this.appliedStatus = 'undefined', this.nationalID = ''});

  @override
  List<Object?> get props => [id,name,description, logo,datetime,preparing, address, ago, date,time, periods, appliedStatus];

  // Optional: Add copyWith for immutability and easy updates
  Ad copyWith({
    int? id,
    String? name,
    String? address,
    String? description,
    String? logo,
    String? datetime,
    String? date,
    String? time,
    String? ago,
    String? preparing,
    List? periods,
    String? appliedStatus,
    String? nationalID
  }) {
    return Ad(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description??this.description,
      logo: logo??this.logo,
      datetime: datetime??this.datetime,
      date: date??this.date,
      time: time??this.time,
      ago: ago??this.ago,
      preparing: preparing??this.preparing,
      periods: periods?? this.periods,
      appliedStatus: appliedStatus?? this.appliedStatus,
      nationalID: nationalID?? this.nationalID,
    );
  }

  // Optional: Add factory constructor for JSON parsing
  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      logo: json['logo'],
      datetime: json['datetime'],
      date: json['date'],
      time: json['time'],
      ago: json['ago'],
      preparing: json['preparing'],
      appliedStatus: json['appliedStatus'] ?? 'undefined',
      nationalID: json['nationalID'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'logo': logo,
      'datetime': datetime,
      'date': date,
      'time': time,
      'ago': ago,
      'preparing': preparing,
      'appliedStatus': appliedStatus,
      'nationalID': nationalID
    };
  }
}