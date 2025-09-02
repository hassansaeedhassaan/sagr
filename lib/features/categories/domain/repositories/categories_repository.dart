import 'package:dartz/dartz.dart';
import 'package:sagr/features/categories/data/models/category_model.dart';
import 'package:sagr/models/pagination_filter.dart';

import '../../../../core/error/failures.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<CategoryModel>>> getParentCategories(PaginationFilter filter);
  Future<Either<Failure, List<CategoryModel>>> getSubChilds(PaginationFilter filter, categoryId);
}
