import 'dart:convert';
import 'package:delivery_factory_app/config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_service.dart';

class AuthService extends ApiBaseService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await request<Map<String, dynamic>>(
      endpoint: '${Environment.authEndpoint}/login',
      method: HttpMethod.post,
      data: {'email': email, 'password': password},
      onSuccess: (data) {
        _saveAuthData(data);
        return data;
      },
    );
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    return await request<Map<String, dynamic>>(
      endpoint: '${Environment.authEndpoint}/register',
      method: HttpMethod.post,
      data: {'name': name, 'email': email, 'password': password},
      onSuccess: (data) {
        _saveAuthData(data);
        return data;
      },
    );
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    return await request<Map<String, dynamic>>(
      endpoint: '${Environment.authEndpoint}/user',
      method: HttpMethod.get,
      onSuccess: (data) => data,
    );
  }

  Future<bool> verifyToken() async {
    try {
      await getUserProfile();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Environment.tokenKey);
    await prefs.remove(Environment.userKey);
  }

  void _saveAuthData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    if (data.containsKey('token')) {
      await prefs.setString(Environment.tokenKey, data['token']);
    }

    if (data.containsKey('user')) {
      final userData = data['user'];
      if (userData is Map<String, dynamic>) {
        await prefs.setString(Environment.userKey, jsonEncode(userData));
      }
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Environment.tokenKey);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(Environment.userKey);

    if (userJson != null) {
      try {
        return jsonDecode(userJson) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }

    return null;
  }
}
