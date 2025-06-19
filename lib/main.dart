import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/confirm_code_screen.dart';
import 'package:flutter_application_3/screens/home_screen.dart';
import 'package:flutter_application_3/screens/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/confirm': (_) => const ConfirmCodeScreen(),
        '/home': (_) => const HomeScreen()
      },
    );
  }
}

