import 'package:equatable/equatable.dart';

class Nationality extends Equatable {
  final int? id;
  final String? name;

  const Nationality({
    this.id, // Remove 'required' since it's nullable
    this.name,
  });

  @override
  List<Object?> get props => [id, name];

  Nationality copyWith({
    int? id,
    String? name,
  }) {
    return Nationality(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}