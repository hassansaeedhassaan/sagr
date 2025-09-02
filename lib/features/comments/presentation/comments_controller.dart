
import 'package:sagr/core/error/exceptions.dart';
import 'package:sagr/features/comments/data/models/comment_model.dart';
import 'package:sagr/features/comments/domain/usecases/get_comments_ads.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';

class CommentsController extends GetxController {
  final CommentsUsecase commentsUsecase;

  CommentsController(this.commentsUsecase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

/**
 * Rx Filters  Setter
 */
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;

  final RxInt _updatedComment = 0.obs;

  String? replay;

  /**
 * Rx Filters  Getter
 */
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;

  int get updatedComment => _updatedComment.value;

  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;

  /**
   * List of products 
   * @Setter
   */
  final _items = <CommentModel>[].obs;

  /**
   * List of products 
   * @ Getter
   */
  List<CommentModel> get comments => _items.toList();

  /**
   * Products Loading 
   * @Setter
   */
  RxBool _productsLoading = false.obs;

  /**
   * List of products 
   * @ Getter
   */
  bool get productsLoading => _productsLoading.value;

  @override
  void onInit() {
    super.onInit();
    ever(_paginationFilter, (_) => _findItems());
    _changePaginationFilter(1, 100, '');
  }

  Future<void> delete(CommentModel comment, int adId) async {
    _productsLoading.value = true;

    // final failureOrComments = await commentsUsecase(_paginationFilter.value);

    print("👏👏👏👏👏👏👏👏👏👏👏");

    print(comment);
    print(adId);

    try {
      // // Map<String, dynamic> body = {'parent': comment.id, 'comment': replay};
      final failureOrDeleteComment =
          await commentsUsecase.delete(adId, comment.id!);

      failureOrDeleteComment.fold((failure) {
        _productsLoading.value = false;
      }, (receivedResponse) {
        if (receivedResponse.data['code'] == 200) {
          Get.snackbar("Delete", "Comment has been delete successfully.");
        }
        _items.value = [];
        _findItems();
        _productsLoading.value = false;
        update();
      });
    } on ServerExceptionFailure catch (e) {
      Get.snackbar("Error!", e.data['error']);
    } catch (e) {
      print(e);
      Get.snackbar("Error!", 'wrong'.tr);
    }
  }

  Future<void> setForEdit(commentId) async {
    _updatedComment.value = commentId;
    update();
  }

  Future<void> updateComment(adId) async {
    print("👏👏👏👏👏👏👏👏👏👏👏");

    print(replay);
    print(updatedComment);
    print(adId);

    Map<String, dynamic> body = {
      'commentId': updatedComment,
      'comment': replay,
      'adId': adId
    };
    final failureOrUpdateComment = await commentsUsecase.updateComment(body);

    Future.delayed(Duration(microseconds: 1000)).then((value) {
      comments.map((cm) {
        cm.childs!.map((child) {
          if (child.id!.toInt() == updatedComment.toInt()) {
            child.comment = replay;
          }
        }).toList();
      }).toList();

      _updatedComment.value = 0;
      update();
    });
  }

  Future<void> storeComment(CommentModel comment) async {
    _productsLoading.value = true;

    // final failureOrComments = await commentsUsecase(_paginationFilter.value);

    print("👏👏👏👏👏👏👏👏👏👏👏");

    Map<String, dynamic> body = {'parent': comment.id, 'comment': replay};
    final failureOrCreateComment = await commentsUsecase.createComment(body);

    _findItems();
    print("👏👏👏👏👏👏👏👏👏👏👏");
    update();
  }

  Future<void> _findItems() async {
    _productsLoading.value = true;

    final failureOrComments = await commentsUsecase(_paginationFilter.value);

    failureOrComments.fold((failure) {
      _productsLoading.value = false;
    }, (receivedProducts) {
      print("👏👏👏👏👏👏👏👏👏👏👏START");
      print(receivedProducts);
      print("👏👏👏👏👏👏👏👏👏👏👏");
      if (receivedProducts.isEmpty) {
        _hasMore.value = false;
      }

      if (receivedProducts.isNotEmpty) {
        _items.addAll(receivedProducts);
      }

      _productsLoading.value = false;
      update();
    });
  }

  void _changePaginationFilter(int page, int limit, String? name) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
      val?.name = "";
      // val?.is_negotiable = isNegotiable;
    });
  }

  void onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // _items.clear();
    _findItems();
    refreshController.refreshCompleted();
  }

  nextPage() {
    if (_hasMore.isFalse) return;
    _changePaginationFilter(page + 1, limit, '');
    update();
  }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    nextPage();
    refreshController.loadComplete();
    update();
  }
}
