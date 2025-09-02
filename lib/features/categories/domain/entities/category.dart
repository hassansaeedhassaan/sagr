import 'package:equatable/equatable.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';

class Category extends Equatable {
  final int? id;
  final String? name;
  final String? image;
  final List<CategoryModel> ? childs;


  Category({
    required this.id,
    required this.name,
    this.image,
    this.childs

  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
 childs
      ];
}
