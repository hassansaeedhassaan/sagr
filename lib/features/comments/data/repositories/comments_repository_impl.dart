import 'package:dio/src/response.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/comments/data/datasources/comment_data_source.dart';
import 'package:sagr/features/comments/data/models/comment_model.dart';
import '../../domain/repositories/comments_repository.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final CommentDataSource commentDataSource;

  CommentsRepositoryImpl(this.commentDataSource);

  @override
  Future<Either<Failure, List<CommentModel>>> getComments(filter) async {
    try {
      final productsData = await commentDataSource.getComments(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> createComment(
      Map<String, dynamic> body) async {
    try {
      final productsData = await commentDataSource.createComment(body);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> updateComment(
      Map<String, dynamic> body) async {
    try {
      final productsData = await commentDataSource.updateComment(body);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, Response>> delete(int adId, int commentId) async {
    try {
      final productsData = await commentDataSource.delete(adId, commentId);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }


}
