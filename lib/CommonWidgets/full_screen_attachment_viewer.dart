import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Full-screen in-app viewer for news feed / observation attachments.
class FullScreenAttachmentViewer extends StatefulWidget {
  final String url;
  final String title;
  final String extension;

  const FullScreenAttachmentViewer({
    super.key,
    required this.url,
    required this.title,
    required this.extension,
  });

  @override
  State<FullScreenAttachmentViewer> createState() =>
      _FullScreenAttachmentViewerState();
}

class _FullScreenAttachmentViewerState
    extends State<FullScreenAttachmentViewer> {
  WebViewController? _webController;
  bool _webLoading = true;
  String? _webError;

  @override
  void initState() {
    super.initState();
    if (_isOfficeDocument(widget.extension)) {
      _initOfficeWebView();
    }
  }

  bool _isOfficeDocument(String ext) =>
      ext == 'doc' || ext == 'docx' || ext == 'xls' || ext == 'xlsx' || ext == 'ppt' || ext == 'pptx';

  void _initOfficeWebView() {
    final encodedUrl = Uri.encodeComponent(widget.url);
    final viewerUrl =
        'https://view.officeapps.live.com/op/embed.aspx?src=$encodedUrl';

    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _webLoading = true;
                _webError = null;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _webLoading = false);
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _webLoading = false;
                _webError = error.description;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(viewerUrl));
  }

  Future<void> _openOriginalExternally() async {
    try {
      final uri = Uri.parse(widget.url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open in browser")),
        );
      }
    }
  }

  Future<void> _downloadAndOpenLocally() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode != 200) {
        throw Exception('Download failed');
      }

      final dir = await getApplicationDocumentsDirectory();
      final safeName = widget.title.replaceAll(RegExp(r'[^\w.\-]'), '_');
      final file = File('${dir.path}/$safeName.${widget.extension}');
      await file.writeAsBytes(response.bodyBytes);

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open attachment")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          if (_isOfficeDocument(widget.extension))
            IconButton(
              icon: const Icon(Icons.download_rounded),
              tooltip: 'Download & open',
              onPressed: _downloadAndOpenLocally,
            ),
          IconButton(
            icon: const Icon(Icons.open_in_browser_rounded),
            tooltip: 'Open original',
            onPressed: _openOriginalExternally,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.extension == 'pdf') {
      return SfPdfViewer.network(widget.url);
    }

    if (_isOfficeDocument(widget.extension)) {
      if (_webError != null) {
        return _buildOfficeFallback();
      }

      return Stack(
        children: [
          if (_webController != null)
            WebViewWidget(controller: _webController!),
          if (_webLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    return _buildOfficeFallback();
  }

  Widget _buildOfficeFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 72,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _downloadAndOpenLocally,
              icon: const Icon(Icons.download_rounded),
              label: const Text('Download & open'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _openOriginalExternally,
              icon: const Icon(Icons.open_in_browser_rounded),
              label: const Text('Open in browser'),
            ),
          ],
        ),
      ),
    );
  }
}
