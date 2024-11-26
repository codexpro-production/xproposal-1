import 'package:mongo_dart/mongo_dart.dart';

class UserService {
  final String uri =
      "mongodb+srv://codexpro:utQs8ivHe57WIeI0@cluster0.ts0d7.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
  final String dbName = "Cluster0";
  final String collectionName = "xproposal";

  late Db db;
  late DbCollection collection;

  // Initialize the MongoDB connection
  Future<void> connect() async {
    db = Db(uri);
    await db.open();
    collection = db.collection(collectionName);
    print("Connected to MongoDB");
  }

  // Insert a document
  Future<void> createDocument(Map<String, dynamic> document) async {
    try {
      await collection.insert(document);
      print("Document inserted: $document");
    } catch (e) {
      print("Error inserting document: $e");
    }
  }

  // Retrieve all documents
  Future<List<Map<String, dynamic>>> readDocuments() async {
    try {
      final documents = await collection.find().toList();
      print("Documents retrieved: $documents");
      return documents;
    } catch (e) {
      print("Error retrieving documents: $e");
      return [];
    }
  }

  // Update a document
  Future<void> updateDocument(
      Map<String, dynamic> filter, Map<String, dynamic> updates) async {
    try {
      await collection.update(filter, updates);
      print("Document updated: filter=$filter, updates=$updates");
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  // Delete a document
  Future<void> deleteDocument(Map<String, dynamic> filter) async {
    try {
      await collection.remove(filter);
      print("Document deleted: $filter");
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  // Close the connection
  Future<void> disconnect() async {
    await db.close();
    print("Disconnected from MongoDB");
  }
}
