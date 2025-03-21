import 'package:delivery_factory_app/config/env.dart';

import 'base_service.dart';

class OrderService extends ApiBaseService {
  Future<List<Order>> getOrders() async {
    return await request<List<Order>>(
      endpoint: Environment.ordersEndpoint,
      method: HttpMethod.get,
      onSuccess: (data) {
        if (data is List) {
          return data.map((item) => Order.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  Future<Order> getOrderById(String id) async {
    return await request<Order>(
      endpoint: '${Environment.ordersEndpoint}/$id',
      method: HttpMethod.get,
      onSuccess: (data) => Order.fromJson(data),
    );
  }

  Future<Order> createOrder(Map<String, dynamic> orderData) async {
    return await request<Order>(
      endpoint: Environment.ordersEndpoint,
      method: HttpMethod.post,
      data: orderData,
      onSuccess: (data) => Order.fromJson(data),
    );
  }

  Future<Order> updateOrderStatus(String id, String status) async {
    return await request<Order>(
      endpoint: '${Environment.ordersEndpoint}/$id/status',
      method: HttpMethod.patch,
      data: {'status': status},
      onSuccess: (data) => Order.fromJson(data),
    );
  }

  Future<Order> cancelOrder(String id) async {
    return await request<Order>(
      endpoint: '${Environment.ordersEndpoint}/$id/cancel',
      method: HttpMethod.post,
      onSuccess: (data) => Order.fromJson(data),
    );
  }

  Future<Order> addTrackingInfo(
    String id,
    String trackingNumber, {
    DateTime? estimatedDeliveryDate,
  }) async {
    final Map<String, dynamic> data = {'trackingNumber': trackingNumber};

    if (estimatedDeliveryDate != null) {
      data['estimatedDeliveryDate'] = estimatedDeliveryDate.toIso8601String();
    }

    return await request<Order>(
      endpoint: '${Environment.ordersEndpoint}/$id/tracking',
      method: HttpMethod.patch,
      data: data,
      onSuccess: (data) => Order.fromJson(data),
    );
  }
}
