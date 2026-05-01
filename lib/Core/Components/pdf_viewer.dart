import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:portfolio_app/Core/core.dart';

class PdfView extends StatelessWidget {
  const PdfView({super.key, required this.pdfPath, required this.pdfTitle});

  final String pdfPath;
  final String pdfTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: pdfTitle),
          Expanded(child: SfPdfViewer.asset(pdfPath)),
        ],
      ),
    );
  }
}
