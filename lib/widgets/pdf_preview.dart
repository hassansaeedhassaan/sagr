import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class PdfUploadPreview extends StatefulWidget {
  final String? initialPdfUrl; // For edit page - existing PDF URL
  final String? initialPdfName; // Name of existing PDF
  final Function(PlatformFile?)? onPdfSelected;

  const PdfUploadPreview({
    Key? key,
    this.initialPdfUrl,
    this.initialPdfName,
    this.onPdfSelected,
  }) : super(key: key);

  @override
  State<PdfUploadPreview> createState() => _PdfUploadPreviewState();
}

class _PdfUploadPreviewState extends State<PdfUploadPreview> {
  PlatformFile? _selectedPdf;

  Future<void> _pickPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedPdf = result.files.first;
        });
        widget.onPdfSelected?.call(result.files.first);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick PDF: $e');
    }
  }

  void _removePdf() {
    setState(() {
      _selectedPdf = null;
    });
    widget.onPdfSelected?.call(null);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget _buildPdfPreview() {
    if (_selectedPdf != null) {
      // Show newly selected PDF
      return _buildPdfCard(
        fileName: _selectedPdf!.name,
        fileSize: _selectedPdf!.size,
        isNew: true,
      );
    } else if (widget.initialPdfUrl != null &&
        widget.initialPdfUrl!.isNotEmpty) {
      // Show existing PDF (for edit page)
      return _buildPdfCard(
        fileName: widget.initialPdfName ?? 'Document.pdf',
        fileSize: null,
        isNew: false,
        pdfUrl: widget.initialPdfUrl,
      );
    } else {
      // Show placeholder
      return _buildPlaceholder();
    }
  }

  Widget _buildPdfCard({
    required String fileName,
    int? fileSize,
    required bool isNew,
    String? pdfUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  size: 40,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isNew ? Colors.green[100] : Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isNew ? 'NEW' : 'EXISTING',
                            style: TextStyle(
                              color: isNew ? Colors.green[800] : Colors.blue[800],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (fileSize != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            _formatFileSize(fileSize),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (pdfUrl != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement PDF viewer or open URL
                      print('View PDF: $pdfUrl');
                    },
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ),
              if (pdfUrl != null) const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _removePdf,
                  icon: const Icon(Icons.delete, size: 18),
                  label: const Text('Remove'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return GestureDetector(
      onTap: _pickPdf,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_file,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No PDF selected',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to upload PDF file',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Max size: 10 MB',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PDF Document',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red[700],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPdfPreview(),
            if (_selectedPdf == null && widget.initialPdfUrl == null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickPdf,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
            if (_selectedPdf != null || widget.initialPdfUrl != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickPdf,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Change PDF'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}