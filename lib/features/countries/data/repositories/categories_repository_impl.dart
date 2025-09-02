import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/countries/data/models/country_model.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasource/country_data_source.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  
  final CountriesDataSource countriesDataSource;
  
  CountriesRepositoryImpl(this.countriesDataSource);

  @override
  Future<Either<Failure, List<CountryModel>>> getCountries(filter) async {
    try {
      final productsData = await countriesDataSource.getCountries(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  


 

}
 