import 'package:dio/dio.dart';
import 'package:delivery_factory_app/core/logging/index.dart';
import 'package:delivery_factory_app/core/config/api_config.dart';
import 'package:delivery_factory_app/core/services/token_service.dart';
import 'package:delivery_factory_app/core/network/auth_interceptor.dart';

class ApiService {
  final Dio _dio = Dio();
  final Logger _logger = AppLogger().getLoggerForClass(ApiService);

  ApiService() {
    _dio.options.baseUrl = ApiConfig.getFullUrl('');
    _dio.options.connectTimeout = Duration(
      milliseconds: ApiConfig.connectionTimeout,
    );
    _dio.options.receiveTimeout = Duration(
      milliseconds: ApiConfig.receiveTimeout,
    );

    // Add request logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (object) => _logger.d(object.toString()),
      ),
    );
  }

  void addAuthInterceptor(TokenService tokenService) {
    _dio.interceptors.add(AuthInterceptor(tokenService));
  }

  // GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      _logger.i('GET request to $endpoint');
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      _logger.i('POST request to $endpoint');
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, {dynamic data}) async {
    try {
      _logger.i('PUT request to $endpoint');
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      _logger.i('DELETE request to $endpoint');
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // Error handling
  void _handleError(DioException e) {
    _logger.e('API Error: ${e.message}', e);

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Connection timed out');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          throw UnauthorizedException('Unauthorized');
        } else if (statusCode == 404) {
          throw NotFoundException('Resource not found');
        } else {
          throw ApiException('Server error: ${e.response?.statusCode}');
        }
      case DioExceptionType.connectionError:
        throw NoConnectionException('No internet connection');
      default:
        throw ApiException('Unknown error occurred');
    }
  }
}

// Custom exceptions
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class TimeoutException extends ApiException {
  TimeoutException(super.message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}

class NoConnectionException extends ApiException {
  NoConnectionException(super.message);
}
