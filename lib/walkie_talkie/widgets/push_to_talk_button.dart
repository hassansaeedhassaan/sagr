import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/walkie_talkie/services/walkie_session.dart';

/// Compact hold-to-talk (push-to-talk) control for the event walkie channel,
/// backed by LiveKit (WebRTC). Sits on the attendance screen once the employee
/// has checked in: it joins the event's LiveKit room with the mic OFF, then
/// publishes audio only while the button is held. Releasing mutes again.
///
/// Owns a [WalkieSession] for the lifetime of the widget and tears it down on
/// dispose. Fails soft — a failed connect shows a tappable "retry" label rather
/// than breaking the surrounding screen.
class PushToTalkButton extends StatefulWidget {
  /// Walkie channel name for the event → maps 1:1 to a LiveKit room.
  final String channelName;

  const PushToTalkButton({super.key, required this.channelName});

  @override
  State<PushToTalkButton> createState() => _PushToTalkButtonState();
}

class _PushToTalkButtonState extends State<PushToTalkButton> {
  late final WalkieSession _session;

  @override
  void initState() {
    super.initState();
    _session = WalkieSession(channelName: widget.channelName)
      ..addListener(_onChanged);
    _session.connect();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _session.removeListener(_onChanged);
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final talking = _session.isTalking;
    final ready = _session.canTalk;
    final failed = _session.state == WalkieState.failed ||
        _session.state == WalkieState.micDenied;
    final remoteCount = _session.participants.length;

    final Color base = talking
        ? const Color(0xffdc2626)
        : (ready ? AppTheme.brand : AppTheme.textHint);

    final String label = failed
        ? 'Walkie-talkie unavailable — tap to retry'.tr
        : talking
            ? 'Release to stop'.tr
            : ready
                ? 'Hold to talk'.tr
                : _session.state == WalkieState.reconnecting
                    ? 'Reconnecting…'.tr
                    : 'Connecting…'.tr;

    return Column(
      children: [
        GestureDetector(
          onTap: failed ? _session.retry : null,
          onTapDown: ready ? (_) => _session.startTalking() : null,
          onTapUp: ready ? (_) => _session.stopTalking() : null,
          onTapCancel: ready ? _session.stopTalking : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: talking ? base : Colors.transparent,
              border: Border.all(color: base, width: 1.6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: talking
                  ? [
                      BoxShadow(
                        color: base.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  talking ? Icons.mic_rounded : Icons.mic_none_rounded,
                  color: talking ? Colors.white : base,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: talking ? Colors.white : base,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (ready && remoteCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '$remoteCount ${'on channel'.tr}',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
