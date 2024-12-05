import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = {
      'Login': '/login',
      'Password Reset': '/passwordReset',
      'Register': '/register',
      'Vendor List': '/vendorList',
      'XProposal': '/xproposal',
      'PDF Printer': '/pdfPrinter',
      'Responsible': '/responsible',
      'Announcements': '/announcements',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final routeName = routes.keys.elementAt(index);
          final routePath = routes.values.elementAt(index);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.lightBlue[100],
                foregroundColor: Colors.black, // Text color
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pushNamed(context, routePath);
              },
              child: Text(routeName, style: const TextStyle(fontSize: 16)),
            ),
          );
        },
      ),
    );
  }
}