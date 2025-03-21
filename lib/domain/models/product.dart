class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? category;
  final String? image;
  final bool inStock;
  final int? stockQuantity;
  final List<String>? tags;
  final String? vendor;
  final double? rating;
  final int? numReviews;
  final bool? featured;
  final double? discountPercentage;
  final double? discountedPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.category,
    this.image,
    this.inStock = true,
    this.stockQuantity,
    this.tags,
    this.vendor,
    this.rating,
    this.numReviews,
    this.featured = false,
    this.discountPercentage = 0,
    this.discountedPrice,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: _parsePrice(json['price']),
      category: json['category'],
      image: json['image'],
      inStock: json['inStock'] ?? true,
      stockQuantity: json['stockQuantity'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      vendor: json['vendor'],
      rating:
          json['rating'] != null
              ? double.tryParse(json['rating'].toString())
              : null,
      numReviews: json['numReviews'],
      featured: json['featured'] ?? false,
      discountPercentage:
          json['discountPercentage'] != null
              ? double.tryParse(json['discountPercentage'].toString())
              : 0,
      discountedPrice:
          json['discountedPrice'] != null
              ? double.tryParse(json['discountedPrice'].toString())
              : null,
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
      'name': name,
      'description': description,
      'price': price,
    };

    if (category != null) data['category'] = category;
    if (image != null) data['image'] = image;
    data['inStock'] = inStock;
    if (stockQuantity != null) data['stockQuantity'] = stockQuantity;
    if (tags != null) data['tags'] = tags;
    if (vendor != null) data['vendor'] = vendor;
    if (rating != null) data['rating'] = rating;
    if (numReviews != null) data['numReviews'] = numReviews;
    data['featured'] = featured;
    if (discountPercentage != null)
      data['discountPercentage'] = discountPercentage;
    if (discountedPrice != null) data['discountedPrice'] = discountedPrice;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();

    return data;
  }

  // Calculate the final price after discount
  double get finalPrice {
    if (discountedPrice != null) return discountedPrice!;
    if (discountPercentage != null && discountPercentage! > 0) {
      return price * (1 - (discountPercentage! / 100));
    }
    return price;
  }

  // Get formatted discounted percentage for display
  String get discountDisplay {
    if (discountPercentage == null || discountPercentage! <= 0) return '';
    return '${discountPercentage!.toStringAsFixed(0)}% OFF';
  }

  // Check if the product has a discount
  bool get hasDiscount {
    return discountPercentage != null && discountPercentage! > 0;
  }

  // Helper to format price for display
  String formattedPrice() {
    return '\${price.toStringAsFixed(2)}';
  }

  // Helper to format the discounted price for display
  String formattedDiscountedPrice() {
    return '\${finalPrice.toStringAsFixed(2)}';
  }

  // Helper to parse price from API response
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;

    if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return price;
    } else if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }

    return 0.0;
  }
}
