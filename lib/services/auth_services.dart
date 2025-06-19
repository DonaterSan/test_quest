import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import 'dart:convert';

class AuthService {
  final TokenStorage _storage = TokenStorage();

  TokenStorage get storage => _storage;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  bool _isTokenValid(String token) {
    try {
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
      );
      final exp = payload['exp'];
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return exp != null && exp > now;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkAuthStatus() async {
  final accessToken = await _storage.getAccessToken();

  if (accessToken != null && _isTokenValid(accessToken)) {
    return true;
  }

  return false;
}



  Future<void> sendEmail(String email) async {
    await _dio.post('/login', data: {'email': email});
  }

  Future<bool> loginWithCode(String email, String code) async {
    final response = await _dio.post('/confirm_code', data: {
      'email': email,
      'code': code,
    });
 
    if (response.statusCode == 200) {
      final data = response.data;
      final jwt = data['jwt'];
      final rt = data['refresh_token'];

      if (jwt == null || rt == null) {
        throw Exception('Сервер не вернул токены');
      }

      await _storage.saveAccessToken(jwt);
      await _storage.saveRefreshToken(rt);


      if (data.containsKey('user_id')) {
        await _storage.saveUserId(data['user_id'].toString());
      } else {
        final userId = await getUserId();
        if (userId != null) {
          await _storage.saveUserId(userId);
        }
      }

      return true;
    }
    return false;
  }

  Future<bool> refreshToken() async {
    final rt = await _storage.getRefreshToken();
    if (rt == null) return false;

    try {
      final response = await _dio.post('/refresh_token', data: {'token': rt});
      if (response.statusCode == 200) {
        final data = response.data;
        await _storage.saveAccessToken(data['accessToken']);
        await _storage.saveRefreshToken(data['refreshToken']);
        return true;
      }
    } catch (_) {}

    return false;
  }

  Future<String?> getUserId() async {
    final token = await _storage.getAccessToken();
    if (token == null){
      return null;
    } 

    try {
      final response = await _dio.get(
        '/auth',
        options: Options(headers: {'Auth': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return response.data['user_id']?.toString();
      }
      } catch (_) {}
    
    return null;
  }

  Future<void> logout() async {
    await _storage.clearTokens();
  }
}
