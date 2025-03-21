import 'package:delivery_factory_app/core/logging/index.dart';
import 'package:delivery_factory_app/data/services/cart_service.dart';
import 'package:delivery_factory_app/domain/models/cart.dart';
import 'package:delivery_factory_app/domain/models/cart_item.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();
  final Logger _logger = AppLogger().getLoggerForClass(CartController);

  // Cart data
  final Rx<Cart?> cart = Rx<Cart?>(null);
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble shippingCost = 0.0.obs;
  final RxDouble couponDiscount = 0.0.obs;
  final RxDouble total = 0.0.obs;
  final RxString couponCode = ''.obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;

  // Error handling
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    isLoading.value = true;
    error.value = '';

    try {
      final cartData = await _cartService.getCart();
      updateCartData(cartData);
    } catch (e) {
      _logger.e('Error fetching cart: $e');
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addToCart(String productId, int quantity) async {
    isProcessing.value = true;
    error.value = '';

    try {
      final cartData = await _cartService.addToCart(productId, quantity);
      updateCartData(cartData);
      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error adding item to cart: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  Future<bool> updateCartItem(String productId, int quantity) async {
    isProcessing.value = true;
    error.value = '';

    try {
      final cartData = await _cartService.updateCartItem(productId, quantity);
      updateCartData(cartData);
      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error updating cart item: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  Future<bool> removeFromCart(String productId) async {
    isProcessing.value = true;
    error.value = '';

    try {
      final cartData = await _cartService.removeFromCart(productId);
      updateCartData(cartData);
      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error removing item from cart: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  Future<bool> applyCoupon(String code) async {
    isProcessing.value = true;
    error.value = '';

    try {
      final cartData = await _cartService.applyCoupon(code);
      updateCartData(cartData);
      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error applying coupon: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  Future<bool> removeCoupon() async {
    isProcessing.value = true;
    error.value = '';

    try {
      final cartData = await _cartService.removeCoupon();
      updateCartData(cartData);
      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error removing coupon: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  Future<bool> clearCart() async {
    isProcessing.value = true;
    error.value = '';

    try {
      final cartData = await _cartService.clearCart();
      updateCartData(cartData);
      isProcessing.value = false;
      return true;
    } catch (e) {
      _logger.e('Error clearing cart: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return false;
    }
  }

  Future<Map<String, dynamic>?> checkout() async {
    isProcessing.value = true;
    error.value = '';

    try {
      final response = await _cartService.checkout();
      isProcessing.value = false;

      // Clear cart data after successful checkout
      updateCartData(
        Cart(
          id: cart.value?.id ?? '',
          userId: cart.value?.userId ?? '',
          items: [],
          subtotal: 0,
          tax: 0,
          shippingCost: 0,
          total: 0,
        ),
      );

      return response;
    } catch (e) {
      _logger.e('Error during checkout: $e');
      error.value = e.toString();
      isProcessing.value = false;
      return null;
    }
  }

  void updateCartData(Cart cartData) {
    cart.value = cartData;

    if (cartData.items != null) {
      cartItems.value = cartData.items!;
    } else {
      cartItems.clear();
    }

    subtotal.value = cartData.subtotal;
    tax.value = cartData.tax;
    shippingCost.value = cartData.shippingCost;
    couponDiscount.value = cartData.couponDiscount ?? 0;
    total.value = cartData.total;
    couponCode.value = cartData.couponCode ?? '';
  }

  // Helper methods
  int get itemCount {
    return cartItems.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  bool get isEmpty {
    return cartItems.isEmpty;
  }

  CartItem? findCartItem(String productId) {
    try {
      return cartItems.firstWhere((item) => item.product == productId);
    } catch (e) {
      return null;
    }
  }

  bool hasProduct(String productId) {
    return findCartItem(productId) != null;
  }

  int getQuantity(String productId) {
    final item = findCartItem(productId);
    return item?.quantity ?? 0;
  }

  // Format price for display
  String formatPrice(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}
