import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/purchase_responsible.dart';

class PurchaseResponsibleScreen extends StatefulWidget {
  const PurchaseResponsibleScreen({super.key});

  @override
  State<PurchaseResponsibleScreen> createState() => _PurchaseResponsibleScreenState();
}

class _PurchaseResponsibleScreenState extends State<PurchaseResponsibleScreen> {
  late Future<List<PurchaseResponsible>> _responsibles;
  List<PurchaseResponsible> _allResponsibles = [];
  List<PurchaseResponsible> _filteredResponsibles = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  Future<List<PurchaseResponsible>> fetchResponsibles() async {
    try {
      final String response =
          await rootBundle.loadString('../assets/JSONs/PURCHASE_RESPONSIBLE_LIST.json');
      final List<dynamic> data = jsonDecode(response);
      return data.map((json) => PurchaseResponsible.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error loading or parsing JSON data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _responsibles = fetchResponsibles();
    _responsibles.then((value) {
      setState(() {
        _allResponsibles = value;
        _filteredResponsibles = _allResponsibles;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredResponsibles = _allResponsibles.where((responsible) {
        return responsible.purchaseGroup.toLowerCase().contains(query) ||
            responsible.purchaseGroupText.toLowerCase().contains(query) ||
            responsible.responsible.toString().contains(query);
      }).toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredResponsibles = _allResponsibles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Geri alma butonunu kaldırır
        title: !_isSearching
            ? null // "Purchase Responsible List" başlığını kaldırır
            : TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search by Group or Responsible",
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
      body: FutureBuilder<List<PurchaseResponsible>>(
        future: _responsibles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (_filteredResponsibles.isEmpty) {
              return const Center(child: Text("No purchase responsibles found."));
            }
            return ListView.builder(
              itemCount: _filteredResponsibles.length,
              itemBuilder: (context, index) {
                final responsible = _filteredResponsibles[index];
                final originalIndex = _allResponsibles.indexOf(responsible);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text((originalIndex + 1).toString()),
                    ),
                    title: Text(responsible.purchaseGroup),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Group Text: ${responsible.purchaseGroupText}"),
                        Text("Responsible: ${responsible.responsible}"),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No purchase responsibles found."));
          }
        },
      ),
    );
  }
}
