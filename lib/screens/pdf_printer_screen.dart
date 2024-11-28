import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:printing/printing.dart';  // Correct import for printing
import 'package:flutter/services.dart' show rootBundle;

class PDFPrinterScreen extends StatefulWidget {
  const PDFPrinterScreen({super.key});

  @override
  _PDFPrinterScreenState createState() => _PDFPrinterScreenState();
}

class _PDFPrinterScreenState extends State<PDFPrinterScreen> {
  String? base64Pdf;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    try {
      // Load JSON data
      String jsonString = await rootBundle.loadString('assets/JSONs/PURCH_SPEC_DOC.json');
      List<dynamic> jsonData = json.decode(jsonString);

      // Extract Base64 document
      setState(() {
        base64Pdf = jsonData[0]['base64Doc'];
      });
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base64 PDF Printer'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: base64Pdf == null
              ? null
              : () async {
                  try {
                    // Decode Base64 to bytes
                    final pdfBytes = base64Decode(base64Pdf!);

                    // Print the PDF
                    await Printing.layoutPdf(
                      onLayout: (format) async => pdfBytes,
                    );
                  } catch (e) {
                    print('Error printing PDF: $e');
                  }
                },
          child: const Text('Print PDF'),
        ),
      ),
    );
  }
}
