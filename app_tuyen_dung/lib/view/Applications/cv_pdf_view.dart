

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CvPdfView extends StatefulWidget {
  const CvPdfView({super.key, required this.cvUrl, required this.name});
  final String cvUrl;
  final String name;

  @override
  State<CvPdfView> createState() => _CvPdfViewState();
}

class _CvPdfViewState extends State<CvPdfView> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name, style: TextStyle(fontSize: 12),),
        actions: <Widget>[
        ],
      ),
      body: SfPdfViewer.network(
        widget.cvUrl,
      ),
    );
  }
}