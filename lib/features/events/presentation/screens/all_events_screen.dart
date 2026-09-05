import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/all_events_controller.dart';
import '../widgets/event_list_view.dart';

/// All upcoming/finished events with duration + job filters and infinite scroll.
class AllEventsScreen extends StatelessWidget {
  static const _tag = 'allEvents';

  AllEventsScreen({super.key}) {
    Get.put(AllEventsController(Get.find()), tag: _tag);
  }

  @override
  Widget build(BuildContext context) {
    return const EventListView(
      tag: _tag,
      title: 'جميع الفعاليات',
      showDurationFilter: true,
      showJobFilter: true,
      emptyTitle: 'No Results Found for Future Events',
    );
  }
}
