import 'package:dartz/dartz.dart';
import 'package:sagr/features/pages/data/models/page_model.dart';

import '../../../../core/error/failures.dart';
import '../repositories/pages_repository.dart';

class PagesUsecase {
  
  PageRepository pageRepository;
  
  PagesUsecase(this.pageRepository);

  Future<Either<Failure, PageModel>> call(
      String slug) async {
    return await pageRepository.getPage(slug);
  }


}
