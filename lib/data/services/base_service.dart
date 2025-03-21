import 'dart:convert';
import 'package:delivery_factory_app/core/logging/index.dart';
import 'package:delivery_factory_app/presentation/controllers/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getx;
import 'package:delivery_factory_app/config/env.dart';

enum HttpMethod { get, post, put, patch, delete }

class ApiBaseService {
  final Dio _dio = Dio();

  final Logger _logger = AppLogger().getLoggerForClass(ApiBaseService);

  ApiBaseService() {
    _dio.options.baseUrl = Environment.apiUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add request interceptor for auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Try to get the auth controller
          AuthController? authController;
          try {
            authController = getx.Get.find<AuthController>();
          } catch (e) {
            // Auth controller not found, proceed without token
          }

          // Add auth token if available
          if (authController != null && authController.token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${authController.token}';
          }

          // Log the request
          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log the response
          _logger.d(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Log the error
          _logger.e(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );

          // Handle authentication errors
          if (e.response?.statusCode == 401) {
            _handleAuthError();
          }

          return handler.next(e);
        },
      ),
    );

    // Add logging interceptor for debugging
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  Future<T> request<T>({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) onSuccess,
    Function(DioException error)? onError,
  }) async {
    try {
      late Response response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(endpoint, queryParameters: queryParameters);
          break;
        case HttpMethod.post:
          response = await _dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.put:
          response = await _dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.patch:
          response = await _dio.patch(
            endpoint,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.delete:
          response = await _dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
          );
          break;
      }

      return onSuccess(response.data);
    } on DioException catch (e) {
      if (onError != null) {
        return onError(e);
      }

      // Handle error based on status code
      switch (e.response?.statusCode) {
        case 400:
          throw ApiException(
            message: _getErrorMessage(e) ?? 'Bad request',
            statusCode: 400,
            data: e.response?.data,
          );
        case 401:
          throw ApiException(
            message: 'Unauthorized',
            statusCode: 401,
            data: e.response?.data,
          );
        case 403:
          throw ApiException(
            message: 'Forbidden',
            statusCode: 403,
            data: e.response?.data,
          );
        case 404:
          throw ApiException(
            message: 'Not found',
            statusCode: 404,
            data: e.response?.data,
          );
        case 500:
        case 501:
        case 502:
        case 503:
          throw ApiException(
            message: 'Server error',
            statusCode: e.response?.statusCode ?? 500,
            data: e.response?.data,
          );
        default:
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.sendTimeout) {
            throw ApiException(
              message: 'Connection timeout',
              statusCode: 0,
              data: null,
            );
          } else if (e.type == DioExceptionType.unknown &&
              e.error != null &&
              e.error.toString().contains('SocketException')) {
            throw ApiException(
              message: 'No internet connection',
              statusCode: 0,
              data: null,
            );
          } else {
            throw ApiException(
              message: 'Something went wrong',
              statusCode: 0,
              data: e.response?.data,
            );
          }
      }
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0, data: null);
    }
  }

  String? _getErrorMessage(DioException error) {
    if (error.response?.data == null) {
      return null;
    }

    try {
      if (error.response!.data is Map) {
        final Map<String, dynamic> data = error.response!.data;

        // Check for common error response formats
        if (data.containsKey('message')) {
          return data['message'];
        } else if (data.containsKey('error')) {
          return data['error'];
        } else if (data.containsKey('errors')) {
          if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
            final errors = data['errors'] as List;
            return errors.map((e) => e['msg']).join(', ');
          } else if (data['errors'] is Map) {
            return (data['errors'] as Map).values.join(', ');
          }
        }
      } else if (error.response!.data is String) {
        // Try to parse as JSON first
        try {
          final data = jsonDecode(error.response!.data);
          if (data is Map && data.containsKey('message')) {
            return data['message'];
          }
        } catch (_) {
          // Not a JSON string, return as is
          return error.response!.data;
        }
      }
    } catch (_) {
      // Error parsing the error message
    }

    return null;
  }

  void _handleAuthError() {
    // Try to get the auth controller
    try {
      final AuthController authController = getx.Get.find<AuthController>();
      authController.signOut();
    } catch (e) {
      // Auth controller not found
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  ApiException({required this.message, required this.statusCode, this.data});

  @override
  String toString() => message;
}
