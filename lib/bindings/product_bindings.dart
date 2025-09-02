import 'package:get/get.dart';
import '../features/comments/data/datasources/comment_data_source.dart';
import '../features/comments/data/repositories/comments_repository_impl.dart';
import '../features/comments/domain/usecases/get_comments_ads.dart';

class ProductBindings implements Bindings {
  @override
  void dependencies() {
   
    Get.lazyPut(() => CommentDataSourceImpl(dio: Get.find()));
    Get.lazyPut(
        () => CommentsRepositoryImpl(Get.find<CommentDataSourceImpl>()));
    Get.put(CommentsUsecase(Get.find<CommentsRepositoryImpl>()),
        permanent: true);

  }
}
