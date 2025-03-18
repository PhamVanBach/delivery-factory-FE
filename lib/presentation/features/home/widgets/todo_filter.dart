// lib/presentation/features/home/widgets/todo_filter.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_factory_app/core/controllers/todo_controller.dart';

class TodoFilter extends GetView<TodoController> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
              () => FilterChip(
                label: const Text('All'),
                selected: controller.currentFilter.value == 'all',
                onSelected: (_) => controller.setFilter('all'),
              ),
            ),
            Obx(
              () => FilterChip(
                label: const Text('Active'),
                selected: controller.currentFilter.value == 'active',
                onSelected: (_) => controller.setFilter('active'),
              ),
            ),
            Obx(
              () => FilterChip(
                label: const Text('Completed'),
                selected: controller.currentFilter.value == 'completed',
                onSelected: (_) => controller.setFilter('completed'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
