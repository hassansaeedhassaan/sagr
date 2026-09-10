import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../models/pagination_filter.dart';
import '../../data/models/event_model.dart';
import '../../domain/usecases/get_events.dart';

class EventsController extends GetxController {
  // MaritalStatusUsecase instance
  final EventsUsecase eventsUsecase;

  // MaritalStatusController Constructor
  EventsController(this.eventsUsecase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  EventModel? event;

  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;

  final _items = <EventModel>[].obs;

  final ScrollController scrollController =
      ScrollController(); // ScrollController

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;

  List<EventModel> get events => _items.toList();

  /// Rx Filters  Setter
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;

  /// Bumped on every fetch. A response whose token no longer matches belongs to
  /// a filter/page the user has already moved off, so it is dropped instead of
  /// being appended on top of the newer list — that race is what made events
  /// show up twice after switching job filters.
  int _requestToken = 0;

  /// Guards against two overlapping fetches appending the same page. [_isLoading]
  /// can't do this on its own: it used to be set inside the response handler,
  /// long after a second scroll had already fired.
  bool _fetching = false;

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

  // Scroll listener for pagination
  void _scrollListener() {
    var nextPageTrigger = 0.95 * scrollController.position.maxScrollExtent;
    if (scrollController.position.pixels >= nextPageTrigger &&
        !_isLoading.value &&
        _hasMore.value) {
      Future.delayed(Duration(seconds: 5)).then((value) => {
            _paginationFilter.update((val) {
              val?.page += 1;
            })
          });

      // _findItems();
    }
  }

  // Get List Of Marital Status
  Future<void> _findItems() async {
    if (_fetching) return;
    _fetching = true;

    final token = ++_requestToken;
    final requestedPage = _paginationFilter.value.page;

    _isLoading.value = true;

    if (Get.arguments != '') {
      final Map<String, dynamic> data = Get.arguments ?? {};

      final String finishedEvents = data['ed'] ?? '';

      final String myEvents = data['es'] ?? '';

      if (finishedEvents != '') {
        _paginationFilter.value.eventDuration = finishedEvents;
      }

      if (myEvents != '') {
        _paginationFilter.value.eventType = myEvents;
      }
    }

    final failureOrEvents = await eventsUsecase(_paginationFilter.value);

    _fetching = false;

    // A newer request started while this one was in flight — its results are
    // the ones on screen now, so this response is stale.
    if (token != _requestToken) return;

    failureOrEvents.fold((failure) {
      // Only shout about the first page — a failed background page-load
      // shouldn't throw a snackbar over a list the user is reading.
      if (requestedPage <= 1) {
        _showErrorToUser(failure.message.tr);
      } else {
        _hasMore.value = false;
      }
      _isLoading.value = false;
      update();
    }, (receivedEventsData) {
      // Page 1 is a fresh list (first load, refresh, or a filter change), not
      // something to append to what is already there.
      if (requestedPage <= 1) {
        _items.clear();
      }

      _appendUnique(receivedEventsData);

      // Short page means the server has nothing left to give.
      _hasMore.value = receivedEventsData.length >= _paginationFilter.value.limit;
      _lastPage.value = !_hasMore.value;

      _isLoading.value = false;
      update();
    });
  }

  /// Appends only events not already in the list. Guards against the backend
  /// returning an overlapping window when rows shift between page requests.
  void _appendUnique(List<EventModel> incoming) {
    final seen = _items.map((e) => e.id).toSet();
    for (final event in incoming) {
      if (event.id == null || seen.add(event.id)) {
        _items.add(event);
      }
    }
  }

Future<void> filterEventsByJob(int jobId) async {
  // Only move the filter. The `ever(_paginationFilter)` listener runs the
  // fetch — this method used to *also* call the usecase itself, so every job
  // switch fired two overlapping requests whose results were appended to the
  // same list.
  _setLoadingState(isLoading: true, hasMore: true, isLastPage: false);

  _paginationFilter.update((filter) {
    filter?.page = 1;
    filter?.limit = 10;
    filter?.job = jobId;
  });
}

  void _setLoadingState({
    bool? isLoading,
    bool? hasMore,
    bool? isLastPage,
  }) {
    if (isLoading != null) _isLoading.value = isLoading;
    if (hasMore != null) _hasMore.value = hasMore;
    if (isLastPage != null) _lastPage.value = isLastPage;
    update();
  }


  /// Shows error message to user (implement based on your UI framework)
void _showErrorToUser(String message) {
  Get.snackbar('Error'.tr, message, snackPosition: SnackPosition.BOTTOM);
}

  Future<void> getEventDetails() async {
    print(Get.arguments);
    return Get.arguments;
    final failureOrEvent = await eventsUsecase.getEventDetails(Get.arguments);

    failureOrEvent.fold((failure) {
      _isLoading.value = false;
    }, (receivedEvent) async {
      // receivedProduct.images!
      //     .add({"id": 0, "file": receivedProduct.image, "type": "image"});

      event = receivedEvent;

      print(receivedEvent);

      update();
    });
  }

  nextPage() {
    if (_hasMore.isFalse || _fetching) return;
    _changePaginationFilter(page + 1, limit);
  }

  void onLoading() async {
    if (!_hasMore.value) {
      refreshController.loadNoData();
      return;
    }
    // Don't queue another page on top of one already in flight — a fast scroll
    // used to bump the page twice and append the same rows.
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
    // Go back to page 1 — _findItems replaces the list there. Refreshing used
    // to re-fetch whatever page was current and append it again.
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
