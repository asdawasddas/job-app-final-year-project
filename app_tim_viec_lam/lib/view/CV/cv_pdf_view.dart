import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CvPdfView extends StatefulWidget {
  const CvPdfView({super.key, required this.cvUrl,});
  final String cvUrl;

  @override
  State<CvPdfView> createState() => _CvPdfViewState();
}

class _CvPdfViewState extends State<CvPdfView> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text( 'CV bạn đã nộp', style: TextStyle(fontSize: 12),),
      ),
      body: SfPdfViewer.network(
        widget.cvUrl,
      ),
    );

  }
}