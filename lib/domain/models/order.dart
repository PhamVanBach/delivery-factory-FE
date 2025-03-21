import 'order_item.dart';
import 'address.dart';

class Order {
  final String id;
  final String userId;
  final List<OrderItem>? items;
  final Address? shippingAddress;
  final Address? billingAddress;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double? subtotal;
  final double? shippingCost;
  final double? tax;
  final double? couponDiscount;
  final double? total;
  final DateTime? estimatedDeliveryDate;
  final String? trackingNumber;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.userId,
    this.items,
    this.shippingAddress,
    this.billingAddress,
    this.status = 'Processing',
    this.paymentMethod = 'Credit Card',
    this.paymentStatus = 'Pending',
    this.subtotal,
    this.shippingCost,
    this.tax,
    this.couponDiscount,
    this.total,
    this.estimatedDeliveryDate,
    this.trackingNumber,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items:
          json['items'] != null
              ? List<OrderItem>.from(
                json['items'].map((item) => OrderItem.fromJson(item)),
              )
              : null,
      shippingAddress:
          json['shippingAddress'] != null
              ? Address.fromJson(json['shippingAddress'])
              : null,
      billingAddress:
          json['billingAddress'] != null
              ? Address.fromJson(json['billingAddress'])
              : null,
      status: json['status'] ?? 'Processing',
      paymentMethod: json['paymentMethod'] ?? 'Credit Card',
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      subtotal: _parseDouble(json['subtotal']),
      shippingCost: _parseDouble(json['shippingCost']),
      tax: _parseDouble(json['tax']),
      couponDiscount: _parseDouble(json['couponDiscount']),
      total: _parseDouble(json['total']),
      estimatedDeliveryDate:
          json['estimatedDeliveryDate'] != null
              ? DateTime.tryParse(json['estimatedDeliveryDate'])
              : null,
      trackingNumber: json['trackingNumber'],
      notes: json['notes'],
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
      'userId': userId,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };

    if (items != null) {
      data['items'] = items!.map((item) => item.toJson()).toList();
    }
    if (shippingAddress != null) {
      data['shippingAddress'] = shippingAddress!.toJson();
    }
    if (billingAddress != null) {
      data['billingAddress'] = billingAddress!.toJson();
    }
    if (subtotal != null) data['subtotal'] = subtotal;
    if (shippingCost != null) data['shippingCost'] = shippingCost;
    if (tax != null) data['tax'] = tax;
    if (couponDiscount != null) data['couponDiscount'] = couponDiscount;
    if (total != null) data['total'] = total;
    if (estimatedDeliveryDate != null) {
      data['estimatedDeliveryDate'] = estimatedDeliveryDate!.toIso8601String();
    }
    if (trackingNumber != null) data['trackingNumber'] = trackingNumber;
    if (notes != null) data['notes'] = notes;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }

  // Get the number of items in the order
  int get itemCount {
    if (items == null || items!.isEmpty) return 0;
    return items!.fold(0, (sum, item) => sum + (item.quantity ?? 0));
  }

  // Check if the order is delivered
  bool get isDelivered => status == 'Delivered';

  // Check if the order is in transit
  bool get isInTransit => status == 'In Transit';

  // Check if the order is processing
  bool get isProcessing => status == 'Processing';

  // Check if the order is cancelled
  bool get isCancelled => status == 'Cancelled';

  // Check if the order can be cancelled
  bool get canBeCancelled => !isDelivered && !isCancelled;

  // Check if the order has tracking information
  bool get hasTracking => trackingNumber != null && trackingNumber!.isNotEmpty;

  // Helper to format date for display
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format creation date
  String get formattedDate => formatDate(createdAt);

  // Format estimated delivery date
  String get formattedEstimatedDelivery => formatDate(estimatedDeliveryDate);

  // Helper methods for displaying formatted values
  String formattedSubtotal() {
    if (subtotal == null) return '\$0.00';
    return '\$${subtotal!.toStringAsFixed(2)}';
  }

  String formattedTax() {
    if (tax == null) return '\$0.00';
    return '\$${tax!.toStringAsFixed(2)}';
  }

  String formattedShipping() {
    if (shippingCost == null) return '\$0.00';
    return shippingCost! > 0 ? '\$${shippingCost!.toStringAsFixed(2)}' : 'Free';
  }

  String formattedDiscount() {
    if (couponDiscount == null || couponDiscount! <= 0) return '\$0.00';
    return '-\$${couponDiscount!.toStringAsFixed(2)}';
  }

  String formattedTotal() {
    if (total == null) return '\$0.00';
    return '\$${total!.toStringAsFixed(2)}';
  }

  // Helper to parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}
