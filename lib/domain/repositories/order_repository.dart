import 'package:delivery_factory_app/core/network/api_service.dart';
import 'package:delivery_factory_app/domain/models/order.dart';
import 'package:delivery_factory_app/core/logging/index.dart';

class OrderRepository {
  final ApiService _apiService;
  final Logger _logger = AppLogger().getLoggerForClass(OrderRepository);

  OrderRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  Future<List<Order>> getOrders() async {
    try {
      _logger.i('Fetching orders');
      final data = await _apiService.get('/orders');
      return (data as List).map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      _logger.e('Error fetching orders', e);
      rethrow;
    }
  }

  Future<Order> getOrderDetails(String orderId) async {
    try {
      _logger.i('Fetching order details for $orderId');
      final data = await _apiService.get('/orders/$orderId');
      return Order.fromJson(data);
    } catch (e) {
      _logger.e('Error fetching order details', e);
      rethrow;
    }
  }

  Future<void> createOrder(Order order) async {
    try {
      _logger.i('Creating a new order');
      await _apiService.post('/orders', data: order.toJson());
    } catch (e) {
      _logger.e('Error creating order', e);
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      _logger.i('Updating order status for $orderId to $status');
      await _apiService.put(
        '/orders/$orderId/status',
        data: {'status': status},
      );
    } catch (e) {
      _logger.e('Error updating order status', e);
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      _logger.i('Cancelling order $orderId');
      await _apiService.put('/orders/$orderId/cancel');
    } catch (e) {
      _logger.e('Error cancelling order', e);
      rethrow;
    }
  }
}
