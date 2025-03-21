import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Controllers
import 'package:delivery_factory_app/presentation/controllers/auth_controller.dart';
import 'package:delivery_factory_app/presentation/controllers/cart_controller.dart';
import 'package:delivery_factory_app/presentation/controllers/order_controller.dart';
import 'package:delivery_factory_app/presentation/controllers/product_controller.dart';

// Services
import 'package:delivery_factory_app/data/services/auth_service.dart';
import 'package:delivery_factory_app/data/services/cart_service.dart';
import 'package:delivery_factory_app/data/services/order_service.dart';
import 'package:delivery_factory_app/data/services/product_service.dart';

class ServiceInjection {
  static Future<void> init() async {
    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put(sharedPreferences, permanent: true);

    // Register services
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<CartService>(() => CartService(), fenix: true);
    Get.lazyPut<OrderService>(() => OrderService(), fenix: true);
    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);

    // Register controllers
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
  }
}
