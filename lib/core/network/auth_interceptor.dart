// lib/core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:delivery_factory_app/core/services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService _tokenService;
  
  AuthInterceptor(this._tokenService);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip adding token for authentication endpoints
    if (options.path.contains('/auth/login') || 
        options.path.contains('/auth/register')) {
      return handler.next(options);
    }
    
    final token = await _tokenService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors (token expired)
    if (err.response?.statusCode == 401) {
      // Try to refresh the token
      try {
        final newToken = await _tokenService.refreshToken();
        if (newToken != null) {
          // Retry the request with the new token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';
          
          final response = await Dio().fetch(opts);
          return handler.resolve(response);
        }
      } catch (e) {
        // Token refresh failed, redirect to login
        _tokenService.clearTokens();
        // You would trigger navigation to login here
      }
    }
    
    return handler.next(err);
  }
}