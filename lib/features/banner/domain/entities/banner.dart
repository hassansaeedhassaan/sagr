import 'package:equatable/equatable.dart';

class Banner extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? image_path;
  final String? link;

  Banner({this.id, this.title, this.description, this.image_path, this.link});

  @override
  List<Object?> get props => [id, title, description, image_path, link];
}
