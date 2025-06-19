import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_services.dart';
import '../providers/auth_provider.dart';

class ConfirmCodeScreen extends ConsumerStatefulWidget {
  const ConfirmCodeScreen({super.key});

  @override
  ConsumerState<ConfirmCodeScreen> createState() => _ConfirmCodeScreenState();
}

class _ConfirmCodeScreenState extends ConsumerState<ConfirmCodeScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  bool _isLoading = false;
  late String email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      email = args;
    } else {
      email = '';
    }
  }

  void _submitCode() async {
    final code = _codeController.text.trim();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final success = await _authService.loginWithCode(email, code);

      if (!mounted) return;

      if (success) {
        final userId = await _authService.getUserId();
        debugPrint('User ID: $userId');

        ref.read(authProvider.notifier).setLoggedIn();

        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false, arguments: userId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверный код подтверждения'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Введите код')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'Мы отправили код на: $email',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите код';
                  if (value.length < 4) return 'Минимум 4 цифры';
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Код из email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitCode,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Продолжить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

