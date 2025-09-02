import 'package:sagr/features/comments/domain/entities/comment.dart';
import 'package:sagr/features/products/data/models/ad_user_model.dart';

class CommentModel extends Comment {
  CommentModel({
    int? id,
    required String comment,
    AdUserModel? user,
     List<CommentModel>? childs,
     String? created_at,

  }) : super(
            id: id,
            comment: comment,
            user: user,
            created_at: created_at,
            childs: childs
            );

  factory CommentModel.fromJson(Map<String, dynamic> json) {

   

     List<CommentModel> childs = [];
      if (json['relatedComments'] != null) {
      json['relatedComments'].forEach((child) {
        childs.add(CommentModel.fromJson(child));
      });
    }


    return CommentModel(
        id: json['id'],

        comment: json['comment'],
  
        created_at: json['created_at'] ?? "",
       
        user: AdUserModel.fromJson(json['user']),
        
        childs: childs);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'comment': comment, 'child': childs};
  }
}
