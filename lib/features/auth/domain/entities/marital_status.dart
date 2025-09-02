import 'package:equatable/equatable.dart';

class MaritalStatus extends Equatable {
  final int? id;
  final String? name;


  const MaritalStatus({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
