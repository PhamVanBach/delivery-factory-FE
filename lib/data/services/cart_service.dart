
import 'package:delivery_factory_app/config/env.dart';
import 'base_service.dart';

class CartService extends ApiBaseService {
  Future<Cart> getCart() async {
    return await request<Cart>(
      endpoint: Environment.cartEndpoint,
      method: HttpMethod.get,
      onSuccess: (data) => Cart.fromJson(data),
    );
  }
  
  Future<Cart> addToCart(String productId, int quantity) async {
    return await request<Cart>(
      endpoint: '${Environment.cartEndpoint}/items',
      method: HttpMethod.post,
      data: {
        'productId': productId,
        'quantity': quantity,
      },
      onSuccess: (data) => Cart.fromJson(data),
    );
  }
  
  Future<Cart> updateCartItem(String productId, int quantity) async {
    return await request<Cart>(
      endpoint: '${Environment.cartEndpoint}/items/$productId',
      method: HttpMethod.patch,
      data: {
        'quantity': quantity,
      },
      onSuccess: (data) => Cart.fromJson(data),
    );
  }
  
  Future<Cart> removeFromCart(String productId) async {
    return await request<Cart>(
      endpoint: '${Environment.cartEndpoint}/items/$productId',
      method: HttpMethod.delete,
      onSuccess: (data) => Cart.fromJson(data),
    );
  }
  
  Future<Cart> applyCoupon(String couponCode) async {
    return await request<Cart>(
      endpoint: '${Environment.cartEndpoint}/apply-coupon',
      method: HttpMethod.post,
      data: {
        'couponCode': couponCode,
      },
      onSuccess: (data) => Cart.fromJson(data),
    );
  }
  
  Future<Cart> removeCoupon() async {
    return await request<Cart>(
      endpoint: '${Environment.cartEndpoint}/coupon',
      method: HttpMethod.delete,
      onSuccess: (data) => Cart.fromJson(data),
    );
  }
  
  Future<Cart> clearCart() async {
    return await request<Cart>(
      endpoint: Environment.cartEndpoint,
      method: HttpMethod.delete,
      onSuccess: (data) => Cart.fromJson(data),
    );
  }
  
  Future<Map<String, dynamic>> checkout() async {
    return await request<Map<String, dynamic>>(
      endpoint: '${Environment.cartEndpoint}/checkout',
      method: HttpMethod.post,
      onSuccess: (data) => data,
    );
  }
}