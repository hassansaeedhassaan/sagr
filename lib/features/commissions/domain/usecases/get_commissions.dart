import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/commissions/data/models/commission_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../repositories/commissions_repository.dart';

class CommissionsUsecase {
  
  CommissionsRepository commissionsRepository;
  
  CommissionsUsecase(this.commissionsRepository);

  Future<Either<Failure, List<CommissionModel>>> call(
      PaginationFilter filter) async {
    return await commissionsRepository.getCommissions(filter);
  }

  Future<Either<Failure, Response>> payAllCommissions(
      String paymentMethod) async {
    return await commissionsRepository.payAllCommissions(paymentMethod);
  }

}
