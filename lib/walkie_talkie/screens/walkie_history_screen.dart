import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:just_audio/just_audio.dart';

import 'package:sagr/features/events/presentation/controllers/event_controller.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/walkie_talkie/services/walkie_history_service.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

/// The message history of the user's walkie-talkie channels on one event:
/// who spoke, when and for how long, newest first and grouped by day, each
/// playable as its stretch of the channel recording. Opened from the event
/// page's tools card with the event id as the route argument.
class WalkieHistoryScreen extends StatefulWidget {
  const WalkieHistoryScreen({super.key});

  @override
  State<WalkieHistoryScreen> createState() => _WalkieHistoryScreenState();
}

class _WalkieHistoryScreenState extends State<WalkieHistoryScreen> {
  final _service = WalkieHistoryService();
  final _player = AudioPlayer();
  final _scroll = ScrollController();
  final int? _eventId = eventIdFromArguments(Get.arguments);

  List<WalkieMessage>? _items;
  String? _error;
  bool _loading = false;
  bool _loadingMore = false;
  int _page = 1;
  bool _hasMore = false;
  int? _currentId;

  String get _locale => Get.locale?.toString() ?? 'ar';

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _player.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_hasMore &&
        !_loadingMore &&
        _scroll.position.pixels > _scroll.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _load() async {
    final id = _eventId;
    if (id == null) {
      setState(() => _error = 'Could not load the messages.'.tr);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await _service.fetch(id);
      if (!mounted) return;
      setState(() {
        _items = page.items;
        _page = page.currentPage;
        _hasMore = page.hasMore;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = WalkieHistoryService.describeError(e).tr);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    final id = _eventId;
    if (id == null) return;
    setState(() => _loadingMore = true);
    try {
      final page = await _service.fetch(id, page: _page + 1);
      if (!mounted) return;
      final seen = (_items ?? const []).map((m) => m.id).toSet();
      setState(() {
        _items = [
          ...?_items,
          ...page.items.where((m) => !seen.contains(m.id)),
        ];
        _page = page.currentPage;
        _hasMore = page.hasMore;
      });
    } catch (_) {
      // The next scroll tries again.
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  Future<void> _toggle(WalkieMessage message) async {
    final audio = message.audio;
    if (audio == null) return;

    if (_currentId == message.id) {
      final completed = _player.processingState == ProcessingState.completed;
      if (_player.playing && !completed) {
        await _player.pause();
      } else {
        if (completed) await _player.seek(Duration.zero);
        unawaited(_player.play());
      }
      return;
    }

    setState(() => _currentId = message.id);
    try {
      // Only this message's stretch of the channel recording.
      await _player.setAudioSource(ClippingAudioSource(
        child: AudioSource.uri(Uri.parse(audio.url)),
        start: audio.offset,
        end: audio.offset + audio.length,
      ));
      // play() completes only when playback stops; don't wait on it.
      unawaited(_player.play());
    } catch (_) {
      if (!mounted) return;
      setState(() => _currentId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not play this message.'.tr)),
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
        title: Text('Walkie-talkie history'.tr),
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
        Icons.forum_outlined,
        'No messages yet.'.tr,
        hint: 'Every message on your channels appears here with who sent it.'.tr,
      );
    }

    // Day headers between the messages, newest day first.
    final rows = <Object>[];
    DateTime? day;
    for (final m in items) {
      final d = DateUtils.dateOnly(m.startedAt);
      if (d != day) {
        rows.add(d);
        day = d;
      }
      rows.add(m);
    }

    return ListView.builder(
      controller: _scroll,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: rows.length + 1,
      itemBuilder: (_, i) {
        if (i == rows.length) {
          return _loadingMore
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(child: AppLoader.inline(color: AppTheme.brand)),
                )
              : const SizedBox(height: 8);
        }
        final row = rows[i];
        return row is DateTime ? _dayHeader(row) : _tile(row as WalkieMessage);
      },
    );
  }

  Widget _dayHeader(DateTime day) {
    final today = DateUtils.dateOnly(DateTime.now());
    final label = day == today
        ? 'Today'.tr
        : day == today.subtract(const Duration(days: 1))
            ? 'Yesterday'.tr
            : DateFormat('EEEE d MMMM', _locale).format(day);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.textMuted,
        ),
      ),
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

  Widget _tile(WalkieMessage message) {
    final current = _currentId == message.id;
    final channelColor =
        message.isSupervisorChannel ? AppTheme.warning : AppTheme.brand;
    final name = message.isMe ? 'You'.tr : message.speakerName;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
              _avatar(message),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textTitle,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          message.isSupervisorChannel
                              ? Icons.shield_rounded
                              : Icons.groups_rounded,
                          size: 14,
                          color: channelColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${message.isSupervisorChannel ? 'Supervisors channel'.tr : 'Team channel'.tr}'
                            '  ·  ${DateFormat('h:mm a', _locale).format(message.startedAt)}'
                            '  ·  ${_clock(message.duration)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _playButton(message, current),
            ],
          ),
          if (message.audio == null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'Audio not available yet'.tr,
                style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
              ),
            ),
          ],
          if (current) ...[
            const SizedBox(height: 8),
            _progress(),
          ],
        ],
      ),
    );
  }

  Widget _avatar(WalkieMessage message) {
    final initial = message.speakerName.trim().isEmpty
        ? '?'
        : message.speakerName.trim().characters.first;
    final fallback = Text(
      initial,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        color: AppTheme.brand,
      ),
    );

    return CircleAvatar(
      radius: 21,
      backgroundColor: AppTheme.brand.withOpacity(0.12),
      child: message.speakerImage == null
          ? fallback
          : ClipOval(
              child: Image.network(
                message.speakerImage!,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback,
              ),
            ),
    );
  }

  Widget _playButton(WalkieMessage message, bool current) {
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
          onPressed: message.audio == null ? null : () => _toggle(message),
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
            final position = positionSnapshot.data ?? Duration.zero;
            final max = total.inMilliseconds;
            return ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: max <= 0
                    ? 0
                    : (position.inMilliseconds / max).clamp(0.0, 1.0),
                minHeight: 3,
                color: AppTheme.brand,
                backgroundColor: AppTheme.line,
              ),
            );
          },
        );
      },
    );
  }

  /// "0:07" / "1:12".
  static String _clock(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
