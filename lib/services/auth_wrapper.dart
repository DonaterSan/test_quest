import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/auth_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // void forceLogout(WidgetRef ref) async {
    // final authService = AuthService();
    // await authService.logout();
    // ref.read(authProvider.notifier).setLoggedOut();
    // }
    //forceLogout(ref);

    if (authState == AuthStatus.loggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
