import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../models/pagination_filter.dart';
import '../../data/models/event_model.dart';
import '../../domain/usecases/get_events.dart';

/// Controller for the standalone "All Events" screen.
///
/// Kept separate from [EventsController] (the shared home singleton) so its
/// filter + pagination state never collides with the home feed. Provides clean
/// page-based infinite scroll and duration/job filtering.
class AllEventsController extends GetxController {
  final EventsUsecase eventsUsecase;

  /// Preset filters applied on first load. Lets the same controller power the
  /// All / My / Previous event lists.
  final String initialType;
  final String initialDuration;

  AllEventsController(
    this.eventsUsecase, {
    this.initialType = 'all',
    this.initialDuration = '',
  });

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final List<EventModel> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;

  /// Filters. [duration]: '' = upcoming, 'previous' = finished.
  /// [job]: null = all jobs. [type]: 'all' | 'my-events'.
  String duration = '';
  int? job;
  String type = 'all';

  int _page = 1;
  static const int _limit = 10;

  List<EventModel> get events => _items;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  @override
  void onInit() {
    super.onInit();
    type = initialType;
    duration = initialDuration;
    fetchFirstPage();
  }

  PaginationFilter _filter() {
    final f = PaginationFilter()
      ..page = _page
      ..limit = _limit
      ..eventType = type
      ..job = job;
    f.eventDuration = duration.isEmpty ? null : duration;
    return f;
  }

  Future<void> fetchFirstPage() async {
    _isLoading = true;
    _page = 1;
    _hasMore = true;
    _items.clear();
    update();

    final res = await eventsUsecase(_filter());
    res.fold((failure) {
      _isLoading = false;
      update();
    }, (data) {
      _items.addAll(data);
      _hasMore = data.length >= _limit;
      _isLoading = false;
      update();
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore) {
      refreshController.loadNoData();
      return;
    }
    _page += 1;

    final res = await eventsUsecase(_filter());
    res.fold((failure) {
      _page -= 1;
      refreshController.loadFailed();
    }, (data) {
      if (data.isEmpty) {
        _hasMore = false;
        refreshController.loadNoData();
      } else {
        _items.addAll(data);
        if (data.length < _limit) _hasMore = false;
        refreshController.loadComplete();
      }
      update();
    });
  }

  Future<void> onRefresh() async {
    await fetchFirstPage();
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  void setDuration(String value) {
    if (duration == value) return;
    duration = value;
    refreshController.resetNoData();
    fetchFirstPage();
  }

  void setJob(int? jobId) {
    if (job == jobId) return;
    job = jobId;
    refreshController.resetNoData();
    fetchFirstPage();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
