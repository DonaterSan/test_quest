import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userId;
  bool isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
  try {
    final fetchedUserId = await _authService.getUserId();
    if (!mounted) return; 
    setState(() {
      userId = fetchedUserId;
      isLoading = false;
    });
  } catch (e) {
    if (!mounted) return; 
    setState(() {
      userId = null;
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Добро пожаловать')),
      body: Center(
        child: userId == null
            ? const Text(
                'Ошибка: пользователь не найден',
                style: TextStyle(fontSize: 18, color: Colors.red),
              )
            : Text(
                'Вы авторизованы!\nВаш ID: $userId',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
      ),
    );
  }
}

