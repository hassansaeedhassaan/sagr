import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DocumentMessageWidget extends StatefulWidget {
  final String? documentUrl;
  final String? fileName;
  final int? fileSize;
  final bool isMe;
  final VoidCallback? onLongPress;

  const DocumentMessageWidget({
    Key? key,
    required this.documentUrl,
    this.fileName,
    this.fileSize,
    required this.isMe,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<DocumentMessageWidget> createState() => _DocumentMessageWidgetState();
}

class _DocumentMessageWidgetState extends State<DocumentMessageWidget>
    with SingleTickerProviderStateMixin {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localFilePath;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _checkIfFileExists();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkIfFileExists() async {
    if (widget.fileName == null) return;
    
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = path.join(dir.path, 'downloads', widget.fileName!);
      final file = File(filePath);
      
      if (await file.exists()) {
        setState(() => _localFilePath = filePath);
      }
    } catch (e) {
      print('Error checking file: $e');
    }
  }

  Future<void> _downloadFile() async {
    if (widget.documentUrl == null || widget.fileName == null) {
      Get.snackbar('Error', 'Invalid file URL');
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory(path.join(dir.path, 'downloads'));
      
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final filePath = path.join(downloadDir.path, widget.fileName!);
      
      final dio = Dio();
      await dio.download(
        widget.documentUrl!,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      setState(() {
        _isDownloading = false;
        _localFilePath = filePath;
      });

      Get.snackbar(
        'Success',
        'File downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      setState(() => _isDownloading = false);
      Get.snackbar(
        'Error',
        'Failed to download file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  Future<void> _openFile() async {
    if (_localFilePath == null) {
      await _downloadFile();
      if (_localFilePath == null) return;
    }

    try {
      final result = await OpenFile.open(_localFilePath!);
      if (result.type != ResultType.done) {
        Get.snackbar('Info', 'No app found to open this file');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to open file: $e');
    }
  }

  String _getFileExtension() {
    if (widget.fileName == null || widget.fileName!.isEmpty) return 'FILE';
    try {
      final ext = path.extension(widget.fileName!).toUpperCase();
      return ext.isEmpty ? 'FILE' : ext.substring(1);
    } catch (e) {
      return 'FILE';
    }
  }

  IconData _getFileIcon() {
    final ext = _getFileExtension().toLowerCase();
    
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp3':
      case 'wav':
      case 'aac':
        return Icons.audio_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor() {
    final ext = _getFileExtension().toLowerCase();
    
    switch (ext) {
      case 'pdf':
        return Colors.red.shade700;
      case 'doc':
      case 'docx':
        return Colors.blue.shade700;
      case 'xls':
      case 'xlsx':
        return Colors.green.shade700;
      case 'ppt':
      case 'pptx':
        return Colors.orange.shade700;
      case 'zip':
      case 'rar':
      case '7z':
        return Colors.purple.shade700;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.pink.shade700;
      case 'mp3':
      case 'wav':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null) return 'Unknown size';
    
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    // Handle null document URL
    if (widget.documentUrl == null || widget.documentUrl!.isEmpty) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 280, minWidth: 240),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isMe
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isMe
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Document unavailable',
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _isDownloading ? null : _openFile,
      onLongPress: widget.onLongPress,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280, minWidth: 240),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isMe
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.isMe
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // File Icon with extension badge
            _buildFileIconSection(),
            const SizedBox(width: 12),
            
            // File info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fileName ?? 'Document',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.isMe ? Colors.white : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatFileSize(widget.fileSize),
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isMe
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade600,
                        ),
                      ),
                      if (_localFilePath != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 10,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'Downloaded',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_isDownloading) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _downloadProgress,
                        backgroundColor: widget.isMe
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isMe ? Colors.white : Colors.blue,
                        ),
                        minHeight: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isMe
                            ? Colors.white.withOpacity(0.7)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Action button
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileIconSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getFileColor().withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getFileIcon(),
            color: _getFileColor(),
            size: 28,
          ),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: _getFileColor(),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              _getFileExtension(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (_isDownloading) {
      return ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isMe
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.shade200,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  value: _downloadProgress,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.isMe ? Colors.white : Colors.blue,
                  ),
                ),
              ),
              Icon(
                Icons.close,
                size: 12,
                color: widget.isMe ? Colors.white : Colors.blue,
              ),
            ],
          ),
        ),
      );
    }

    if (_localFilePath != null) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isMe
              ? Colors.white.withOpacity(0.25)
              : Colors.blue.withOpacity(0.15),
        ),
        child: Icon(
          Icons.open_in_new,
          size: 18,
          color: widget.isMe ? Colors.white : Colors.blue.shade700,
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.isMe
            ? Colors.white.withOpacity(0.25)
            : Colors.blue.withOpacity(0.15),
      ),
      child: Icon(
        Icons.download,
        size: 18,
        color: widget.isMe ? Colors.white : Colors.blue.shade700,
      ),
    );
  }
}