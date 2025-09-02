import 'package:dartz/dartz.dart';
import 'package:sagr/features/countries/data/models/country_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';
import '../repositories/countries_repository.dart';

class CountriesUsecase {
  
  CountriesRepository countriesRepository;
  
  CountriesUsecase(this.countriesRepository);

  Future<Either<Failure, List<CountryModel>>> call(
      PaginationFilter filter) async {
    return await countriesRepository.getCountries(filter);

  // Future<Either<Failure, List<CategoryModel>>> getSubChilds(
  //     PaginationFilter filter, categoryId) async {
  //   return await categoriesRepository.getSubChilds(filter, categoryId);
  // }
}
}