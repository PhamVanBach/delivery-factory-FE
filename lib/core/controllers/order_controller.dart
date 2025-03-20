// lib/core/controllers/order_controller.dart
import 'package:get/get.dart';
import 'package:delivery_factory_app/domain/repositories/order_repository.dart';
import 'package:delivery_factory_app/domain/models/order.dart';
import 'package:delivery_factory_app/core/network/api_service.dart';
import 'package:delivery_factory_app/core/logging/index.dart';

class OrderController extends GetxController {
  final OrderRepository _repository;
  final Logger _logger = AppLogger().getLoggerForClass(OrderController);

  // Observable state variables
  final RxList<Order> orders = <Order>[].obs;
  final Rx<Order?> selectedOrder = Rxn<Order>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  OrderController({OrderRepository? repository})
    : _repository = repository ?? OrderRepository();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      error.value = '';

      final fetchedOrders = await _repository.getOrders();
      orders.assignAll(fetchedOrders);

      _logger.i('Successfully fetched ${orders.length} orders');
    } on ApiException catch (e) {
      error.value = e.message;
      _logger.e('Failed to fetch orders: ${e.message}');
    } catch (e) {
      error.value = 'An unexpected error occurred';
      _logger.e('Unexpected error fetching orders', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrderDetails(String orderId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final orderDetails = await _repository.getOrderDetails(orderId);
      selectedOrder.value = orderDetails;

      _logger.i('Successfully fetched details for order $orderId');
    } on ApiException catch (e) {
      error.value = e.message;
      _logger.e('Failed to fetch order details: ${e.message}');
    } catch (e) {
      error.value = 'An unexpected error occurred';
      _logger.e('Unexpected error fetching order details', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrder(Order order) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _repository.createOrder(order);
      await fetchOrders(); // Refresh the orders list

      _logger.i('Successfully created new order');
    } on ApiException catch (e) {
      error.value = e.message;
      _logger.e('Failed to create order: ${e.message}');
    } catch (e) {
      error.value = 'An unexpected error occurred';
      _logger.e('Unexpected error creating order', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _repository.updateOrderStatus(orderId, status);

      // Update the local order status
      final orderIndex = orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        // Create a new order object with updated status
        final updatedOrder = Order(
          id: orders[orderIndex].id,
          status: status,
          orderDate: orders[orderIndex].orderDate,
          total: orders[orderIndex].total,
          items: orders[orderIndex].items,
          deliveryAddress: orders[orderIndex].deliveryAddress,
        );

        orders[orderIndex] = updatedOrder;

        // If this is the selected order, update it too
        if (selectedOrder.value?.id == orderId) {
          selectedOrder.value = updatedOrder;
        }
      }

      _logger.i('Successfully updated status for order $orderId to $status');
    } on ApiException catch (e) {
      error.value = e.message;
      _logger.e('Failed to update order status: ${e.message}');
    } catch (e) {
      error.value = 'An unexpected error occurred';
      _logger.e('Unexpected error updating order status', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _repository.cancelOrder(orderId);
      await fetchOrders(); // Refresh the orders list

      _logger.i('Successfully cancelled order $orderId');
    } on ApiException catch (e) {
      error.value = e.message;
      _logger.e('Failed to cancel order: ${e.message}');
    } catch (e) {
      error.value = 'An unexpected error occurred';
      _logger.e('Unexpected error cancelling order', e);
    } finally {
      isLoading.value = false;
    }
  }
}
