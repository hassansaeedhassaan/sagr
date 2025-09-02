import 'package:dartz/dartz.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/features/categories/domain/repositories/categories_repository.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

class CategoriesUsecase {
  
  CategoriesRepository categoriesRepository;
  
  CategoriesUsecase(this.categoriesRepository);

  Future<Either<Failure, List<CategoryModel>>> call(
      PaginationFilter filter) async {
    return await categoriesRepository.getParentCategories(filter);
  }


  Future<Either<Failure, List<CategoryModel>>> getSubChilds(
      PaginationFilter filter, categoryId) async {
    return await categoriesRepository.getSubChilds(filter, categoryId);
  }
}
