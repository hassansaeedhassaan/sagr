import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sagr/features/evocations/data/models/evocation_model.dart';
import 'package:sagr/features/jobs/data/models/job_model.dart';
import 'package:sagr/widgets/messages.dart';
import '../../../../models/pagination_filter.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../domain/usecases/get_events.dart';

class EvocationsController extends GetxController {
  // MaritalStatusUsecase instance
  final EvocationsUsecase evocationsUsecase;

  // MaritalStatusController Constructor
  EvocationsController(this.evocationsUsecase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);


  // EventController eventController = Get.put(EventController(Get.find()));


  // Rx Filters  Setter
  final RxBool _isLoading = true.obs;

  final _items = <EvocationModel>[].obs;

  final ScrollController scrollController =
      ScrollController(); // ScrollController

  // Rx Filters  Getter
  bool get isLoading => _isLoading.value;

  List<EvocationModel> get events => _items.toList();

  /// Rx Filters  Setter
  final _paginationFilter = PaginationFilter().obs;
  final RxBool _lastPage = false.obs;
  final RxBool _hasMore = true.obs;

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
    // if (Get.arguments != '') {
    //   final Map<String, dynamic> data = Get.arguments ?? {};

    //   final String finishedEvents = data['ed'] ?? '';

    //   final String myEvents = data['es'] ?? '';

    //   if (finishedEvents != '') {
    //     _paginationFilter.value.eventDuration = finishedEvents;
    //   }

    //   if (myEvents != '') {
    //     _paginationFilter.value.eventType = myEvents;
    //   }

    // }

    // Call Marital Status Usecase.
    final failureOrMaritalStatus = await evocationsUsecase(_paginationFilter.value);

    failureOrMaritalStatus.fold((failure) {
      // Set Loading Attr False Initially.
      _isLoading.value = false;

    }, (receivedEventsData) {

      // Avoid duplicate calls
      if (_isLoading.value && !_hasMore.value) return;

      // Set Loading Attr True.
      _isLoading.value = true;

      if (receivedEventsData.isNotEmpty) {
        _items.addAll(receivedEventsData);
      } else {

        // No more data
        _hasMore.value = false;
      }
      // Set Loading Attr False.
      _isLoading.value = false;

      update();
    });
  }



Future<void> apply (EvocationModel evocation) async{


  final Map<String, dynamic> body = {
      // 'event_id': eventController.event?.id,
      // 'zone_id': eventController.event?.zone_id,
      // 'user_id': eventController.event?.user_id,
      'notes': evocation.notes,
      'duration': evocation.duration,
      'type': evocation.type == EvocationType.prayer ? 'prayer': 'food'
    };

     final failureOrEvent = await evocationsUsecase.apply(body);

    failureOrEvent.fold((failure) {
      _isLoading.value = false;
    }, (receivedProduct) async {
      _isLoading.value = false;


      Future.delayed(Duration(seconds: 2));

     
     MessageHelper.showSuccessSnackbar(title: "DONE", message: "DONE DONE DONE");


     
    });


}



  Future<void> filterEventsByJob(JobModel job) async {
    if (job.id == null) {
      throw ArgumentError('Job ID cannot be null or empty');
    }

    try {
      // Reset state atomically
      await _resetFilterState();

      // Set loading state
      _setLoadingState(isLoading: true, hasMore: true, isLastPage: false);

      // Add artificial delay if needed (consider removing in production)
      if (kDebugMode) {
        await Future.delayed(const Duration(seconds: 2));
      }

      // Update pagination filter & Fetch filtered items
      _updatePaginationFilter(job.id!);

      // SUCCESS_MESSAGE
      //  MessageHelper.showSuccessSnackbar(
      //             title: 'تم بنجاح',
      //             message: 'تم إرسال الرسالة بنجاح',
      //             onTap: () {
      //               print('تم الضغط على الرسالة');
      //             },
      //           );
    } catch (error) {
      _handleFilterError(error);
    } finally {
      _setLoadingState(isLoading: false);
    }
  }

  /// Resets the filter state by clearing items and updating UI
  Future<void> _resetFilterState() async {
    _items.clear();
    update();
  }

  // Updates the pagination filter with the new job ID
  void _updatePaginationFilter(int jobId) {
    _paginationFilter.update((filter) {
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

  /// Handles errors during the filtering process
  void _handleFilterError(dynamic error) {
    // Log error for debugging
    debugPrint('Error filtering events by job: $error');

    // Reset loading state
    _setLoadingState(isLoading: false, hasMore: false);

    // Optionally show user-friendly error message
    // You might want to show a snackbar or dialog here
    _showErrorToUser('Failed to filter events. Please try again.');
  }

  /// Shows error message to user (implement based on your UI framework)
  void _showErrorToUser(String message) {
    // Implementation depends on your UI framework
    // For example, using Get.snackbar() if using GetX
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  nextPage() {
    if (_hasMore.isFalse) return;
    _changePaginationFilter(page + 1, limit);
    update();
  }

  void onLoading() async {
    print(_paginationFilter.value);
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    nextPage();
    refreshController.loadComplete();
    update();
  }

  void onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // _items.clear();
    _findItems();
    refreshController.refreshCompleted();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
