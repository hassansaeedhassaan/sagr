import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class SagrFilePicker extends StatelessWidget {
  final Function(String?) onFileSelected; // دالة تُستدعى عند اختيار ملف

  const SagrFilePicker({Key? key, required this.onFileSelected}) : super(key: key);

  // void _pickFile(BuildContext context) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf'],
  //   );

  //   if (result != null) {
  //     String filePath = result.files.single.path!;
  //     onFileSelected(filePath); // تمرير مسار الملف للدالة
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("لم يتم اختيار أي ملف")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onFileSelected,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: Colors.black, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf, size: 40, color: Colors.black),
            SizedBox(height: 8),
            Text("إرفاق مستند الايبان", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
