import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pdfx/pdfx.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Page')),
      body: checkExtension(context, widget.file),
    );
  }

  openImage(context, file) {
    return Column(
      children: [
        Center(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Image.file(
              File(file.path),
              fit: BoxFit.scaleDown,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
            ),
            const SizedBox(height: 24),
            Text(basename(file.path))
          ]),
        ),
      ],
    );
  }

  openPdf(context, File file) {
    return PdfView(
      controller: PdfController(
        document: PdfDocument.openFile(file.path),
      ),
    );
  }

  openDocument(context, File file) {
    return Container(
      alignment: Alignment.center,
      child: const WebView(
        initialUrl: "https://www.google.com/"
      ),
    );
  }

  checkExtension(context, File file) {
    var ext = extension(file.path);
    if (ext.contains("pdf")) {
      return openPdf(context, file);
    } else if (ext.contains("doc")) {
      return openDocument(context, file);
    } else {
      return openImage(context, file);
    }
  }

  errorText() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        "file tidak dapat dibuka",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
