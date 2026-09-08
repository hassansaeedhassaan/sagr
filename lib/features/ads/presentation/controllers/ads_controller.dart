import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../models/pagination_filter.dart';
import '../../data/models/ad_model.dart';
import '../../domain/usecases/get_ads.dart';

class AdsController extends GetxController {
  // MaritalStatusUsecase instance
  final AdsUsecase eventsUsecase;

  // MaritalStatusController Constructor
  AdsController(this.eventsUsecase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  AdModel? ad;

  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;

  final _items = <AdModel>[].obs;

  final ScrollController scrollController =
      ScrollController(); // ScrollController

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;

  List<AdModel> get ads => _items.toList();

  /// Rx Filters  Setter
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;

  /// Bumped per fetch; a response carrying a stale token is discarded rather
  /// than appended on top of a newer list.
  int _requestToken = 0;

  /// Blocks overlapping fetches. Set before the await — [_isLoading] used to be
  /// set only inside the response handler, far too late to stop a second load.
  bool _fetching = false;

  /// Surfaced by the screen so a failed first page can offer a retry.
  final RxnString _loadError = RxnString();

  String? get loadError => _loadError.value;

  /// Rx Filters  Getter
  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;
  bool get lastPage => _lastPage.value;
  bool get hasMore => _hasMore.value;

  @override
  void onInit() {
    super.onInit();

    ever(_paginationFilter, (_) => _findItems());
    _changePaginationFilter(1, 5);
    //  scrollController.addListener(_scrollListener); // Listen to scroll events

    // getEventDetails();
  }

  void _changePaginationFilter(int page, int limit) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
    });
  }

  Future<void> _findItems() async {
    if (_fetching) return;
    _fetching = true;

    final token = ++_requestToken;
    final requestedPage = _paginationFilter.value.page;

    _isLoading.value = true;
    if (requestedPage <= 1) _loadError.value = null;

    final failureOrAds = await eventsUsecase(_paginationFilter.value);

    _fetching = false;
    if (token != _requestToken) return;

    failureOrAds.fold((failure) {
      if (requestedPage <= 1) {
        _loadError.value = failure.message;
      } else {
        _hasMore.value = false;
      }
      _isLoading.value = false;
      update();
    }, (receivedAds) {
      // Page 1 is a fresh list (first load or refresh), never an append.
      if (requestedPage <= 1) _items.clear();

      _appendUnique(receivedAds);

      _hasMore.value = receivedAds.length >= _paginationFilter.value.limit;
      _lastPage.value = !_hasMore.value;
      _isLoading.value = false;
      update();
    });
  }

  /// Appends only ads not already listed, so an overlapping server window can't
  /// render the same ad twice.
  void _appendUnique(List<AdModel> incoming) {
    final seen = _items.map((e) => e.id).toSet();
    for (final ad in incoming) {
      if (ad.id == null || seen.add(ad.id)) _items.add(ad);
    }
  }

  Future<void> retry() => _findItems();

  nextPage() {
    if (_hasMore.isFalse || _fetching) return;
    _changePaginationFilter(page + 1, limit);
  }

  void onLoading() async {
    if (!_hasMore.value) {
      refreshController.loadNoData();
      return;
    }
    if (_fetching) {
      refreshController.loadComplete();
      return;
    }
    nextPage();
    refreshController.loadComplete();
  }

  void onRefresh() async {
    _hasMore.value = true;
    _lastPage.value = false;
    // Page 1 replaces the list; refreshing used to re-fetch the current page
    // and append it again.
    if (page == 1) {
      await _findItems();
    } else {
      _changePaginationFilter(1, limit);
    }
    refreshController.refreshCompleted();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
