import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import '../theme/chat_theme.dart';

/// Voice note rendered as a self-contained dark pill so it reads as a
/// distinct, premium element regardless of the surrounding bubble color.
class VoiceMessagePlayer extends StatefulWidget {
  final String audioUrl;
  final bool isMe;
  final int? durationInSeconds;

  const VoiceMessagePlayer({
    Key? key,
    required this.audioUrl,
    required this.isMe,
    this.durationInSeconds,
  }) : super(key: key);

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey _waveKey = GlobalKey();

  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  late final AnimationController _waveController;
  late final List<double> _waveHeights;

  @override
  void initState() {
    super.initState();
    _waveHeights = _generateRealisticWaveform();

    if (widget.durationInSeconds != null && widget.durationInSeconds! > 0) {
      _duration = Duration(seconds: widget.durationInSeconds!);
    }

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted && d > Duration.zero) setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
      _waveController
        ..stop()
        ..reset();
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      if (state == PlayerState.playing) {
        _waveController.repeat();
      } else {
        _waveController.stop();
      }
    });
  }

  List<double> _generateRealisticWaveform() {
    final random = Random(widget.audioUrl.hashCode); // stable per message
    final List<double> heights = [];
    double previous = 0.3 + random.nextDouble() * 0.3;
    for (int i = 0; i < 38; i++) {
      double change = (random.nextDouble() - 0.5) * 0.4;
      double next = (previous + change).clamp(0.2, 0.95);
      if (random.nextDouble() > 0.85) {
        next = 0.7 + random.nextDouble() * 0.25;
      }
      heights.add(next);
      previous = next;
    }
    return heights;
  }

  @override
  void dispose() {
    _waveController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);
    final pillColor = widget.isMe ? palette.voiceOwnBg : palette.voiceOtherBg;
    final progress = _duration.inMilliseconds > 0
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      constraints: const BoxConstraints(minWidth: 210, maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [pillColor, Color.lerp(pillColor, Colors.black, 0.18)!],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _playButton(palette, pillColor),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: _seekToPosition,
              child: SizedBox(
                key: _waveKey,
                height: 30,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, _) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: _WaveformPainter(
                        waveHeights: _waveHeights,
                        progress: progress,
                        isPlaying: _isPlaying,
                        animationValue: _waveController.value,
                        playedColor: palette.voicePlayed,
                        unplayedColor: palette.voiceTrack,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.mic, size: 13, color: palette.voicePlayed),
              const SizedBox(height: 2),
              Text(
                _formatDuration(_isPlaying ? _position : _duration),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: palette.voiceText.withOpacity(0.85),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _playButton(ChatPalette palette, Color pillColor) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _togglePlayPause,
        child: SizedBox(
          width: 38,
          height: 38,
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(pillColor),
                  ),
                )
              : Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: pillColor,
                  size: 24,
                ),
        ),
      ),
    );
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      if (mounted) setState(() => _isPlaying = false);
      return;
    }
    if (widget.audioUrl.isEmpty) return;
    try {
      setState(() => _isLoading = true);
      if (_position >= _duration && _duration != Duration.zero) {
        await _audioPlayer.seek(Duration.zero);
      }
      await _audioPlayer.play(UrlSource(widget.audioUrl));
      if (mounted) setState(() => _isPlaying = true);
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to play audio'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _seekToPosition(TapDownDetails details) {
    if (_duration == Duration.zero) return;
    final box = _waveKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final local = box.globalToLocal(details.globalPosition);
    final ratio = (local.dx / box.size.width).clamp(0.0, 1.0);
    _audioPlayer.seek(_duration * ratio);
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }
}

/// Center-anchored bar waveform with a flowing animation while playing.
class _WaveformPainter extends CustomPainter {
  final List<double> waveHeights;
  final double progress;
  final bool isPlaying;
  final double animationValue;
  final Color playedColor;
  final Color unplayedColor;

  _WaveformPainter({
    required this.waveHeights,
    required this.progress,
    required this.isPlaying,
    required this.animationValue,
    required this.playedColor,
    required this.unplayedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = waveHeights.length;
    final totalSpacing = size.width * 0.15;
    final totalBarWidth = size.width - totalSpacing;
    final barWidth = totalBarWidth / barCount;
    final spacing = totalSpacing / (barCount - 1);
    final centerY = size.height / 2;
    final minH = size.height * 0.18;
    final maxH = size.height * 0.95;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + spacing);
      final barProgress = i / barCount;
      final isPlayed = barProgress <= progress;

      double base = waveHeights[i];
      if (isPlaying) {
        final phase = (animationValue + (i / barCount) * 0.5) % 1.0;
        base = (base + sin(phase * 2 * pi) * 0.12).clamp(0.15, 1.0);
      }
      final barHeight = minH + (maxH - minH) * base;

      final paint = Paint()
        ..color = isPlayed ? playedColor : unplayedColor
        ..strokeWidth = barWidth.clamp(2.0, 3.5)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(x + barWidth / 2, centerY - barHeight / 2),
        Offset(x + barWidth / 2, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) =>
      old.progress != progress ||
      old.isPlaying != isPlaying ||
      old.animationValue != animationValue;
}
