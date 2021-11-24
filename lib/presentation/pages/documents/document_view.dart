import 'package:appdiet/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentView extends StatelessWidget {
  const DocumentView({required this.document, Key? key}) : super(key: key);

  final Document document;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          document.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: document.extension == '.pdf'
          ? SfPdfViewer.network(document.downloadUrl)
          : Stack(
              alignment: Alignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                Image.network(document.downloadUrl)
              ],
            ),
    );
  }
}
