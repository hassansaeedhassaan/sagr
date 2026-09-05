import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/all_events_controller.dart';
import '../widgets/event_list_view.dart';

/// Previous (finished) events. Reuses the shared list scaffold with duration
/// preset to `previous`; the duration toggle is hidden since it is fixed.
class PreviousEventsScreen extends StatelessWidget {
  static const _tag = 'prevEvents';

  PreviousEventsScreen({super.key}) {
    Get.put(
      AllEventsController(Get.find(), initialDuration: 'previous'),
      tag: _tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const EventListView(
      tag: _tag,
      title: 'الفعاليات السابقة',
      showDurationFilter: false,
      showJobFilter: true,
      emptyTitle: 'No events found',
    );
  }
}
