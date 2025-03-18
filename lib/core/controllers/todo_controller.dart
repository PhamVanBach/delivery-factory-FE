import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:delivery_factory_app/domain/models/todo.dart';

class TodoController extends GetxController {
  // Observable lists
  final RxList<Todo> todos = <Todo>[].obs;

  // Filter states
  final RxString currentFilter = 'all'.obs;

  // Computed values (reactive)
  RxInt get totalTodos => RxInt(todos.length);
  RxInt get completedTodos =>
      RxInt(todos.where((todo) => todo.completed.value).length);
  RxInt get activeTodos =>
      RxInt(todos.where((todo) => !todo.completed.value).length);

  // Filtered list (reactive)
  RxList<Todo> get filteredTodos => RxList(
    currentFilter.value == 'all'
        ? todos
        : currentFilter.value == 'active'
        ? todos.where((todo) => !todo.completed.value).toList()
        : todos.where((todo) => todo.completed.value).toList(),
  );

  void addTodo(String title) {
    final newTodo = Todo(id: const Uuid().v4(), title: title);
    todos.add(newTodo);
  }

  void toggleTodo(String id) {
    final todo = todos.firstWhere((todo) => todo.id == id);
    todo.completed.value = !todo.completed.value;
  }

  void updateTodoTitle(String id, String newTitle) {
    final todo = todos.firstWhere((todo) => todo.id == id);
    todo.title.value = newTitle;
  }

  void removeTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
  }

  void setFilter(String filter) {
    currentFilter.value = filter;
  }

  void clearCompleted() {
    todos.removeWhere((todo) => todo.completed.value);
  }

  @override
  void onInit() {
    super.onInit();
    // React when the filter changes
    ever(currentFilter, (_) => update());

    // React when any todo's completion status changes
    ever(completedTodos, (count) {
      print('Completed todos: $count');
    });
  }
}
