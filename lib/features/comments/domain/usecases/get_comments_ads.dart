import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/comments/domain/repositories/comments_repository.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/comment_model.dart';

class CommentsUsecase {
  
  CommentsRepository commentsRepository;
  
  CommentsUsecase(this.commentsRepository);

  Future<Either<Failure, List<CommentModel>>> call(
      PaginationFilter filter) async {
    return await commentsRepository.getComments(filter);
  }

  Future<Either<Failure, Response>> createComment(
      Map<String, dynamic> body) async {
    return await commentsRepository.createComment(body);
  }

    Future<Either<Failure, Response>> updateComment(
      Map<String, dynamic> body) async {
    return await commentsRepository.updateComment(body);
  }


    Future<Either<Failure, Response>> delete(int adId, int commentId) async {
    return await commentsRepository.delete(adId, commentId);
  }

  





}
