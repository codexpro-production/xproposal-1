import 'package:flutter/material.dart';
import '../services/user_service.dart';

class DatabaseTestScreen extends StatefulWidget {
  @override
  _DatabaseTestScreenState createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  final UserService userService = UserService();
  List<Map<String, dynamic>> documents = [];

  @override
  void initState() {
    super.initState();
    connectToDatabase();
  }

  // Connect to the database
  Future<void> connectToDatabase() async {
    await userService.connect();
    setState(() {
      // State update for initial connection if needed
    });
  }

  // Disconnect from the database when the widget is disposed
  @override
  void dispose() {
    userService.disconnect();
    super.dispose();
  }

  // CRUD operations
  Future<void> createDocument() async {
    await userService.createDocument({
      'user_vendor': 'Vendor Name',
      'user_responsible': 'Responsible Name'
    });
    showMessage("Document created successfully.");
  }

  Future<void> readDocuments() async {
    final results = await userService.readDocuments();
    setState(() {
      documents = results;
    });
    showMessage("Documents retrieved successfully.");
  }

  Future<void> updateDocument() async {
    await userService.updateDocument(
        {'user_vendor': 'Vendor Name'}, {'\$set': {'user_responsible': 'New Name'}});
    showMessage("Document updated successfully.");
  }

  Future<void> deleteDocument() async {
    await userService.deleteDocument({'user_vendor': 'Vendor Name'});
    showMessage("Document deleted successfully.");
  }

  // Helper method to show messages
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database Test Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: createDocument,
              child: Text("Create Document"),
            ),
            ElevatedButton(
              onPressed: readDocuments,
              child: Text("Read Documents"),
            ),
            ElevatedButton(
              onPressed: updateDocument,
              child: Text("Update Document"),
            ),
            ElevatedButton(
              onPressed: deleteDocument,
              child: Text("Delete Document"),
            ),
            SizedBox(height: 20),
            Text(
              "Retrieved Documents:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  return ListTile(
                    title: Text(document['user_vendor'] ?? 'No Vendor'),
                    subtitle: Text(document['user_responsible'] ?? 'No Responsible'),
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
