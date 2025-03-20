// lib/app/bindings/initial_binding.dart
import 'package:get/get.dart';
import 'package:delivery_factory_app/core/controllers/counter_controller.dart';
import 'package:delivery_factory_app/core/controllers/todo_controller.dart';
import 'package:delivery_factory_app/core/controllers/order_controller.dart';
import 'package:delivery_factory_app/core/network/api_service.dart';
import 'package:delivery_factory_app/domain/repositories/order_repository.dart';
import 'package:delivery_factory_app/core/services/token_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    // Core services
    final apiService = ApiService();
    Get.put(apiService, permanent: true);

    // Auth services
    final tokenService = TokenService(apiService);
    Get.put(tokenService, permanent: true);

    // Apply auth interceptor to API service
    apiService.addAuthInterceptor(tokenService);

    // Repositories
    Get.put(OrderRepository(apiService: apiService), permanent: true);

    // Controllers
    Get.lazyPut(() => CounterController(), fenix: true);
    Get.lazyPut(() => TodoController(), fenix: true);
    Get.lazyPut(
      () => OrderController(repository: Get.find<OrderRepository>()),
      fenix: true,
    );
  }
}
