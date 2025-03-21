import 'cart_item.dart';

class Cart {
  final String id;
  final String userId;
  final List<CartItem>? items;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double total;
  final String? couponCode;
  final double? couponDiscount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Cart({
    required this.id,
    required this.userId,
    this.items,
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.shippingCost = 0.0,
    this.total = 0.0,
    this.couponCode,
    this.couponDiscount,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] ?? '',
      userId: json['user'] ?? '',
      items:
          json['items'] != null
              ? List<CartItem>.from(
                json['items'].map((item) => CartItem.fromJson(item)),
              )
              : null,
      subtotal: _parseDouble(json['subtotal']),
      tax: _parseDouble(json['tax']),
      shippingCost: _parseDouble(json['shippingCost']),
      total: _parseDouble(json['total']),
      couponCode: json['couponCode'],
      couponDiscount: _parseDouble(json['couponDiscount']),
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'user': userId,
      'subtotal': subtotal,
      'tax': tax,
      'shippingCost': shippingCost,
      'total': total,
    };

    if (items != null) {
      data['items'] = items!.map((item) => item.toJson()).toList();
    }
    if (couponCode != null) data['couponCode'] = couponCode;
    if (couponDiscount != null) data['couponDiscount'] = couponDiscount;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }

  // Get the number of items in the cart
  int get itemCount {
    if (items == null || items!.isEmpty) return 0;
    return items!.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  // Check if the cart is empty
  bool get isEmpty {
    return items == null || items!.isEmpty;
  }

  // Helper to parse double values
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  // Helper methods for displaying formatted values
  String formattedSubtotal() {
    return '\$${subtotal.toStringAsFixed(2)}';
  }

  String formattedTax() {
    return '\$${tax.toStringAsFixed(2)}';
  }

  String formattedShipping() {
    return shippingCost > 0 ? '\$${shippingCost.toStringAsFixed(2)}' : 'Free';
  }

  String formattedDiscount() {
    if (couponDiscount == null || couponDiscount! <= 0) return '\$0.00';
    return '-\$${couponDiscount!.toStringAsFixed(2)}';
  }

  String formattedTotal() {
    return '\$${total.toStringAsFixed(2)}';
  }
}
