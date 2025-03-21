import 'package:delivery_factory_app/core/logging/index.dart';
import 'package:delivery_factory_app/data/services/order_service.dart';
import 'package:delivery_factory_app/domain/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final Logger _logger = AppLogger().getLoggerForClass(OrderController);

  // Orders data
  final RxList<Order> orders = <Order>[].obs;
  final Rx<Order?> selectedOrder = Rx<Order?>(null);

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;

  // Error handling
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    error.value = '';

    try {
      final ordersData = await _orderService.getOrders();
      orders.value = ordersData;
    } catch (e) {
      _logger.e('Error fetching orders: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrderById(String id) async {
    isLoading.value = true;
    error.value = '';

    try {
      final order = await _orderService.getOrderById(id);
      selectedOrder.value = order;
    } catch (e) {
      _logger.e('Error fetching order details: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Order?> createOrder(Map<String, dynamic> orderData) async {
    isProcessing.value = true;
    error.value = '';

    try {
      final order = await _orderService.createOrder(orderData);
      // Add the new order to the list
      orders.insert(0, order);
      isProcessing.value = false;
      return order;
    } catch (e) {
      _logger.e('Error creating order: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return null;
    }
  }

  Future<bool> updateOrderStatus(String id, String status) async {
    isProcessing.value = true;
    error.value = '';

    try {
      final updatedOrder = await _orderService.updateOrderStatus(id, status);

      // Update the order in the list
      final index = orders.indexWhere((order) => order.id == id);
      if (index != -1) {
        orders[index] = updatedOrder;
      }

      // Update selected order if needed
      if (selectedOrder.value?.id == id) {
        selectedOrder.value = updatedOrder;
      }

      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error updating order status: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  Future<bool> cancelOrder(String id) async {
    isProcessing.value = true;
    error.value = '';

    try {
      final updatedOrder = await _orderService.cancelOrder(id);

      // Update the order in the list
      final index = orders.indexWhere((order) => order.id == id);
      if (index != -1) {
        orders[index] = updatedOrder;
      }

      // Update selected order if needed
      if (selectedOrder.value?.id == id) {
        selectedOrder.value = updatedOrder;
      }

      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error canceling order: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  Future<bool> addTrackingInfo(
    String id,
    String trackingNumber, {
    DateTime? estimatedDeliveryDate,
  }) async {
    isProcessing.value = true;
    error.value = '';

    try {
      final updatedOrder = await _orderService.addTrackingInfo(
        id,
        trackingNumber,
        estimatedDeliveryDate: estimatedDeliveryDate,
      );

      // Update the order in the list
      final index = orders.indexWhere((order) => order.id == id);
      if (index != -1) {
        orders[index] = updatedOrder;
      }

      // Update selected order if needed
      if (selectedOrder.value?.id == id) {
        selectedOrder.value = updatedOrder;
      }

      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error adding tracking info: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  // Helper methods for filtering orders
  List<Order> getOrdersByStatus(String status) {
    return orders.where((order) => order.status == status).toList();
  }

  List<Order> get processingOrders {
    return getOrdersByStatus('Processing');
  }

  List<Order> get inTransitOrders {
    return getOrdersByStatus('In Transit');
  }

  List<Order> get deliveredOrders {
    return getOrdersByStatus('Delivered');
  }

  List<Order> get cancelledOrders {
    return getOrdersByStatus('Cancelled');
  }

  // Status helpers
  Color getStatusColor(String status) {
    switch (status) {
      case 'Processing':
        return Colors.orange;
      case 'In Transit':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Icon getStatusIcon(String status) {
    switch (status) {
      case 'Processing':
        return const Icon(Icons.pending, color: Colors.orange);
      case 'In Transit':
        return const Icon(Icons.local_shipping, color: Colors.blue);
      case 'Delivered':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'Cancelled':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  // Date formatting helpers
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';

    return '${date.day}/${date.month}/${date.year}';
  }

  String formatDateRelative(DateTime? date) {
    if (date == null) return 'N/A';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(date);
    }
  }

  String formatOrderDate(Order order) {
    return formatDateRelative(order.createdAt);
  }

  // Format price for display
  String formatPrice(double? amount) {
    if (amount == null) return '\$0.00';
    return '\$${amount.toStringAsFixed(2)}';
  }

  // Get total spent on orders
  double get totalSpent {
    return orders.fold(0, (sum, order) => sum + (order.total ?? 0));
  }

  int get ordersCount => orders.length;
}
