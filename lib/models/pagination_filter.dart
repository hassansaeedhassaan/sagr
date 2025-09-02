
class PaginationFilter {
  late int page;
  late int limit;
  String? name;
  String? eventType;
  String? eventDuration;
  int? category_id;
  int? is_negotiable;
  int? country_id;
  bool? available_photo;
  bool? nearBy;
  double? lat;
  double? long;
  int? job;

  String? created_at;


  @override
  String toString() => 'PaginationFilter(page: $page, limit: $limit, eventType: $eventType, eventDuration: $eventDuration, Job: $job)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PaginationFilter && o.page == page && o.limit == limit;
  }

  @override
  int get hashCode => page.hashCode ^ limit.hashCode ^ category_id.hashCode ^ is_negotiable.hashCode ^ country_id.hashCode ^ available_photo.hashCode ^ nearBy.hashCode ^ lat.hashCode ^ long.hashCode ^ created_at.hashCode ^ eventDuration.hashCode;
}
