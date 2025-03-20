// lib/screens/orders/details/order_details_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_factory_app/core/controllers/order_controller.dart';
import 'package:delivery_factory_app/domain/models/order.dart';

class OrderDetailsPage extends GetView<OrderController> {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final orderId = arguments?['orderId'] ?? '';

    // Fetch order details when page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetails(orderId);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Order #$orderId Details')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error.value}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchOrderDetails(orderId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final order = controller.selectedOrder.value;
        if (order == null) {
          return const Center(child: Text('Order not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(order),
              const SizedBox(height: 16),
              _buildDeliveryAddress(order.deliveryAddress),
              const SizedBox(height: 16),
              _buildOrderItems(order.items),
              const SizedBox(height: 16),
              _buildOrderSummary(order),
              const SizedBox(height: 16),
              _buildActionButtons(order),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderHeader(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.id}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(order.orderDate),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress(Address address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.recipient),
                const SizedBox(height: 4),
                Text(address.street),
                if (address.apartment.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(address.apartment),
                ],
                const SizedBox(height: 4),
                Text('${address.city}, ${address.postalCode}'),
                const SizedBox(height: 4),
                Text(address.country),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(List<OrderItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => _buildOrderItem(item)),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade300,
              child: const Center(child: Icon(Icons.inventory)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Qty: ${item.quantity}'),
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(Order order) {
    // Calculate subtotal (sum of all items price * quantity)
    final subtotal = order.items.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    // Estimate tax and shipping (normally these would come from the API)
    final tax = subtotal * 0.09; // 9% tax
    final shipping = 5.99;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('\$${subtotal.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Shipping'),
                Text('\$${shipping.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tax'),
                Text('\$${tax.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Order order) {
    // Only show relevant buttons based on order status
    if (order.status.toLowerCase() == 'in transit') {
      return ElevatedButton(
        onPressed: () {
          // Show tracking info
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('Track Order'),
      );
    } else if (order.status.toLowerCase() == 'processing') {
      return ElevatedButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Cancel Order'),
              content: const Text(
                'Are you sure you want to cancel this order?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('NO'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    controller.cancelOrder(order.id);
                  },
                  child: const Text('YES'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: Colors.red,
        ),
        child: const Text('Cancel Order'),
      );
    }

    return const SizedBox.shrink(); // No buttons for delivered/cancelled orders
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'in transit':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
