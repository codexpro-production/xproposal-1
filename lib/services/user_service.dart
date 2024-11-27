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
    try {
      db = Db(uri);  // Initialize the Db object with the connection string
      await db.open();  // Open the connection to MongoDB
      collection = db.collection(collectionName);  // Get the collection
      print("Connected to MongoDB");
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  // Insert a document
  Future<void> createDocument(Map<String, dynamic> document) async {
    try {
      // Optionally add or modify fields as needed, e.g., 'responsible'
      document['responsible'] = 123;  // Set a default value for 'responsible' field
      document['purchaseGroupText'] = Int64(123123123123);  // Set a NumberLong field

      await collection.insert(document);  // Insert the document into the collection
      print("Document inserted: $document");
    } catch (e) {
      print("Error inserting document: $e");
    }
  }

  // Retrieve all documents
  Future<List<Map<String, dynamic>>> readDocuments() async {
    try {
      final documents = await collection.find().toList();  // Get all documents
      print("Documents retrieved: $documents");
      return documents;  // Return the list of documents
    } catch (e) {
      print("Error retrieving documents: $e");
      return [];
    }
  }

  // Find a document by a field (example: by name)
  Future<void> findDocument(String fieldName, String fieldValue) async {
    try {
      final query = where.eq(fieldName, fieldValue);  // Query filter
      final result = await collection.findOne(query);  // Find a single document
      if (result != null) {
        print('Found document: $result');
      } else {
        print('Document not found');
      }
    } catch (e) {
      print("Error finding document: $e");
    }
  }

  // Update a document
  Future<void> updateDocument(
      Map<String, dynamic> filter, Map<String, dynamic> updates) async {
    try {
      await collection.update(filter, updates);  // Update document based on filter
      print("Document updated: filter=$filter, updates=$updates");
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  // Delete a document
  Future<void> deleteDocument(Map<String, dynamic> filter) async {
    try {
      await collection.remove(filter);  // Remove document based on filter
      print("Document deleted: $filter");
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  // Close the MongoDB connection
  Future<void> disconnect() async {
    try {
      await db.close();  // Close the connection to MongoDB
      print("Disconnected from MongoDB");
    } catch (e) {
      print("Error disconnecting from MongoDB: $e");
    }
  }
}
