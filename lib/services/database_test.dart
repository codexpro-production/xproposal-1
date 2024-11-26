import 'user_service.dart';

class DatabaseTest {
  final UserService userDBService = UserService();

  // Test CRUD operations
  Future<void> runTests() async {
    await userDBService.connect();

    print("\n--- Running Database Tests ---\n");

    // 1. Create a document
    print("Creating a document...");
    await userDBService.createDocument({
      'user_vendor': 'Vendor Name',
      'user_responsible': 'Responsible Name'
    });

    // 2. Read all documents
    print("Reading all documents...");
    final documents = await userDBService.readDocuments();
    print("Documents: $documents");

    // 3. Update a document
    print("Updating a document...");
    await userDBService.updateDocument(
        {'user_vendor': 'Vendor Name'}, {'\$set': {'user_responsible': 'New Name'}});

    // 4. Delete a document
    print("Deleting a document...");
    await userDBService.deleteDocument({'user_vendor': 'Vendor Name'});

    await userDBService.disconnect();

    print("\n--- Database Tests Completed ---\n");
  }
}
