class Order {
  final String id;
  final String status;
  final DateTime orderDate;
  final double total;
  final List<OrderItem> items;
  final Address deliveryAddress;

  Order({
    required this.id,
    required this.status,
    required this.orderDate,
    required this.total,
    required this.items,
    required this.deliveryAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'],
      orderDate: DateTime.parse(json['orderDate']),
      total: json['total'].toDouble(),
      items:
          (json['items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList(),
      deliveryAddress: Address.fromJson(json['deliveryAddress']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
      'deliveryAddress': deliveryAddress.toJson(),
    };
  }
}

class OrderItem {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Address {
  final String recipient;
  final String street;
  final String apartment;
  final String city;
  final String postalCode;
  final String country;

  Address({
    required this.recipient,
    required this.street,
    required this.apartment,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      recipient: json['recipient'],
      street: json['street'],
      apartment: json['apartment'] ?? '',
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'street': street,
      'apartment': apartment,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }
}
