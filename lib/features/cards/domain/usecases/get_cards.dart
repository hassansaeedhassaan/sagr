import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/cards/data/models/card_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../repositories/card_repository.dart';

class CardUsecase {
  
  CardRepository cardRepository;
  
  CardUsecase(this.cardRepository);

  // Get List Of Cards For Current User.
  Future<Either<Failure, List<CardModel>>> call(
      PaginationFilter filter) async {
    return await cardRepository.getCards(filter);
  }


  // Add Card By paymentMethodId Only For Current User.
  Future<Either<Failure, Response>> addCard(
      String paymentMethodId) async {
    return await cardRepository.addCard(paymentMethodId);
  }

}
