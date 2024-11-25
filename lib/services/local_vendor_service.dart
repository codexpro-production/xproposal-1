import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/vendor.dart';

class LocalVendorService {
  Future<List<Vendor>> fetchVendors() async {
    try {
      final String response = await rootBundle.loadString('assets/JSONs/vendorList.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((vendor) => Vendor.fromJson(vendor)).toList();
    } catch (e) {
      throw Exception("Failed to load vendors: $e");
    }
  }
}
