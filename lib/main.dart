import 'package:flutter/material.dart';
import 'screens/PDFViewerScreen.dart';
import 'screens/login_screen.dart';
import 'screens/password_reset_screen.dart';
import 'screens/password_setup_screen.dart';
import 'screens/register_screen.dart';
import 'screens/vendor_list_screen.dart';
import 'screens/database_test_screen.dart';
import 'screens/home_screen.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/passwordReset': (context) => PasswordResetScreen(),
        '/passwordSetup': (context) => PasswordSetupScreen(),
        '/register': (context) => RegisterScreen(),
        '/vendorList': (context) => VendorListScreen(),
        // '/pdfViewer': (context) => PDFViewerScreen(),
        // '/deneme': (context) => HomeScreen(),
        
      },
    );
  }
}
