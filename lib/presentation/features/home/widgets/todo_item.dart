
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_factory_app/domain/models/todo.dart';
import 'package:delivery_factory_app/presentation/controllers/todo_controller.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.removeTodo(todo.id),
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      child: ListTile(
        leading: Obx(
          () => Checkbox(
            value: todo.completed.value,
            onChanged: (_) => controller.toggleTodo(todo.id),
          ),
        ),
        // Use the computed property
        title: Obx(
          () => Text(
            todo.displayTitle.value,
            style: TextStyle(
              decoration:
                  todo.completed.value ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        // Show creation time reactively
        subtitle: Obx(
          () => Text(
            'Created: ${todo.createdAt.value.toString().substring(0, 16)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditDialog(context, controller),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, TodoController controller) {
    final textController = TextEditingController(text: todo.title.value);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Todo'),
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
                controller.updateTodoTitle(todo.id, textController.text);
                Get.back();
              }
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }
}
