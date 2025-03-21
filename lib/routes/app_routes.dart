import 'package:get/get.dart';
import 'package:delivery_factory_app/presentation/features/splash/splash_screen.dart';
import 'package:delivery_factory_app/presentation/features/splash/splash_screen.dart';
import 'package:delivery_factory_app/presentation/features/auth/login_screen.dart';
import 'package:delivery_factory_app/presentation/features/auth/register_screen.dart';
import 'package:delivery_factory_app/presentation/features/auth/forgot_password_screen.dart';
import 'package:delivery_factory_app/presentation/features/home/home_screen.dart';
import 'package:delivery_factory_app/presentation/features/cart/cart_screen.dart';
import 'package:delivery_factory_app/presentation/features/checkout/checkout_screen.dart';
import 'package:delivery_factory_app/presentation/features/order/order_confirmation_screen.dart';
import 'package:delivery_factory_app/presentation/features/order/order_list_screen.dart';
import 'package:delivery_factory_app/presentation/features/order/order_detail_screen.dart';
import 'package:delivery_factory_app/presentation/controllers/auth_controller.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String productList = '/products';
  static const String productDetail = '/product/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderList = '/orders';
  static const String orderDetail = '/order/:id';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String addressList = '/profile/addresses';
  static const String addAddress = '/profile/addresses/add';
}

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: AppRoutes.productList, page: () => const ProductListScreen()),
    GetPage(
      name: AppRoutes.productDetail,
      page: () {
        final productId = Get.parameters['id'];
        return ProductDetailScreen(productId: productId ?? '');
      },
    ),
    GetPage(name: AppRoutes.cart, page: () => const CartScreen()),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orderConfirmation,
      page:
          () =>
              OrderConfirmationScreen(orderId: Get.arguments?['orderId'] ?? ''),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orderList,
      page: () => const OrderListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () {
        final orderId = Get.parameters['id'];
        return OrderDetailScreen(orderId: orderId ?? '');
      },
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.addressList,
      page: () => const AddressListScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.addAddress,
      page: () => const AddAddressScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if the user is logged in
    final authController = Get.find<AuthController>();

    if (!authController.isLoggedIn) {
      return const RouteSettings(
        name: AppRoutes.login,
        arguments: {'returnRoute': true},
      );
    }

    return null;
  }
}
