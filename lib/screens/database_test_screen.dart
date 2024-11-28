// import 'package:flutter/material.dart';
// import 'package:bson/bson.dart';
// import '../services/user_service.dart';

// class DatabaseTestScreen extends StatefulWidget {
//   const DatabaseTestScreen({super.key});

//   @override
//   _DatabaseTestScreenState createState() => _DatabaseTestScreenState();
// }

// class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
//   final UserService userService = UserService();
//   List<Map<String, dynamic>> documents = [];

//   @override
//   void initState() {
//     super.initState();
//     connectToDatabase();
//   }

//   // Connect to the database
//   Future<void> connectToDatabase() async {
//     await userService.connect();
//     setState(() {
//       // Optionally update state if required, e.g., indicating database connected
//     });
//   }

//   // Disconnect from the database when the widget is disposed
//   @override
//   void dispose() {
//     userService.disconnect();
//     super.dispose();
//   }

//   // CRUD operations
//   Future<void> createDocument() async {
//     await userService.createDocument({
//       'purchaseGroup': '',
//       'purchaseGroupText': 0,
//       'telNumber': 0,
//       'faxNumber': 0,
//       'responsible': 123,
//       'email': '',
//       'password': '',
//     });
//     showMessage("Document created successfully.");
//   }

//   Future<void> readDocuments() async {
//     final results = await userService.readDocuments();
//     setState(() {
//       documents = results;
//     });
//     showMessage("Documents retrieved successfully.");
//   }

//   Future<void> updateDocument() async {
//     await userService.updateDocument(
//         {'purchaseGroup': ''}, {'\$set': {'responsible': 456}});
//     showMessage("Document updated successfully.");
//   }

//   Future<void> deleteDocument() async {
//     await userService.deleteDocument({'purchaseGroup': ''});
//     showMessage("Document deleted successfully.");
//   }

//   // Helper method to show messages
//   void showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Database Test Screen"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: createDocument,
//               child: Text("Create Document"),
//             ),
//             ElevatedButton(
//               onPressed: readDocuments,
//               child: Text("Read Documents"),
//             ),
//             ElevatedButton(
//               onPressed: updateDocument,
//               child: Text("Update Document"),
//             ),
//             ElevatedButton(
//               onPressed: deleteDocument,
//               child: Text("Delete Document"),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "Retrieved Documents:",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: documents.length,
//                 itemBuilder: (context, index) {
//                   final document = documents[index];
//                   return ListTile(
//                     title: Text(document['purchaseGroup'] ?? 'No Group'),
//                     subtitle: Text(
//                       'Responsible: ${document['responsible'] ?? 'No Responsible'}',
//                     ),
//                     // You can format any other fields as needed
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
