
import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    int? id,
    String? name,
    String? image,
    List<CategoryModel>? childs
  }) : super(
          id: id,
          name: name,
          image: image,
          childs: childs
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {


    List<CategoryModel> childs = [];
      if (json['child'] != null) {
      json['child'].forEach((child) {
        childs.add(CategoryModel.fromJson(child));
      });
    }
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'] ?? "",
      childs: childs
     
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'childs':childs };
  }



}
