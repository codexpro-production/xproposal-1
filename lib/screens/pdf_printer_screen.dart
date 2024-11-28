import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class PDFPrinterScreen extends StatefulWidget {
  const PDFPrinterScreen({super.key});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFPrinterScreen> {
  Map<String, List<String>> groupedPdfs =
      {}; // Grouped PDFs by purchase requisition number

  @override
  void initState() {
    super.initState();
    _loadPDFs();
  }

  Future<void> _loadPDFs() async {
    try {
      // Load JSON data
      String jsonString =
          await rootBundle.loadString('assets/JSONs/PURCH_SPEC_DOC.json');
      List<dynamic> jsonData = json.decode(jsonString);

      // Group documents by purchase requisition number
      setState(() {
        groupedPdfs = {};
        for (var item in jsonData) {
          String reqNumber = item['purchaseRequsitionNumber'];
          String base64Doc = item['base64Doc'];
          if (!groupedPdfs.containsKey(reqNumber)) {
            groupedPdfs[reqNumber] = [];
          }
          groupedPdfs[reqNumber]!.add(base64Doc);
        }
      });
    } catch (e) {
      print('Error loading PDFs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalDocumentCount =
        groupedPdfs.values.fold(0, (sum, docs) => sum + docs.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dökümanlar'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              'Toplam Adet: $totalDocumentCount',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: groupedPdfs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: groupedPdfs.keys.length,
              itemBuilder: (context, index) {
                String reqNumber = groupedPdfs.keys.elementAt(index);
                List<String> documents = groupedPdfs[reqNumber]!;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Purchase Req. No: $reqNumber',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Adet: ${documents.length}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: documents
                              .asMap()
                              .entries
                              .map((entry) => Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueGrey, // Border color
                                        width: 1.0, // Border width
                                      ),
                                      borderRadius: BorderRadius.circular(4), // Rounded corners
                                    ),
                                    padding: const EdgeInsets.all(6), // Padding inside the border
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              150, // Fixed width for description
                                          child: Text(
                                            '${entry.key + 1}. X Dökmümanı:',
                                            textAlign: TextAlign
                                                .left, // Align text to the left
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              final pdfBytes =
                                                  base64Decode(entry.value);

                                              // Print the PDF
                                              await Printing.layoutPdf(
                                                onLayout: (format) async =>
                                                    pdfBytes,
                                              );
                                            } catch (e) {
                                              print('Error printing PDF: $e');
                                            }
                                          },
                                          child: const Text(
                                              'Görüntüle'), // Button label
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
