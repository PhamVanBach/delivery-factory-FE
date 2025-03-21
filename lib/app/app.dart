import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_factory_app/presentation/controllers/counter_controller.dart';
import 'package:delivery_factory_app/presentation/controllers/todo_controller.dart';
import 'package:delivery_factory_app/presentation/controllers/order_controller.dart';
import 'package:delivery_factory_app/core/logging/index.dart';
import 'package:delivery_factory_app/screens/orders/details/order_details_page.dart';
import 'package:delivery_factory_app/screens/profile/settings/settings_page.dart';
import 'package:delivery_factory_app/screens/main_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize logger before anything else
    AppLogger();

    // Initialize controllers
    Get.lazyPut(() => CounterController(), fenix: true);
    Get.lazyPut(() => TodoController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
    return GetMaterialApp(
      title: 'Delivery Factory App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainScreen()),
        GetPage(name: '/order-details', page: () => const OrderDetailsPage()),
        GetPage(name: '/settings', page: () => const SettingsPage()),
      ],
    );
  }
}
