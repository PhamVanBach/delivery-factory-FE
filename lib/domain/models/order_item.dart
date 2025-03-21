class OrderItem {
  final String productId;
  final String name;
  final String? description;
  final int quantity;
  final double price;
  final String? image;

  OrderItem({
    required this.productId,
    required this.name,
    this.description,
    required this.quantity,
    required this.price,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      quantity: json['quantity'] ?? 1,
      price: _parseDouble(json['price']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };

    if (description != null) data['description'] = description;
    if (image != null) data['image'] = image;

    return data;
  }

  // Calculate the total price for this item
  double get totalPrice {
    return price * quantity;
  }

  // Helper to format the item's total price
  String formattedTotalPrice() {
    return '\$${totalPrice.toStringAsFixed(2)}';
  }

  // Helper to format the item's unit price
  String formattedUnitPrice() {
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
