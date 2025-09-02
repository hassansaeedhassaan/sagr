// lib/services/voice_recorder_service.dart
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceRecorderService {
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _path;
  Timer? _timer;
  int _duration = 0; // in seconds
  
  bool get isRecording => _isRecording;
  int get duration => _duration;
  String? get recordedFilePath => _path;
  
  // Request necessary permissions
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }
  
  // Start recording
  Future<bool> startRecording() async {
    if (await requestPermission()) {
      try {
        final directory = await getTemporaryDirectory();
        _path = '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        // Configure audio settings


         await _audioRecorder.start(const RecordConfig(), path: _path!);
        // await _audioRecorder.start(
        //   path: _path,
        //   encoder: AudioEncoder.aacLc, // AAC-LC encoding
        //   bitRate: 128000,
        //   samplingRate: 44100,
        // );
        
        _isRecording = true;
        _duration = 0;
        
        // Start a timer to track recording duration
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          _duration++;
        });
        
        return true;
      } catch (e) {
        print('Error starting recording: $e');
        return false;
      }
    } else {
      return false;
    }
  }
  
  // Stop recording
  Future<File?> stopRecording() async {
    if (!_isRecording) return null;
    
    _timer?.cancel();
    _timer = null;
    
    try {
      await _audioRecorder.stop();
      _isRecording = false;
      
      if (_path != null) {

        return File(_path!);
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
    
    return null;
  }
  
  // Cancel recording
  Future<void> cancelRecording() async {
    if (!_isRecording) return;
    
    _timer?.cancel();
    _timer = null;
    
    try {
      await _audioRecorder.stop();
      _isRecording = false;
      
      // Delete the recorded file
      if (_path != null) {
        final file = File(_path!);
        if (await file.exists()) {
          await file.delete();
        }
        _path = null;
      }
    } catch (e) {
      print('Error canceling recording: $e');
    }
  }
  
  // Format duration as MM:SS
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  // Dispose resources
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
  }
}