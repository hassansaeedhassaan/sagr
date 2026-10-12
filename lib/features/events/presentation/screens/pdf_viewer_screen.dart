import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sagr/theme/app_theme.dart';

/// Full-screen PDF viewer for contracts and application attachments.
///
/// Both call sites used to be a bare `SfPdfViewer.network(url)`. That widget
/// paints its plain grey background while it works and simply stays grey when
/// the document cannot be downloaded or rendered — no spinner, no message,
/// nothing the user or we can act on, which is exactly how a contract "not
/// opening" looked. This surfaces the load state and the real failure, and
/// always leaves a way to read the file: the device's own PDF viewer/browser.
class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  /// Bumped on retry so the viewer is rebuilt from scratch.
  int _attempt = 0;
  bool _isLoading = true;
  String? _error;

  Future<void> _openExternally() async {
    final uri = Uri.tryParse(widget.url);
    if (uri == null) return;

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open this file.'.tr)),
        );
      }
    }
  }

  void _retry() {
    setState(() {
      _attempt++;
      _isLoading = true;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: AppTheme.statusBarLight,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppTheme.textTitle),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppTheme.textTitle,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Open outside the app'.tr,
            icon: const Icon(Icons.open_in_new_rounded,
                color: AppTheme.textTitle),
            onPressed: _openExternally,
          ),
        ],
      ),
      body: _error != null ? _errorState() : _viewer(),
    );
  }

  Widget _viewer() {
    return Stack(
      children: [
        SfPdfViewer.network(
          widget.url,
          key: ValueKey<int>(_attempt),
          onDocumentLoaded: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              // description carries the useful part ("Unable to load the
              // document", a network message, a password prompt, …).
              _error = details.description.isNotEmpty
                  ? details.description
                  : details.error;
            });
          },
        ),
        if (_isLoading)
          const ColoredBox(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf_outlined,
                size: 56, color: AppTheme.danger),
            const SizedBox(height: 16),
            Text(
              'This file could not be displayed here.'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textTitle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.textBody),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openExternally,
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text('Open outside the app'.tr),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Try again'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
