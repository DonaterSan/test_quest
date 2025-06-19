import 'package:dio/dio.dart';
import 'auth_services.dart';

class ApiClient {
  final Dio dio;

  ApiClient(AuthService authService)
      : dio = Dio(BaseOptions(baseUrl: 'https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net')) {
    dio.interceptors.add(_AuthInterceptor(dio, authService));
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio _dio;
  final AuthService _authService;
  bool _isRefreshing = false;

  _AuthInterceptor(this._dio, this._authService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authService.storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      final refreshed = await _authService.refreshToken();
      _isRefreshing = false;

      if (refreshed) {
        final request = err.requestOptions;
        final newToken = await _authService.storage.getAccessToken();
        if (newToken != null) {
          request.headers['Authorization'] = 'Bearer $newToken';
          final cloneReq = await _dio.fetch(request);
          return handler.resolve(cloneReq);
        }
      } else {
        await _authService.logout();
      }
    }
    handler.next(err);
  }
}

