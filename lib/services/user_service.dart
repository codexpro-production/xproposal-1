import 'package:mongo_dart/mongo_dart.dart';

class UserService {
  Db? db;
  DbCollection? collection;

  // Connect to MongoDB
  Future<void> connect() async {
    try {
      // Replace with your actual MongoDB URI
      final uri = 'mongodb+srv://codexpro:utQs8ivHe57WIeI0@cluster0.ts0d7.mongodb.net/Cluster0?retryWrites=true&w=majority';
      
      db = await Db.create(uri);
      await db!.open();
      print('Connected to MongoDB');

      // Ensure collection is initialized with 'xproposal' collection
      collection = db!.collection('xproposal'); // 'xproposal' is the existing collection name
    } catch (e) {
      print('Error connecting to MongoDB: $e');
    }
  }

  // Disconnect from MongoDB
  Future<void> disconnect() async {
    await db?.close();
    print('Disconnected from MongoDB');
  }

  // Create a document in the collection
  Future<void> createDocument(Map<String, dynamic> document) async {
    try {
      if (collection == null) {
        print('Collection is not initialized');
        return;
      }

      await collection!.insertOne(document);
      print('Document inserted');
    } catch (e) {
      print('Error inserting document: $e');
    }
  }

  // Read documents from the collection
  Future<List<Map<String, dynamic>>> readDocuments() async {
    try {
      if (collection == null) {
        print('Collection is not initialized');
        return [];
      }

      final results = await collection!.find().toList();
      return results.map((doc) => doc as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error retrieving documents: $e');
      return [];
    }
  }

  // Update a document in the collection
  Future<void> updateDocument(Map<String, dynamic> query, Map<String, dynamic> update) async {
    try {
      if (collection == null) {
        print('Collection is not initialized');
        return;
      }

      await collection!.update(query, update);
      print('Document updated');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  // Delete a document from the collection
  Future<void> deleteDocument(Map<String, dynamic> query) async {
    try {
      if (collection == null) {
        print('Collection is not initialized');
        return;
      }

      await collection!.remove(query);
      print('Document deleted');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
