import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:just_audio/just_audio.dart';

import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/walkie_talkie/services/walkie_recordings_service.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

/// A supervisor's recordings of their zone's walkie-talkie channels on one
/// event, with a player in place. Opened from the event page's tools card
/// with the event id as the route argument.
class WalkieRecordingsScreen extends StatefulWidget {
  const WalkieRecordingsScreen({super.key});

  @override
  State<WalkieRecordingsScreen> createState() => _WalkieRecordingsScreenState();
}

class _WalkieRecordingsScreenState extends State<WalkieRecordingsScreen> {
  static const _timeStyle = TextStyle(
    fontSize: 11.5,
    color: AppTheme.textMuted,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  final _service = WalkieRecordingsService();
  final _player = AudioPlayer();
  final int? _eventId = eventIdFromArguments(Get.arguments);

  List<WalkieRecording>? _items;
  String? _error;
  bool _loading = false;
  int? _currentId;

  String get _locale => Get.locale?.toString() ?? 'ar';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = _eventId;
    if (id == null) {
      setState(() => _error = 'Could not load the recordings.'.tr);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _service.fetch(id);
      if (mounted) setState(() => _items = items);
    } catch (e) {
      if (mounted) {
        setState(() => _error = WalkieRecordingsService.describeError(e).tr);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggle(WalkieRecording recording) async {
    if (_currentId == recording.id) {
      final completed = _player.processingState == ProcessingState.completed;
      if (_player.playing && !completed) {
        await _player.pause();
      } else {
        if (completed) await _player.seek(Duration.zero);
        // play() completes only when playback stops; don't wait on it.
        unawaited(_player.play());
      }
      return;
    }

    final url = recording.url;
    if (url == null) return;

    setState(() => _currentId = recording.id);
    try {
      await _player.setUrl(url);
      unawaited(_player.play());
    } catch (_) {
      if (!mounted) return;
      setState(() => _currentId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not play this recording.'.tr)),
      );
      // Playback links expire; fetch fresh ones for the next try.
      unawaited(_load());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: AppBar(
        title: Text('Walkie-talkie recordings'.tr),
        backgroundColor: AppTheme.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppTheme.brand,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    final items = _items;

    if (items == null) {
      if (_error != null) {
        return _message(Icons.cloud_off_rounded, _error!, retry: true);
      }
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 160),
          Center(child: AppLoader.inline(color: AppTheme.brand)),
        ],
      );
    }

    if (items.isEmpty) {
      return _message(
        Icons.mic_none_rounded,
        'No recordings yet.'.tr,
        hint: 'Recordings appear here after each walkie-talkie session ends.'.tr,
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _tile(items[i]),
    );
  }

  Widget _message(IconData icon, String text,
      {String? hint, bool retry = false}) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 80),
        Icon(icon, size: 44, color: AppTheme.textHint),
        const SizedBox(height: 12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textTitle,
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppTheme.textMuted,
            ),
          ),
        ],
        if (retry) ...[
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton(
              onPressed: _loading ? null : _load,
              child: Text('Retry'.tr),
            ),
          ),
        ],
      ],
    );
  }

  Widget _tile(WalkieRecording recording) {
    final current = _currentId == recording.id;
    final color =
        recording.isSupervisorChannel ? AppTheme.warning : AppTheme.brand;
    final meta = [
      if (recording.startedAt != null)
        DateFormat('d MMM y · h:mm a', _locale).format(recording.startedAt!),
      if (recording.durationSeconds != null)
        _clock(Duration(seconds: recording.durationSeconds!)),
    ].join('  ·  ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: current ? AppTheme.brand.withOpacity(0.5) : AppTheme.line,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  recording.isSupervisorChannel
                      ? Icons.shield_rounded
                      : Icons.groups_rounded,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recording.isSupervisorChannel
                          ? 'Supervisors channel'.tr
                          : 'Team channel'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textTitle,
                      ),
                    ),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        meta,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _playButton(recording, current),
            ],
          ),
          if (current) ...[
            const SizedBox(height: 6),
            _progress(),
          ],
        ],
      ),
    );
  }

  Widget _playButton(WalkieRecording recording, bool current) {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final processing = state?.processingState;
        final busy = current &&
            (processing == ProcessingState.loading ||
                processing == ProcessingState.buffering);
        final playing = current &&
            (state?.playing ?? false) &&
            processing != ProcessingState.completed;

        return IconButton.filled(
          onPressed: recording.url == null ? null : () => _toggle(recording),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.brand,
            foregroundColor: Colors.white,
          ),
          icon: busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
        );
      },
    );
  }

  Widget _progress() {
    return StreamBuilder<Duration?>(
      stream: _player.durationStream,
      builder: (context, durationSnapshot) {
        final total = durationSnapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: _player.positionStream,
          builder: (context, positionSnapshot) {
            var position = positionSnapshot.data ?? Duration.zero;
            if (position > total) position = total;
            final max = total.inMilliseconds.toDouble();

            return Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: max <= 0
                        ? 0
                        : position.inMilliseconds
                            .toDouble()
                            .clamp(0, max)
                            .toDouble(),
                    max: max <= 0 ? 1 : max,
                    activeColor: AppTheme.brand,
                    onChanged: max <= 0
                        ? null
                        : (v) =>
                            _player.seek(Duration(milliseconds: v.round())),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  // Clock times read left to right even in Arabic.
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_clock(position), style: _timeStyle),
                        Text(_clock(total), style: _timeStyle),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// "1:05:09" / "4:31".
  static String _clock(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
  }
}
