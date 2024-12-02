import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/vendor.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  late Future<List<Vendor>> _vendors;
  List<Vendor> _allVendors = []; 
  List<Vendor> _filteredVendors = []; 
  bool _isSearching = false; 
  final TextEditingController _searchController = TextEditingController();

  Future<List<Vendor>> fetchVendors() async {
    try {
      final String response = await rootBundle.loadString('assets/JSONs/vendorList.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => Vendor.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error loading or parsing JSON data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _vendors = fetchVendors();
    _vendors.then((value) {
      setState(() {
        _allVendors = value; 
        _filteredVendors = _allVendors;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredVendors = _allVendors.where((vendor) {
        return vendor.name1.toLowerCase().contains(query) ||
               vendor.lifnr.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredVendors = _allVendors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? const Text("Vendor List")
            : TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search by Name or Number",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
                autofocus: true,
              ),
        actions: [
          !_isSearching
              ? IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSearch,
                ),
        ],
      ),
      body: FutureBuilder<List<Vendor>>(
        future: _vendors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (_filteredVendors.isEmpty) {
              return const Center(child: Text("No vendors found."));
            }
            return ListView.builder(
              itemCount: _filteredVendors.length,
              itemBuilder: (context, index) {
                final vendor = _filteredVendors[index];
                final originalIndex = _allVendors.indexOf(vendor); 
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text((originalIndex + 1).toString()),
                    ),
                    title: Text(vendor.name1),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vendor No: ${vendor.lifnr}"),
                        if (vendor.email.isNotEmpty)
                          Text("Email: ${vendor.email}"),
                      ],
                    ),
                    trailing: vendor.email.isNotEmpty
                        ? Icon(Icons.email, color: Colors.blue)
                        : null,
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No vendors found."));
          }
        },
      ),
    );
  }
}
