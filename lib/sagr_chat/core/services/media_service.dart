import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:sagr/widgets/messages.dart' show AppNotice;

class MediaService extends GetxService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image?.path;
    } catch (e) {
      AppNotice.error('Error', 'Failed to pick image: $e');
      return null;
    }
  }

  Future<String?> captureImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image?.path;
    } catch (e) {
      AppNotice.error('Error', 'Failed to capture image: $e');
      return null;
    }
  }

  Future<String?> pickVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );
      return video?.path;
    } catch (e) {
      AppNotice.error('Error', 'Failed to pick video: $e');
      return null;
    }
  }

  Future<String?> recordVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 5),
      );
      return video?.path;
    } catch (e) {
      AppNotice.error('Error', 'Failed to record video: $e');
      return null;
    }
  }

  Future<String?> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xlsx', 'pptx'],
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      }
      return null;
    } catch (e) {
      AppNotice.error('Error', 'Failed to pick document: $e');
      return null;
    }
  }
}