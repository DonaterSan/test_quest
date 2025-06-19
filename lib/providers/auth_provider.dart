import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_services.dart';

enum AuthStatus { loading, loggedIn, loggedOut }

class AuthNotifier extends StateNotifier<AuthStatus> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthStatus.loading){
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await _authService.checkAuthStatus();
    state = isLoggedIn ? AuthStatus.loggedIn : AuthStatus.loggedOut;
  }

  void setLoggedIn() => state = AuthStatus.loggedIn;
  void setLoggedOut(){
    _authService.logout();
    state = AuthStatus.loggedOut;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStatus>((ref) => AuthNotifier(AuthService()));