import 'package:flutter/material.dart';
import '../models/purchase_responsible.dart';
import 'dart:convert';

class PurchaseResponsibleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Purchase Responsible List')),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/JSONs/purchaseResponsibleList.json'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List responsibles = json.decode(snapshot.data.toString());
            return DataTable(
              columns: [
                DataColumn(label: Text('Group')),
                DataColumn(label: Text('Text')),
                DataColumn(label: Text('Responsible')),
              ],
              rows: responsibles.map((data) {
                final responsible = PurchaseResponsible.fromJson(data);
                return DataRow(cells: [
                  DataCell(Text(responsible.purchaseGroup)),
                  DataCell(Text(responsible.purchaseGroupText)),
                  DataCell(Text('${responsible.responsible}')),
                ]);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
