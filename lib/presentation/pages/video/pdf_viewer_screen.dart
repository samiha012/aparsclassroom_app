import 'package:flutter/material.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String pdfTitle;
  
  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.pdfTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pdfTitle)),
      body: const Center(child: Text('PDF Viewer Screen - TODO')),
    );
  }
}
