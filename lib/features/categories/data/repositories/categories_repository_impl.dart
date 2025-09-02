import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/categories/domain/repositories/categories_repository.dart';
import 'package:sagr/models/pagination_filter.dart';
import '../datasource/featured_ads_data_source.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  
  final CategoriesDataSource categoriesDataSource;
  
  CategoriesRepositoryImpl(this.categoriesDataSource);

  @override
  Future<Either<Failure, List<CategoryModel>>> getParentCategories(filter) async {
    try {
      final productsData = await categoriesDataSource.getParentCategories(filter);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getSubChilds(PaginationFilter filter, categoryId) async {
   try {
      final productsData = await categoriesDataSource.getSubChilds(filter, categoryId);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

}
 