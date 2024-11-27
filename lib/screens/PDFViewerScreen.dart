import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/path_provider/path_provider.dart';


class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen({super.key});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? filePath;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    try {
      // JSON dosyasını oku
      String jsonString = await rootBundle.loadString('assets/JSONs/PURCH_SPEC_DOC.json');
      List<dynamic> jsonData = json.decode(jsonString);

      // Base64 veriyi al
      String base64Doc = jsonData[0]['base64Doc'];

      // Base64'ü çözüp PDF dosyası olarak kaydet
      final bytes = base64Decode(base64Doc);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/document.pdf');
      await file.writeAsBytes(bytes, flush: true);

      // Dosya yolunu kaydet
      setState(() {
        filePath = file.path;
      });
    } catch (e) {
      print('PDF yüklenirken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Görüntüleyici'),
      ),
      body: filePath != null
          ? PDFView(
              filePath: filePath!,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
