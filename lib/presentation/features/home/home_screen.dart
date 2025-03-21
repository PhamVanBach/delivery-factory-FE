import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_factory_app/presentation/controllers/counter_controller.dart';
import 'package:delivery_factory_app/presentation/controllers/todo_controller.dart';
import 'widgets/todo_item.dart';
import 'widgets/todo_filter.dart';

class HomeScreen extends GetView<TodoController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counterController = Get.find<CounterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactive Delivery Factory'),
        actions: [
          // Show active counter status - reactively updates
          Obx(
            () => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(counterController.counterStatus.value),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Counter section with reactive updates
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(
                    () => Text(
                      'Counter: ${counterController.count}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Show reactive status
                  Obx(
                    () => Text(
                      'Status: ${counterController.status.value}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: counterController.decrement,
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: counterController.increment,
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Todo filters - reactive
          TodoFilter(),

          // Todo stats - reactive
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text('Total: ${controller.totalTodos}')),
                Obx(() => Text('Active: ${controller.activeTodos}')),
                Obx(() => Text('Completed: ${controller.completedTodos}')),
                TextButton(
                  onPressed: controller.clearCompleted,
                  child: const Text('Clear completed'),
                ),
              ],
            ),
          ),

          // Todo list - reactively filtered
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Todo List',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Obx(
                        () =>
                            controller.filteredTodos.isEmpty
                                ? const Center(
                                  child: Text('No todos match your filter'),
                                )
                                : ListView.builder(
                                  itemCount: controller.filteredTodos.length,
                                  itemBuilder: (context, index) {
                                    final todo =
                                        controller.filteredTodos[index];
                                    return TodoItem(todo: todo);
                                  },
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final textController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Todo'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(labelText: 'Todo title'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                controller.addTodo(textController.text);
                Get.back();
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}
