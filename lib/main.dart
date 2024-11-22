import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';
import 'screens/password_reset_screen.dart';
import 'screens/password_setup_screen.dart';
import 'screens/register_screen.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/passwordReset': (context) => PasswordResetScreen(email: 'aaaaa',),
        '/passwordSetup': (context) => PasswordSetupScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
