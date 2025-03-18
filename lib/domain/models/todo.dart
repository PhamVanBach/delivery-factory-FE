import 'package:get/get.dart';

class Todo {
  final String id;
  final RxString title;
  final RxBool completed;
  final Rx<DateTime> createdAt;

  Todo({required this.id, required String title, bool completed = false})
    : title = title.obs,
      completed = completed.obs,
      createdAt = DateTime.now().obs;

  // Computed property example
  RxString get displayTitle =>
      RxString('${completed.value ? "✓ " : ""}${title.value}');
}
