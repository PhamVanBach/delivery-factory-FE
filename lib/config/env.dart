import 'package:flutter/foundation.dart';

class Environment {
  static const String _devApiUrl = 'http://localhost:5000/api';
  static const String _prodApiUrl =
      'https://delivery-factory-api.example.com/api';

  static String get apiUrl {
    if (kReleaseMode) {
      return _prodApiUrl;
    }
    return _devApiUrl;
  }

  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Feature flags
  static const bool enableAnalytics = kReleaseMode;
  static const bool enableCrashReporting = kReleaseMode;

  // Cache configuration
  static const int cacheDuration = 86400; // 24 hours in seconds

  // Pagination defaults
  static const int defaultPageSize = 10;

  // App settings
  static const String appName = 'Delivery Factory';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_data';

  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String productsEndpoint = '/products';
  static const String ordersEndpoint = '/orders';
  static const String cartEndpoint = '/cart';

  // Payment gateway settings
  static const String stripePublishableKey = 'pk_test_your_key_here';

  // Options for testing
  static bool mockApiResponses = false;
}
