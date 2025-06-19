import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_3/screens/confirm_code_screen.dart';
import 'package:flutter_application_3/screens/home_screen.dart';
import 'package:flutter_application_3/screens/login.dart';
import 'package:flutter_application_3/services/auth_wrapper.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const AuthWrapper(),
        '/login': (_) => const LoginScreen(),
        '/confirm': (_) => const ConfirmCodeScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
