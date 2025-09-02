import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sagr/features/commissions/data/models/commission_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

abstract class CommissionsRepository {
  Future<Either<Failure, List<CommissionModel>>> getCommissions(PaginationFilter filter);
  Future<Either<Failure, Response>> payAllCommissions(String paymentMethod);
}
