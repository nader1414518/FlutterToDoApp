import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFViewerScreen extends StatefulWidget {
  String url;

  PDFViewerScreen({
    super.key,
    required this.url,
  });

  @override
  PDFViewerScreenState createState() => PDFViewerScreenState();
}

class PDFViewerScreenState extends State<PDFViewerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "PDF",
        ),
      ),
      body: const PDF(
        autoSpacing: true,
        enableSwipe: true,
        nightMode: false,
      ).cachedFromUrl(
        widget.url,
        placeholder: (double progress) => Center(
          child: LinearProgressIndicator(
            value: progress,
          ),
        ),
        errorWidget: (dynamic error) => Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
    );
  }
}
