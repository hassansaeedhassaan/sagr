import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/page_model.dart';

abstract class PageRepository {
  Future<Either<Failure, PageModel>> getPage(String slug);
}
