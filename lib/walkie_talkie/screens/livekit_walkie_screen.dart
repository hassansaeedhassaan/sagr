import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sagr/features/events/data/models/event_model.dart';
import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/walkie_talkie/services/walkie_session.dart';
import 'package:sagr/walkie_talkie/walkie_dev_config.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

/// Which of an event's two walkie channels a screen is bound to.
enum WalkieChannelKind { team, supervisor }

/// LiveKit-backed walkie-talkie screen for one of an event's channels.
///
/// Both the team channel (`/event_walkie_talkie`) and the supervisors channel
/// (`/event_supervisor_walkie_talkie`) render through this screen — they only
/// differ by which [ChannelInfo] they read and where the swap button goes.
/// The LiveKit room lifecycle lives in [WalkieSession].
class LiveKitWalkieScreen extends StatefulWidget {
  const LiveKitWalkieScreen({super.key, this.kind = WalkieChannelKind.team});

  final WalkieChannelKind kind;

  @override
  State<LiveKitWalkieScreen> createState() => _LiveKitWalkieScreenState();
}

class _LiveKitWalkieScreenState extends State<LiveKitWalkieScreen> {
  // EventsBindings lazyPuts the controller for both walkie routes; re-`put`ting
  // a fresh one here would throw away an event already loaded for this route.
  final EventController eventController = Get.find<EventController>();

  WalkieSession? _session;
  String? _loadError;
  bool _resolving = false;
  String _channelLabel = '';
  bool _isSupervisorUser = false;
  // Event id this screen resolved against, carried across a channel swap so the
  // destination screen can reload the same event.
  Object? _eventId;

  @override
  void initState() {
    super.initState();
    _resolveChannel();
  }

  /// Reached via `Get.toNamed(..., arguments: eventId)`. The controller is
  /// shared across event screens, so its cached event may be missing, missing
  /// this screen's channel, or left over from a *different* event — reload in
  /// all three cases (getEventInfo reads the eventId from Get.arguments),
  /// bounded so a stalled backend can't hang the screen.
  Future<void> _resolveChannel() async {
    if (_resolving) return;
    setState(() {
      _resolving = true;
      _loadError = null;
    });
    _eventId = Get.arguments;
    var event = eventController.event;
    final stale = event == null ||
        _channelOf(event) == null ||
        (_eventId != null && '${event.id}' != '$_eventId');
    if (stale) {
      try {
        await eventController.getEventInfo().timeout(const Duration(seconds: 15));
      } catch (_) {}
      event = eventController.event;
    }
    if (!mounted) return;

    final channel = event == null ? null : _channelOf(event);

    // Dev override: join a fixed room so the audio path can be exercised
    // before the backend assigns channels.
    if (WalkieDevConfig.enabled &&
        (channel == null || channel.channelName.isEmpty)) {
      final session =
          WalkieSession(channelName: WalkieDevConfig.fallbackChannel);
      session.addListener(_onSessionChanged);
      setState(() {
        _resolving = false;
        _channelLabel = WalkieDevConfig.fallbackChannel;
        _eventId ??= event?.id;
        _session = session;
      });
      return;
    }

    if (channel == null || channel.channelName.isEmpty) {
      // The API returns `channel: null` until the event actually has a walkie
      // channel assigned. Saying so beats the old bare "unavailable", which
      // read like a failure the user could do something about.
      setState(() {
        _resolving = false;
        _loadError = 'No walkie-talkie channel has been assigned to this event yet.';
      });
      return;
    }

    final session = WalkieSession(channelName: channel.channelName);
    session.addListener(_onSessionChanged);
    setState(() {
      _resolving = false;
      _isSupervisorUser = event?.userType == 'supervisor';
      _channelLabel = channel.displayName ?? channel.channelName;
      _eventId ??= event?.id;
      _session = session;
    });
  }

  ChannelInfo? _channelOf(EventModel event) =>
      widget.kind == WalkieChannelKind.supervisor
          ? event.supervisorChannel
          : event.channel;

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _swapChannel() async {
    await _session?.disconnect();
    // Pass the event id along — the destination reads it from Get.arguments to
    // reload the event when the shared controller doesn't already hold it.
    final route = widget.kind == WalkieChannelKind.supervisor
        ? '/event_walkie_talkie'
        : '/event_supervisor_walkie_talkie';
    Get.toNamed(route, arguments: _eventId);
  }

  @override
  void dispose() {
    _session?.removeListener(_onSessionChanged);
    _session?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadError != null) {
      // A channel can be assigned after the fact, so offer a re-check rather
      // than making the user back out and navigate in again.
      return _MessageScaffold(
        message: _loadError!.tr,
        actionLabel: _resolving ? null : 'Retry'.tr,
        onAction: _resolving ? null : _resolveChannel,
      );
    }

    final session = _session;
    if (session == null) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (session.state == WalkieState.micDenied) {
      return _MessageScaffold(
        message:
            'Microphone permission is required to use the walkie-talkie. Please enable it in your device settings.'
                .tr,
        actionLabel: 'Open Settings'.tr,
        onAction: openAppSettings,
      );
    }

    final event = eventController.event;
    final titleText = event?.name ?? _channelLabel;
    final connected = session.state == WalkieState.connected;
    final reconnecting = session.state == WalkieState.reconnecting;
    final talking = session.isTalking;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Obx(() => eventController.isLoading
            ? AppLoader.inline(color: Colors.white)
            : Text(
                titleText,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body: Column(
        children: [
          _header(session, connected, reconnecting, talking),
          Expanded(child: _participantList(session, connected)),
          _controls(session, connected, reconnecting, talking),
        ],
      ),
    );
  }

  Widget _header(
      WalkieSession session, bool connected, bool reconnecting, bool talking) {
    final statusColor = connected
        ? Colors.green
        : reconnecting
            ? Colors.orange
            : Colors.red;

    // The swap button only makes sense for supervisors, who belong to both
    // channels; on the supervisors screen it always shows (you got here from
    // the team channel).
    final showSwap =
        widget.kind == WalkieChannelKind.supervisor || _isSupervisorUser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status'.tr,
                      style:
                          TextStyle(color: Colors.grey[400], fontSize: 14)),
                  Text(
                    _statusLabel(session),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Channel'.tr,
                      style:
                          TextStyle(color: Colors.grey[400], fontSize: 14)),
                  Text(
                    _channelLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      talking ? Icons.mic : Icons.mic_off,
                      color: talking ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        talking ? 'Transmitting...'.tr : 'Ready to talk'.tr,
                        style: TextStyle(
                          color: talking ? Colors.green : Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showSwap)
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: _swapChannel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 139, 67),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 12),
                    ),
                    child: Text(
                      widget.kind == WalkieChannelKind.supervisor
                          ? 'Back to Team Channel'.tr
                          : 'Join Supervisors Channel'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(WalkieSession session) {
    switch (session.state) {
      case WalkieState.connected:
        return 'Connected'.tr;
      case WalkieState.connecting:
        return 'Connecting...'.tr;
      case WalkieState.reconnecting:
        return 'Reconnecting...'.tr;
      case WalkieState.failed:
      case WalkieState.micDenied:
      case WalkieState.idle:
        return 'Disconnected'.tr;
    }
  }

  Widget _participantList(WalkieSession session, bool connected) {
    final people = session.participants;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'Connected Users'.tr} (${people.length})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: people.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            color: Colors.grey[600], size: 60),
                        const SizedBox(height: 10),
                        Text(
                          connected
                              ? 'Waiting for other users...'.tr
                              : 'Join channel to see users'.tr,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                        if (session.state == WalkieState.failed &&
                            session.error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            session.error!.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      final p = people[index];
                      return Card(
                        color: Colors.grey[800],
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                p.speaking ? Colors.green : Colors.blue,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(p.name,
                              style: const TextStyle(color: Colors.white)),
                          trailing: Icon(
                            p.speaking ? Icons.volume_up : Icons.volume_mute,
                            color: p.speaking ? Colors.green : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _controls(
      WalkieSession session, bool connected, bool reconnecting, bool talking) {
    final joined = connected || reconnecting;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          if (!joined)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: session.state == WalkieState.connecting
                    ? null
                    : session.connect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  session.state == WalkieState.connecting
                      ? 'Connecting...'.tr
                      : session.state == WalkieState.failed
                          ? 'Retry'.tr
                          : 'Join Channel'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (joined) ...[
            GestureDetector(
              onTapDown: connected ? (_) => session.startTalking() : null,
              onTapUp: connected ? (_) => session.stopTalking() : null,
              onTapCancel: connected ? session.stopTalking : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: talking
                      ? Colors.red
                      : (connected ? Colors.blue : Colors.grey),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (talking ? Colors.red : Colors.blue)
                          .withOpacity(0.3),
                      blurRadius: talking ? 20 : 10,
                      spreadRadius: talking ? 5 : 2,
                    ),
                  ],
                ),
                child: Icon(
                  talking ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              reconnecting
                  ? 'Reconnecting...'.tr
                  : talking
                      ? 'Release to stop talking'.tr
                      : 'Hold to talk'.tr,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: session.disconnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Leave Channel'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageScaffold extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageScaffold({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Colors.redAccent, size: 60),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
