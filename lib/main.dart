import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/password_reset_screen.dart';
import 'screens/password_setup_screen.dart';
import 'screens/register_screen.dart';
import 'screens/vendor_list_screen.dart';
import 'screens/pdf_printer_screen.dart';
import 'screens/xproposal_screen.dart';
import 'screens/responsible_screen.dart';
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XPROPOSAL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/passwordReset': (context) => PasswordResetScreen(),
        '/register': (context) => RegisterScreen(),
        '/vendorList': (context) => VendorListScreen(),
        '/xproposal': (context) => XProposalScreen(),
        '/pdfPrinter': (context) => PDFPrinterScreen(),
        '/responsible': (context) => ResponsibleScreen(),
        //'/setup-password': (context) => PasswordSetupScreen(token: ''),
      },
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/setup-password') == true) {
          final uri = Uri.parse(settings.name!);
          final token = uri.queryParameters['token'];
          if (token != null) {
            return MaterialPageRoute(
              builder: (_) => PasswordSetupScreen(token: token),
            );
          }
        }
        return null; //404
      },
    );
  }
}
