// lib/core/services/token_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_factory_app/core/network/api_service.dart';
import 'package:delivery_factory_app/core/logging/index.dart';

class TokenService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  final Logger _logger = AppLogger().getLoggerForClass(TokenService);
  final ApiService _apiService;

  TokenService(this._apiService);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  Future<String?> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);

      if (refreshToken == null) {
        return null;
      }

      final response = await _apiService.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response['access_token'];
      final newRefreshToken = response['refresh_token'];

      await saveTokens(newAccessToken, newRefreshToken);
      return newAccessToken;
    } catch (e) {
      _logger.e('Failed to refresh token', e);
      return null;
    }
  }
}
