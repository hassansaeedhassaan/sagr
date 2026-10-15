import 'package:sagr/features/notifications/live/live_notifications.dart';
import 'package:dio/dio.dart' show Dio, Options;
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:sagr/features/notifications/data/models/notification_model.dart';
import 'package:sagr/features/events/presentation/widgets/event_status_pill.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../models/pagination_filter.dart';
import '../../domain/usecases/get_commissions.dart';

class NotificationsController extends GetxController {
  final NotificationsUsecase notificationsUsecase;

  NotificationsController(this.notificationsUsecase);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final _paginationFilter = PaginationFilter().obs;
  final RxBool _hasMore = true.obs;
  final RxBool _isLoadingList = false.obs;

  /// Surfaced by the screen so a failed first page can offer a retry.
  final RxnString _loadError = RxnString();

  bool _fetching = false;
  int _requestToken = 0;

  int get limit => _paginationFilter.value.limit;
  int get page => _paginationFilter.value.page;
  bool get hasMore => _hasMore.value;
  bool get isLoadingList => _isLoadingList.value;
  String? get loadError => _loadError.value;

  final _items = <NotificationModel>[].obs;

  List<NotificationModel> get notifications => _items.toList();

  int get unreadCount => _items.where((n) => n.is_read != true).length;

  Worker? _liveWorker;

  @override
  void onInit() {
    super.onInit();
    ever(_paginationFilter, (_) => _findItems());
    _changePaginationFilter(1, 20);

    // A notification that arrives live goes straight to the top.
    _liveWorker = ever<NotificationModel?>(LiveNotifications.to.latest, (n) {
      if (n == null || (n.id != null && _items.any((e) => e.id == n.id))) return;
      _items.insert(0, n);
      update();
    });
  }

  @override
  void onClose() {
    _liveWorker?.dispose();
    refreshController.dispose();
    super.onClose();
  }

  Future<void> _findItems() async {
    if (_fetching) return;
    _fetching = true;

    final token = ++_requestToken;
    final requestedPage = page;

    _isLoadingList.value = true;
    if (requestedPage <= 1) _loadError.value = null;
    update();

    final result = await notificationsUsecase(_paginationFilter.value);

    _fetching = false;
    if (token != _requestToken) return;

    result.fold((failure) {
      if (requestedPage <= 1) {
        _loadError.value = failure.message;
      } else {
        _hasMore.value = false;
      }
    }, (received) {
      // Page 1 is a fresh list (first load or refresh), never an append.
      if (requestedPage <= 1) _items.clear();

      final seen = _items.map((e) => e.id).toSet();
      for (final n in received) {
        if (n.id == null || seen.add(n.id)) _items.add(n);
      }

      _hasMore.value = received.length >= limit;
    });

    _isLoadingList.value = false;
    update();
  }

  void _changePaginationFilter(int page, int limit) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
      val?.name = '';
    });
  }

  Future<void> retry() => _findItems();

  Future<void> onRefresh() async {
    _hasMore.value = true;
    if (page == 1) {
      await _findItems();
    } else {
      _changePaginationFilter(1, limit);
    }
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  void nextPage() {
    if (_hasMore.isFalse || _fetching) return;
    _changePaginationFilter(page + 1, limit);
  }

  void onLoading() {
    nextPage();
    if (_hasMore.isFalse) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
  }

  /// Tap: mark it read (optimistically) and open what it points at.
  void open(NotificationModel notification) {
    if (notification.is_read != true) {
      _setRead((n) => n.id == notification.id);
      _post('/notifications/${notification.id}/read');
    }

    final eventId = notification.eventId;
    if (eventId != null) openEventByStatus(eventId, null);
  }

  void markAllRead() {
    if (unreadCount == 0) return;
    _setRead((_) => true);
    _post('/notifications/read-all');
  }

  void _setRead(bool Function(NotificationModel) test) {
    var marked = 0;
    for (var i = 0; i < _items.length; i++) {
      final n = _items[i];
      if (n.is_read != true && test(n)) {
        _items[i] = n.copyWith(is_read: true);
        marked++;
      }
    }
    if (marked > 0) {
      final live = LiveNotifications.to;
      live.setUnread(live.unread.value - marked);
    }
    update();
  }

  /// Best effort: the list already shows it read; next refresh re-syncs.
  Future<void> _post(String path) async {
    // No Dio is registered with GetX, so this used to return before sending.
    final token = GetStorage().read('access_token');
    if (token == null) return;
    try {
      final response = await Dio().post(
        '$BASEURL$path',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        }),
      );
      final count = response.data is Map ? response.data['unread_count'] : null;
      if (count is num) LiveNotifications.to.setUnread(count.toInt());
    } catch (_) {}
  }
}

class ErrorMessage {
  final int? code;
  final String? error;

  const ErrorMessage({
    this.code,
    this.error,
  });

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(code: json['code'], error: json['error']);
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'error': error,
    };
  }
}
