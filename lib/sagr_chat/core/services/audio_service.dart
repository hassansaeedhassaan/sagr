import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService extends GetxService {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _recordingPath;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    
    await _recorder!.openRecorder();
    await _player!.openPlayer();
  }

  Future<bool> _requestPermissions() async {
    final microphoneStatus = await Permission.microphone.request();
    return microphoneStatus == PermissionStatus.granted;
  }

  Future<void> startRecording() async {
    if (!await _requestPermissions()) {
      Get.snackbar('Permission Required', 'Microphone permission is required to record audio');
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    _recordingPath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder!.startRecorder(
      toFile: _recordingPath,
      codec: Codec.aacADTS,
    );
  }

  Future<String?> stopRecording() async {
    await _recorder!.stopRecorder();
    return _recordingPath;
  }

  Future<void> playAudio(String audioPath) async {
    await _player!.startPlayer(
      fromURI: audioPath,
      whenFinished: () {
        print('Audio playback finished');
      },
    );
  }

  Future<void> stopPlayback() async {
    await _player!.stopPlayer();
  }

  Future<int> getAudioDuration(String audioPath) async {
    // This is a simplified implementation
    // In a real app, you'd use a library to get actual duration
    final file = File(audioPath);
    final size = await file.length();
    // Rough estimate: 1KB per second for AAC
    return (size / 1024).round();
  }

  bool get isRecording => _recorder?.isRecording ?? false;
  bool get isPlaying => _player?.isPlaying ?? false;

  @override
  void onClose() {
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.onClose();
  }
}