import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late Future<List<dynamic>> _announcements;
  List<dynamic> _allAnnouncements = [];
  List<dynamic> _filteredAnnouncements = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  Future<List<dynamic>> fetchAnnouncements() async {
    try {
      final String response = await rootBundle.loadString('assets/JSONs/ANNOUNCEMENTS.json');
      return jsonDecode(response);
    } catch (e) {
      throw Exception("Error loading or parsing JSON data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _announcements = fetchAnnouncements();
    _announcements.then((value) {
      setState(() {
        _allAnnouncements = value;
        _filteredAnnouncements = _allAnnouncements;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredAnnouncements = _allAnnouncements.where((announcement) {
        return announcement['description'].toLowerCase().contains(query) ||
            announcement['purchaseRequsitionNumber'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredAnnouncements = _allAnnouncements;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.lightBlue, // Set AppBar color to light blue
        title: !_isSearching
            ? const Text('Announcements')
            : TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by Description or Requisition Number',
                  border: InputBorder.none,
                ),
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
      body: FutureBuilder<List<dynamic>>(
        future: _announcements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (_filteredAnnouncements.isEmpty) {
              return const Center(child: Text("No announcements found."));
            }
            return ListView.builder(
              itemCount: _filteredAnnouncements.length,
              itemBuilder: (context, index) {
                final announcement = _filteredAnnouncements[index];
                final items = announcement['items'] as List<dynamic>;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ExpansionTile(
                    title: Text(announcement['description']),
                    subtitle: Text("Req. No: ${announcement['purchaseRequsitionNumber']}"),
                    children: items.map((item) {
                      return ListTile(
                        title: Text("Item No: ${item['itemNo']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Material: ${item['materialDescription']}"),
                            Text("Quantity: ${item['quantity']} ${item['unitOfMeasure']}"),
                            Text("Delivery: ${item['deliveryDate']} to ${item['deliveryLocation']}"),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No announcements found."));
          }
        },
      ),
    );
  }
}
