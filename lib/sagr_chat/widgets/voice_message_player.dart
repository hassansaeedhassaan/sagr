import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

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
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  // Generate random wave heights for visualization (WhatsApp style)
  late List<double> _waveHeights;

  @override
  void initState() {
    super.initState();
    
    // Initialize wave heights with realistic audio pattern
    _waveHeights = _generateRealisticWaveform();
    
    if (widget.durationInSeconds != null) {
      _duration = Duration(seconds: widget.durationInSeconds!);
    }
    
    // Setup wave animation controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
    
    // Audio player listeners
    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    
    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
        _waveController.stop();
        _waveController.reset();
      }
    });
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        if (state == PlayerState.playing) {
          _waveController.repeat();
        } else {
          _waveController.stop();
        }
      }
    });
  }

  // Generate realistic waveform pattern
  List<double> _generateRealisticWaveform() {
    final random = Random();
    final List<double> heights = [];
    double previousHeight = 0.3 + random.nextDouble() * 0.3;
    
    for (int i = 0; i < 35; i++) {
      // Create smooth transitions between bars
      double change = (random.nextDouble() - 0.5) * 0.4;
      double newHeight = (previousHeight + change).clamp(0.2, 0.95);
      
      // Add occasional peaks (like speech emphasis)
      if (random.nextDouble() > 0.85) {
        newHeight = 0.7 + random.nextDouble() * 0.25;
      }
      
      heights.add(newHeight);
      previousHeight = newHeight;
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
    final progress = _duration.inSeconds > 0 
        ? _position.inSeconds / _duration.inSeconds 
        : 0.0;

    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause Button with ripple effect
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _togglePlayPause,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isMe 
                      ? Colors.white.withOpacity(0.25)
                      : Colors.blue.withOpacity(0.12),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: widget.isMe ? Colors.white : Colors.blue[700],
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          
          // Waveform visualization
          Expanded(
            child: GestureDetector(
              onTapDown: (details) => _seekToPosition(details),
              child: Container(
                height: 32,
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _waveAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: WhatsAppWaveformPainter(
                        waveHeights: _waveHeights,
                        progress: progress,
                        isPlaying: _isPlaying,
                        animationValue: _waveAnimation.value,
                        playedColor: widget.isMe 
                            ? Colors.white.withOpacity(0.95)
                            : const Color(0xFF34B7F1),
                        unplayedColor: widget.isMe 
                            ? Colors.white.withOpacity(0.35)
                            : Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          
          // Duration text
          Text(
            _formatDuration(_isPlaying ? _position : _duration),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: widget.isMe ? Colors.white.withOpacity(0.8) : Colors.grey[600],
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      try {
        if (_position == _duration && _duration != Duration.zero) {
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.play(UrlSource(widget.audioUrl));
        setState(() => _isPlaying = true);
      } catch (e) {
        Get.snackbar(
          'Error', 
          'Failed to play audio',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  void _seekToPosition(TapDownDetails details) {
    if (_duration == Duration.zero) return;
    
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    final waveformStart = 46.0; // button width + spacing
    final waveformWidth = box.size.width - waveformStart - 40; // minus duration text width
    final seekRatio = ((localPosition.dx - waveformStart) / waveformWidth).clamp(0.0, 1.0);
    final seekPosition = _duration * seekRatio;
    
    _audioPlayer.seek(seekPosition);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

// WhatsApp-style Waveform Painter with smooth animations
class WhatsAppWaveformPainter extends CustomPainter {
  final List<double> waveHeights;
  final double progress;
  final bool isPlaying;
  final double animationValue;
  final Color playedColor;
  final Color unplayedColor;

  WhatsAppWaveformPainter({
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
    final totalSpacing = size.width * 0.15; // 15% for spacing
    final totalBarWidth = size.width - totalSpacing;
    final barWidth = totalBarWidth / barCount;
    final spacing = totalSpacing / (barCount - 1);
    
    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + spacing);
      final barProgress = i / barCount;
      
      // Determine if this bar is in the played section
      final isPlayed = barProgress <= progress;
      
      // Calculate height with smooth animation for playing state
      double baseHeight = waveHeights[i];
      
      if (isPlaying) {
        // Create flowing wave animation effect
        final phaseOffset = (i / barCount) * 0.5;
        final animPhase = (animationValue + phaseOffset) % 1.0;
        final pulse = sin(animPhase * 2 * pi) * 0.12;
        baseHeight = (baseHeight + pulse).clamp(0.15, 1.0);
      }
      
      // Minimum and maximum heights
      final minBarHeight = size.height * 0.15;
      final maxBarHeight = size.height * 0.90;
      final barHeight = minBarHeight + (maxBarHeight - minBarHeight) * baseHeight;
      
      final centerY = size.height / 2;
      
      // Smooth color transition at progress boundary
      Color barColor;
      if (isPlayed) {
        barColor = playedColor;
      } else {
        // Create subtle fade effect near progress
        final distanceFromProgress = barProgress - progress;
        if (distanceFromProgress < 0.08 && distanceFromProgress >= 0) {
          final fadeAmount = 1 - (distanceFromProgress / 0.08);
          barColor = Color.lerp(unplayedColor, playedColor, fadeAmount * 0.3)!;
        } else {
          barColor = unplayedColor;
        }
      }
      
      final paint = Paint()
        ..color = barColor
        ..strokeWidth = barWidth.clamp(2.0, 3.5)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      
      // Draw bar from center (WhatsApp style)
      final topPoint = Offset(x + barWidth / 2, centerY - barHeight / 2);
      final bottomPoint = Offset(x + barWidth / 2, centerY + barHeight / 2);
      
      canvas.drawLine(topPoint, bottomPoint, paint);
    }
  }

  @override
  bool shouldRepaint(WhatsAppWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.animationValue != animationValue;
  }
}

// Alternative: Telegram-style with filled rounded rectangles
class TelegramWaveformPainter extends CustomPainter {
  final List<double> waveHeights;
  final double progress;
  final bool isPlaying;
  final double animationValue;
  final Color playedColor;
  final Color unplayedColor;

  TelegramWaveformPainter({
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
    final barWidth = 2.5;
    final spacing = (size.width - (barCount * barWidth)) / (barCount - 1);
    
    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + spacing);
      final barProgress = i / barCount;
      final isPlayed = barProgress <= progress;
      
      // Generate smooth wave pattern
      double height = waveHeights[i];
      
      // Smooth with neighbors for more natural look
      if (i > 0 && i < barCount - 1) {
        height = (waveHeights[i - 1] * 0.25 + waveHeights[i] * 0.5 + waveHeights[i + 1] * 0.25);
      }
      
      // Add animation when playing
      if (isPlaying) {
        final phase = (animationValue * 3 + (i / barCount) * 2) % 1.0;
        final wave = sin(phase * pi * 2);
        height = (height + wave * 0.1).clamp(0.2, 1.0);
      }
      
      // Scale height
      final minHeight = size.height * 0.2;
      final maxHeight = size.height * 0.85;
      final barHeight = minHeight + (maxHeight - minHeight) * height;
      
      final centerY = size.height / 2;
      
      // Choose color
      final barColor = isPlayed ? playedColor : unplayedColor;
      
      final paint = Paint()
        ..color = barColor
        ..style = PaintingStyle.fill;
      
      // Draw rounded rectangle bar (Telegram style)
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x + barWidth / 2, centerY),
          width: barWidth,
          height: barHeight,
        ),
        const Radius.circular(1.5),
      );
      
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(TelegramWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.animationValue != animationValue;
  }
}