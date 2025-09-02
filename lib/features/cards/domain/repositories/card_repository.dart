import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/cards/data/models/card_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

abstract class CardRepository {
  Future<Either<Failure, List<CardModel>>> getCards(PaginationFilter filter);
  Future<Either<Failure, Response>> addCard(String paymentMethodId);
}
