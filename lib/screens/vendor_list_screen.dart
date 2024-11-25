import 'package:flutter/material.dart';
import '../models/vendor.dart';
import '../services/local_vendor_service.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  late Future<List<Vendor>> _vendors;
  final LocalVendorService _vendorService = LocalVendorService();

  @override
  void initState() {
    super.initState();
    _vendors = _vendorService.fetchVendors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendor List"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _vendors = _vendorService.fetchVendors();
          });
        },
        child: FutureBuilder<List<Vendor>>(
          future: _vendors,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final vendors = snapshot.data!;
              return ListView.builder(
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  final vendor = vendors[index];
                  return ListTile(
                    title: Text(vendor.name1),
                    subtitle: Text("Vendor No: ${vendor.lifnr}"),
                    trailing: Text(vendor.email ?? "No email"),
                  );
                },
              );
            } else {
              return const Center(child: Text("No vendors found."));
            }
          },
        ),
      ),
    );
  }
}
