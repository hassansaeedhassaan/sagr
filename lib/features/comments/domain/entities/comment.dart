import 'package:equatable/equatable.dart';
import 'package:sagr/features/products/data/models/ad_user_model.dart';
import '../../data/models/comment_model.dart';

class Comment extends Equatable {
  final int? id;
  String? comment;
  final String? created_at;
  final AdUserModel? user;
  final List<CommentModel>? childs;
  

  Comment(
      {
      required this.id,
      required this.comment,
      this.user,
      this.created_at,
      this.childs
      });

  @override
  List<Object?> get props => [
        id,
        comment,
        created_at,
        user,
        childs
      ];
}
