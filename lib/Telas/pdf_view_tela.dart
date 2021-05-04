import 'dart:io';
import 'dart:typed_data';

import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfViewTela extends StatefulWidget {
  final String url;
  final String titulo;

  PdfViewTela(this.url, this.titulo);

  @override
  _PdfViewTelaState createState() => _PdfViewTelaState();
}

class _PdfViewTelaState extends State<PdfViewTela> {
  String? path;

  @override
  void initState() {
    loadPdf();
    super.initState();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/temp.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(Uri.parse(widget.url));
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  loadPdf() async {
    writeCounter(await fetchPost());
    path = (await _localFile).path;
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        centerTitle: true,
        leading: Util.leadingScaffold(context),
      ),
      body: path != null
          ? PDFView(
              filePath: path,
              enableSwipe: true,
              fitPolicy: FitPolicy.BOTH,
              fitEachPage: false,
              pageSnap: false,
              autoSpacing: false,
              pageFling: false,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
