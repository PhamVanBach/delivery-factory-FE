import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_factory_app/presentation/features/home/home_screen.dart';
import 'package:delivery_factory_app/core/controllers/counter_controller.dart';
import 'package:delivery_factory_app/core/controllers/todo_controller.dart';
import 'package:delivery_factory_app/core/logging/index.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    Get.lazyPut(() => CounterController(), fenix: true);
    Get.lazyPut(() => TodoController(), fenix: true);
    // Initialize logger before anything else
    AppLogger();

    return GetMaterialApp(
      title: 'Delivery Factory App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
