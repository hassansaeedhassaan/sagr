import 'package:equatable/equatable.dart';

class AdUser extends Equatable {
  final int? id;
  final String name;
  final String? image;

  AdUser({
    required this.id,
    required this.name, 
    this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}
