import '../../domain/entities/page.dart';

class PageModel extends Page {
  PageModel({
    int? id,
    String? title,
    String? content,
  }) : super(
          id: id,
          title: title,
          content: content,
        );
  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id,'title': title, 'content': content};
  }
}
