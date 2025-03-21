import 'package:get/get.dart';

class CounterController extends GetxController {
  // Observable state variables
  final count = 0.obs;
  final RxString status = 'idle'.obs;

  // Computed value (reactive)
  RxString get counterStatus => RxString('Current count: ${count.value}');

  void increment() {
    status.value = 'incrementing';
    count.value++;
    status.value = 'idle';
  }

  void decrement() {
    if (count.value > 0) {
      status.value = 'decrementing';
      count.value--;
      status.value = 'idle';
    }
  }

  // We can perform side effects when variables change
  @override
  void onInit() {
    super.onInit();
    // Example of observing changes
    ever(count, (value) {
      print('Count changed to: $value');
    });

    // Example of debounced reaction (useful for search fields)
    debounce(count, (value) {
      print('Count settled at: $value');
    }, time: const Duration(milliseconds: 500));
  }
}
