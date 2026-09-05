import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/chat_theme.dart';

/// Recording composer bar: a pulsing live indicator, an animated waveform of
/// the incoming mic signal, and clear cancel / send actions. Replaces the
/// text input while the user is recording a voice note.
class VoiceRecorderWaveforms extends StatefulWidget {
  final Function(String audioPath, int duration) onRecordingComplete;
  final VoidCallback onCancel;

  const VoiceRecorderWaveforms({
    Key? key,
    required this.onRecordingComplete,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<VoiceRecorderWaveforms> createState() => _VoiceRecorderWaveformsState();
}

class _VoiceRecorderWaveformsState extends State<VoiceRecorderWaveforms>
    with SingleTickerProviderStateMixin {
  late final RecorderController _recorderController;
  late final AnimationController _pulseController;
  Timer? _timer;
  int _recordDuration = 0;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _recorderController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.request() == PermissionStatus.granted) {
        final tempDir = await getTemporaryDirectory();
        _audioPath =
            '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorderController.record(path: _audioPath);
        setState(() => _isRecording = true);
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) setState(() => _recordDuration++);
        });
      } else {
        widget.onCancel();
      }
    } catch (e) {
      debugPrint('Voice record start failed: $e');
      widget.onCancel();
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (!_isRecording) return;
      final path = await _recorderController.stop();
      _timer?.cancel();
      if (path != null && _recordDuration > 0) {
        widget.onRecordingComplete(path, _recordDuration);
      } else {
        widget.onCancel();
      }
    } catch (e) {
      debugPrint('Voice record stop failed: $e');
      widget.onCancel();
    }
  }

  Future<void> _cancelRecording() async {
    try {
      if (_isRecording) {
        await _recorderController.stop();
        _timer?.cancel();
        if (_audioPath != null) {
          final file = File(_audioPath!);
          if (await file.exists()) await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Voice record cancel failed: $e');
    } finally {
      widget.onCancel();
    }
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final palette = ChatTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.appBar,
        boxShadow: ChatTheme.softShadow(palette.navy),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Cancel / delete
            _circleButton(
              icon: Icons.delete_outline,
              bg: palette.recordDot.withOpacity(0.12),
              fg: palette.recordDot,
              tooltip: 'Cancel'.tr,
              onTap: _cancelRecording,
            ),
            const SizedBox(width: 8),
            // Live timer + waveform pill
            Expanded(
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: palette.searchField,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(begin: 0.35, end: 1.0)
                          .animate(_pulseController),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: palette.recordDot,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 44,
                      child: Text(
                        _formatDuration(_recordDuration),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: palette.body,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _isRecording
                          ? AudioWaveforms(
                              size: const Size(double.infinity, 34),
                              recorderController: _recorderController,
                              enableGesture: false,
                              waveStyle: WaveStyle(
                                waveColor: palette.recordWave,
                                extendWaveform: true,
                                showMiddleLine: false,
                                spacing: 4,
                                waveThickness: 2.5,
                                waveCap: StrokeCap.round,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send
            _circleButton(
              icon: Icons.send_rounded,
              bg: palette.primary,
              fg: Colors.white,
              tooltip: 'Send'.tr,
              onTap: _stopRecording,
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required Color bg,
    required Color fg,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(icon, color: fg, size: 22),
          ),
        ),
      ),
    );
  }
}
