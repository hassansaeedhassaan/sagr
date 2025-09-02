import 'package:dio/src/response.dart';
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/cards/data/models/card_model.dart';
import 'package:sagr/features/cards/domain/repositories/card_repository.dart';
import '../datasource/card_data_source.dart';

class CardRepositoryImpl implements CardRepository {
  final CardDataSource cardDataSource;

  CardRepositoryImpl(this.cardDataSource);

  @override
  Future<Either<Failure, List<CardModel>>> getCards(filter) async {
    try {
      final productsData = await cardDataSource.getCards(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> addCard(
      String paymentMethodId) async {
    try {
      final productsData =
          await cardDataSource.addCard(paymentMethodId);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    } on NotFoundException catch (e) {
      
      return Left(NotFoundFailure(data: e.data));
    }on ValidationException catch(e){
         return Left(NotFoundFailure(data: e.data));
    }
  }
  



}
