import 'package:flutter/material.dart';
import '../services/user_service.dart';

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  _DatabaseTestScreenState createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  final UserService userService = UserService(); // Replace with ApiService if using HTTP
  List<Map<String, dynamic>> documents = [];

  @override
  void initState() {
    super.initState();
    fetchDocuments(); // Fetch documents on initialization
  }

  // CRUD Operations
  Future<void> createDocument() async {
    await userService.createDocument({
      'purchaseGroup': 'Group A',
      'purchaseGroupText': 'Description A',
      'telNumber': 1234567890,
      'faxNumber': 9876543210,
      'responsible': 123,
      'email': 'test@example.com',
      'password': 'password123',
    });
    showMessage("Document created successfully.");
    fetchDocuments(); // Refresh documents list
  }

  Future<void> fetchDocuments() async {
    final results = await userService.readDocuments();
    setState(() {
      documents = results;
    });
    showMessage("Documents retrieved successfully.");
  }

  Future<void> updateDocument(String id) async {
    await userService.updateDocument(id, {
      'purchaseGroupText': 'Updated Description',
      'responsible': 456,
    });
    showMessage("Document updated successfully.");
    fetchDocuments(); // Refresh documents list
  }

  Future<void> deleteDocument(String id) async {
    await userService.deleteDocument(id);
    showMessage("Document deleted successfully.");
    fetchDocuments(); // Refresh documents list
  }

  // Helper method to show messages
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database Test Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: createDocument,
              child: const Text("Create Document"),
            ),
            ElevatedButton(
              onPressed: fetchDocuments,
              child: const Text("Read Documents"),
            ),
            const SizedBox(height: 20),
            Text(
              "Retrieved Documents:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: documents.isEmpty
                  ? const Center(child: Text("No documents found."))
                  : ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        return ListTile(
                          title: Text(document['purchaseGroup'] ?? 'No Group'),
                          subtitle: Text(
                            'Responsible: ${document['responsible'] ?? 'No Responsible'}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  updateDocument(document['_id']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteDocument(document['_id']);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
