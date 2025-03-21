class CartItem {
  final String product;
  final String name;
  final double price;
  final double discountedPrice;
  final int? quantity;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartItem({
    required this.product,
    required this.name,
    required this.price,
    required this.discountedPrice,
    this.quantity = 1,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: json['product'] ?? '',
      name: json['name'] ?? '',
      price: _parseDouble(json['price']),
      discountedPrice: _parseDouble(json['discountedPrice']),
      quantity: json['quantity'] ?? 1,
      image: json['image'],
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
      'product': product,
      'name': name,
      'price': price,
      'discountedPrice': discountedPrice,
      'quantity': quantity,
    };

    if (image != null) data['image'] = image;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }

  // Calculate the total price for this item
  double get totalPrice {
    return discountedPrice * (quantity ?? 1);
  }

  // Helper to format the item's total price
  String formattedTotalPrice() {
    return '\$${totalPrice.toStringAsFixed(2)}';
  }

  // Helper to format the item's unit price
  String formattedUnitPrice() {
    return '\$${discountedPrice.toStringAsFixed(2)}';
  }

  // Helper to check if there's a discount
  bool get hasDiscount {
    return price > discountedPrice;
  }

  // Helper to format the regular price (when discounted)
  String formattedRegularPrice() {
    return '\$${price.toStringAsFixed(2)}';
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
}
