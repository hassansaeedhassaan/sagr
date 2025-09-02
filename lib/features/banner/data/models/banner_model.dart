import '../../domain/entities/banner.dart';

class BannerModel extends Banner {
  BannerModel(
      {
      int? id,
      String? title,
      String? description,
      String? image_path,
      String? link

      })
      : super(
            id: id,
            title: title,
            description: description,
            image_path: image_path,
            link: link
            );

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        image_path: json['image_path'],
        link: json['link']
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_path': image_path,
      'link': link
    };
  }
}
