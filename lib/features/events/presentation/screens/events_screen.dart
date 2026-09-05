import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/all_events_controller.dart';
import '../widgets/event_list_view.dart';

/// "My Events" — events the current user applied to. Reuses the shared list
/// scaffold with the type preset to `my-events`.
class EventsScreen extends StatelessWidget {
  static const _tag = 'myEvents';

  EventsScreen({super.key}) {
    Get.put(
      AllEventsController(Get.find(), initialType: 'my-events'),
      tag: _tag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const EventListView(
      tag: _tag,
      title: 'فعالياتي',
      showDurationFilter: true,
      showJobFilter: true,
      emptyTitle: 'No events found',
    );
  }
}
