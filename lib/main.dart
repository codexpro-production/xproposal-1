import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/password_reset_screen.dart';
import 'screens/password_setup_screen.dart';
import 'screens/register_screen.dart';
import 'screens/vendor_list_screen.dart';
import 'screens/database_test_screen.dart';
<<<<<<< HEAD
import 'screens/home_screen.dart';
=======
import 'screens/pdf_printer_screen.dart';
>>>>>>> 602567e93840a3ef4ddac432c5c698026683813a

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAP User Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
<<<<<<< HEAD
      initialRoute: '/',
=======
      initialRoute: '/pdfPrinter',
>>>>>>> 602567e93840a3ef4ddac432c5c698026683813a
      routes: {
        '/': (context) => LoginScreen(),
        '/passwordReset': (context) => PasswordResetScreen(),
        '/passwordSetup': (context) => PasswordSetupScreen(),
        '/register': (context) => RegisterScreen(),
        '/vendorList': (context) => VendorListScreen(),
<<<<<<< HEAD
        // '/pdfViewer': (context) => PDFViewerScreen(),
        // '/deneme': (context) => HomeScreen(),
        
=======
        '/pdfPrinter': (context) => PDFPrinterScreen(),
        '/databaseTest': (context) => DatabaseTestScreen(),
>>>>>>> 602567e93840a3ef4ddac432c5c698026683813a
      },
    );
  }
}
