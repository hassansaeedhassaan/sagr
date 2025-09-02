import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/comment_model.dart';

abstract class CommentsRepository {
  Future<Either<Failure, List<CommentModel>>> getComments(PaginationFilter filter);

  Future<Either<Failure, Response>> createComment(Map<String, dynamic> body);
  
  Future<Either<Failure, Response>> updateComment(Map<String, dynamic> body);

  Future<Either<Failure, Response>> delete(int adId, int commentId);
  
}
