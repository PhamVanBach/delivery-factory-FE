import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presentation/features/home/home_screen.dart';
import '../core/controllers/counter_controller.dart';
import '../core/controllers/todo_controller.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    Get.lazyPut(() => CounterController(), fenix: true);
    Get.lazyPut(() => TodoController(), fenix: true);

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
