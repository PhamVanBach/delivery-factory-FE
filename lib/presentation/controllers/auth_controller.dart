import 'package:delivery_factory_app/core/logging/index.dart';
import 'package:delivery_factory_app/data/services/auth_service.dart';
import 'package:delivery_factory_app/domain/models/user.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Logger _logger = AppLogger().getLoggerForClass(AuthController);

  final Rx<User?> user = Rx<User?>(null);
  final RxString token = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  bool get isLoggedIn => token.isNotEmpty && user.value != null;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    error.value = '';

    try {
      final storedToken = await _authService.getToken();
      if (storedToken != null && storedToken.isNotEmpty) {
        token.value = storedToken;

        // Get user data from storage
        final userData = await _authService.getUser();
        if (userData != null) {
          user.value = User.fromJson(userData);
        }

        // Verify token validity with the server
        if (await _authService.verifyToken()) {
          // Token is valid, fetch latest user profile
          await refreshUserProfile();
        } else {
          // Token is invalid, sign out
          await signOut();
        }
      }
    } catch (e) {
      _logger.e('Error loading user data: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    isLoading.value = true;
    error.value = '';

    try {
      final response = await _authService.login(email, password);

      if (response.containsKey('token')) {
        token.value = response['token'];
      }

      if (response.containsKey('user')) {
        user.value = User.fromJson(response['user']);
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      _logger.e('Login error: $e');
      error.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    isLoading.value = true;
    error.value = '';

    try {
      final response = await _authService.register(name, email, password);

      if (response.containsKey('token')) {
        token.value = response['token'];
      }

      if (response.containsKey('user')) {
        user.value = User.fromJson(response['user']);
      }

      isLoading.value = false;
      return true;
    } catch (e) {
      _logger.e('Registration error: $e');
      error.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.logout();
      token.value = '';
      user.value = null;

      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      _logger.e('Logout error: $e');
      error.value = e.toString();
    }
  }

  Future<void> refreshUserProfile() async {
    try {
      final userData = await _authService.getUserProfile();
      user.value = User.fromJson(userData);
    } catch (e) {
      _logger.e('Error refreshing user profile: $e');

      // If we get an auth error, sign out
      if (e.toString().contains('Unauthorized')) {
        await signOut();
      }
    }
  }

  bool get isCustomer => user.value?.role == 'customer';
  bool get isVendor =>
      user.value?.role == 'vendor' || (user.value?.isVendor ?? false);
  bool get isAdmin => user.value?.role == 'admin';

  String get userName => user.value?.name ?? 'Guest';
  String get userEmail => user.value?.email ?? '';
  String? get userId => user.value?.id;
  String? get profileImage => user.value?.profileImage;

  List<Map<String, dynamic>> get userAddresses {
    if (user.value == null || user.value!.addresses == null) {
      return [];
    }
    return user.value!.addresses!;
  }

  Map<String, dynamic>? get defaultAddress {
    final addresses = userAddresses;
    if (addresses.isEmpty) return null;

    // Find default address
    final defaultAddr = addresses.firstWhereOrNull(
      (addr) => addr['isDefault'] == true,
    );

    return defaultAddr ?? addresses.first;
  }
}
