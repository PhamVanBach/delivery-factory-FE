// lib/core/config/api_config.dart
enum Environment { development, staging, production }

class ApiConfig {
  static Environment environment = Environment.development;

  static String get baseUrl {
    switch (environment) {
      case Environment.development:
        return 'https://dev-api.deliveryfactory.com/api';
      case Environment.staging:
        return 'https://staging-api.deliveryfactory.com/api';
      case Environment.production:
        return 'https://api.deliveryfactory.com/api';
    }
  }

  static const int connectionTimeout = 15000; // 15 seconds
  static const int receiveTimeout = 15000; // 15 seconds

  // API endpoints
  static const String ordersEndpoint = '/orders';
  static const String usersEndpoint = '/users';
  static const String authEndpoint = '/auth';

  // API version
  static const String apiVersion = 'v1';

  // Get full endpoint URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl/$apiVersion$endpoint';
  }
}
