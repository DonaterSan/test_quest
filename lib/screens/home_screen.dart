import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добро пожаловать'),
      ),
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
