// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class VoiceRecorder extends StatefulWidget {
//   final Function(String audioPath, int duration) onRecordingComplete;
//   final VoidCallback onCancel;

//   const VoiceRecorder({
//     Key? key,
//     required this.onRecordingComplete,
//     required this.onCancel,
//   }) : super(key: key);

//   @override
//   _VoiceRecorderState createState() => _VoiceRecorderState();
// }

// class _VoiceRecorderState extends State<VoiceRecorder>
//     with TickerProviderStateMixin {
//   final Record _audioRecorder = Record();
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
  
//   Timer? _timer;
//   int _recordDuration = 0;
//   bool _isRecording = false;
//   String? _audioPath;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.2,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
    
//     _startRecording();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _animationController.dispose();
//     _audioRecorder.dispose();
//     super.dispose();
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await _audioRecorder.hasPermission()) {
//         final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
//         _audioPath = '${appDocumentsDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';
        
//         await _audioRecorder.start(
//           path: _audioPath!,
//           encoder: AudioEncoder.aacLc,
//           bitRate: 128000,
//           samplingRate: 44100,
//         );
        
//         setState(() {
//           _isRecording = true;
//         });
        
//         _animationController.repeat(reverse: true);
        
//         _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//           setState(() {
//             _recordDuration++;
//           });
//         });
//       } else {
//         // Request permission
//         await Permission.microphone.request();
//       }
//     } catch (e) {
//       print('Failed to start recording: $e');
//       widget.onCancel();
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       if (_isRecording) {
//         await _audioRecorder.stop();
//         _timer?.cancel();
//         _animationController.stop();
        
//         if (_audioPath != null && _recordDuration > 0) {
//           widget.onRecordingComplete(_audioPath!, _recordDuration);
//         } else {
//           widget.onCancel();
//         }
//       }
//     } catch (e) {
//       print('Failed to stop recording: $e');
//       widget.onCancel();
//     }
//   }

//   void _cancelRecording() async {
//     try {
//       if (_isRecording) {
//         await _audioRecorder.stop();
//         _timer?.cancel();
//         _animationController.stop();
        
//         // Delete the recorded file
//         if (_audioPath != null) {
//           final file = File(_audioPath!);
//           if (await file.exists()) {
//             await file.delete();
//           }
//         }
//       }
//       widget.onCancel();
//     } catch (e) {
//       print('Failed to cancel recording: $e');
//       widget.onCancel();
//     }
//   }

//   String _formatDuration(int seconds) {
//     final minutes = seconds ~/ 60;
//     final remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 12,
//                 height: 12,
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Recording... ${_formatDuration(_recordDuration)}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             // mainAxisAlignment: MainAxisAlignment.spaceEnd,
//             children: [
//               // Cancel button
//               GestureDetector(
//                 onTap: _cancelRecording,
//                 child: Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.close,
//                     size: 28,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 20),
//               // Recording animation
//               AnimatedBuilder(
//                 animation: _scaleAnimation,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: _scaleAnimation.value,
//                     child: Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Container(
//                           width: 60,
//                           height: 60,
//                           decoration: const BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.mic,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(width: 20),
//               // Send button
//               GestureDetector(
//                 onTap: _stopRecording,
//                 child: Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.send,
//                     size: 28,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'Slide to cancel • Tap to send',
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorderWaveforms extends StatefulWidget {
  final Function(String audioPath, int duration) onRecordingComplete;
  final VoidCallback onCancel;

  const VoiceRecorderWaveforms({
    Key? key,
    required this.onRecordingComplete,
    required this.onCancel,
  }) : super(key: key);

  @override
  _VoiceRecorderWaveformsState createState() => _VoiceRecorderWaveformsState();
}

class _VoiceRecorderWaveformsState extends State<VoiceRecorderWaveforms> {
  late RecorderController _recorderController;
  Timer? _timer;
  int _recordDuration = 0;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController();
    _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorderController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await Permission.microphone.request() == PermissionStatus.granted) {
        final Directory tempDir = await getTemporaryDirectory();
        _audioPath = '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _recorderController.record(path: _audioPath);
        
        setState(() {
          _isRecording = true;
        });
        
        _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
          setState(() {
            _recordDuration++;
          });
        });
      } else {
        widget.onCancel();
      }
    } catch (e) {
      print('Failed to start recording: $e');
      widget.onCancel();
    }
  }

  Future<void> _stopRecording() async {
    try {
      if (_isRecording) {
        final path = await _recorderController.stop();
        _timer?.cancel();
        
        if (path != null && _recordDuration > 0) {
          widget.onRecordingComplete(path, _recordDuration);
        } else {
          widget.onCancel();
        }
      }
    } catch (e) {
      print('Failed to stop recording: $e');
      widget.onCancel();
    }
  }

  void _cancelRecording() async {
    try {
      if (_isRecording) {
        await _recorderController.stop();
        _timer?.cancel();
        
        // Delete the recorded file
        if (_audioPath != null) {
          final file = File(_audioPath!);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
      widget.onCancel();
    } catch (e) {
      print('Failed to cancel recording: $e');
      widget.onCancel();
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Recording... ${_formatDuration(_recordDuration)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Audio waveform
          if (_isRecording)
            SizedBox(
              height: 50,
              child: AudioWaveforms(
                size: Size(MediaQuery.of(context).size.width - 80, 50),
                recorderController: _recorderController,
                waveStyle: const WaveStyle(
                  waveColor: Colors.blue,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Cancel button
              GestureDetector(
                onTap: _cancelRecording,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 28,
                    color: Colors.grey,
                  ),
                ),
              ),
              // Send button
              GestureDetector(
                onTap: _stopRecording,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}