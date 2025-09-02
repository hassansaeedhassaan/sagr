import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:sagr/features/pages/data/models/page_model.dart';
import '../../domain/repositories/pages_repository.dart';
import '../datasource/pages_data_source.dart';

class PagesRepositoryImpl implements PageRepository {
  
  final PagesDataSource pagesDataSource;
  
  PagesRepositoryImpl(this.pagesDataSource);

  @override
  Future<Either<Failure, PageModel>> getPage(slug) async {
    try {
      final productsData = await pagesDataSource.getPage(slug);
      return Right(productsData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }


  


}
 