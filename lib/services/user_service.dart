import '../services/api_service.dart';


class UserService {
  final ApiService apiService = ApiService();

  // Create a document
  Future<void> createDocument(Map<String, dynamic> document) async {
    try {
      await apiService.createDocument(document);
      print('Document created successfully');
    } catch (e) {
      print('Error creating document: $e');
    }
  }

  // Read all documents
  Future<List<Map<String, dynamic>>> readDocuments() async {
    try {
      final documents = await apiService.fetchDocuments();
      print('${documents.length} documents retrieved successfully');
      return documents;
    } catch (e) {
      print('Error reading documents: $e');
      return [];
    }
  }

  // Update a document
  Future<void> updateDocument(String id, Map<String, dynamic> updateData) async {
    try {
      await apiService.updateDocument(id, updateData);
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  // Delete a document
  Future<void> deleteDocument(String id) async {
    try {
      await apiService.deleteDocument(id);
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
