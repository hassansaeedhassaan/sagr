import 'package:dartz/dartz.dart';
import 'package:sagr/features/countries/data/models/country_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

abstract class CountriesRepository {
  Future<Either<Failure, List<CountryModel>>> getCountries(PaginationFilter filter);
}
