class User {
  final String? id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String role;
  final List<Map<String, dynamic>>? addresses;
  final String? defaultAddress;
  final String? profileImage;
  final List<String>? favoriteProducts;
  final bool isVendor;
  final Map<String, dynamic>? vendorInfo;
  final Map<String, bool>? notificationPreferences;
  final DateTime? createdAt;

  User({
    this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.role = 'customer',
    this.addresses,
    this.defaultAddress,
    this.profileImage,
    this.favoriteProducts,
    this.isVendor = false,
    this.vendorInfo,
    this.notificationPreferences,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'],
      role: json['role'] ?? 'customer',
      addresses:
          json['addresses'] != null
              ? List<Map<String, dynamic>>.from(json['addresses'])
              : null,
      defaultAddress: json['defaultAddress'],
      profileImage: json['profileImage'],
      favoriteProducts:
          json['favoriteProducts'] != null
              ? List<String>.from(json['favoriteProducts'])
              : null,
      isVendor: json['isVendor'] ?? false,
      vendorInfo: json['vendorInfo'],
      notificationPreferences:
          json['notificationPreferences'] != null
              ? Map<String, bool>.from(json['notificationPreferences'])
              : null,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'role': role,
      'isVendor': isVendor,
    };

    if (id != null) data['id'] = id;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (addresses != null) data['addresses'] = addresses;
    if (defaultAddress != null) data['defaultAddress'] = defaultAddress;
    if (profileImage != null) data['profileImage'] = profileImage;
    if (favoriteProducts != null) data['favoriteProducts'] = favoriteProducts;
    if (vendorInfo != null) data['vendorInfo'] = vendorInfo;
    if (notificationPreferences != null) {
      data['notificationPreferences'] = notificationPreferences;
    }
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();

    return data;
  }

  // Check if user is a vendor
  bool get isUserVendor => isVendor || role == 'vendor';

  // Check if user is an admin
  bool get isAdmin => role == 'admin';

  // Check if user has addresses
  bool get hasAddresses => addresses != null && addresses!.isNotEmpty;

  // Get user initials for avatar
  String get initials {
    if (name.isEmpty) return '?';

    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return name[0].toUpperCase();
    }
  }

  // Get formatted join date
  String get formattedJoinDate {
    if (createdAt == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  // Get user's default address if any
  Map<String, dynamic>? getDefaultAddress() {
    if (!hasAddresses) return null;

    try {
      if (defaultAddress != null) {
        return addresses!.firstWhere(
          (address) => address['_id'] == defaultAddress,
          orElse: () => addresses!.first,
        );
      } else {
        // Find address marked as default
        final defaultAddr = addresses!.firstWhere(
          (address) => address['isDefault'] == true,
          orElse: () => addresses!.first,
        );

        return defaultAddr;
      }
    } catch (e) {
      return null;
    }
  }

  // Get formatted address for display
  String getFormattedAddress(Map<String, dynamic> address) {
    final parts = <String>[];

    if (address.containsKey('streetAddress')) {
      parts.add(address['streetAddress']);
    }

    if (address.containsKey('apartment') &&
        address['apartment'] != null &&
        address['apartment'].toString().isNotEmpty) {
      parts.add(address['apartment']);
    }

    final cityStateZip = <String>[];
    if (address.containsKey('city') &&
        address['city'] != null &&
        address['city'].toString().isNotEmpty) {
      cityStateZip.add(address['city']);
    }

    if (address.containsKey('state') &&
        address['state'] != null &&
        address['state'].toString().isNotEmpty) {
      cityStateZip.add(address['state']);
    }

    if (address.containsKey('zipCode') &&
        address['zipCode'] != null &&
        address['zipCode'].toString().isNotEmpty) {
      cityStateZip.add(address['zipCode']);
    }

    if (cityStateZip.isNotEmpty) {
      parts.add(cityStateZip.join(', '));
    }

    if (address.containsKey('country') &&
        address['country'] != null &&
        address['country'].toString().isNotEmpty) {
      parts.add(address['country']);
    }

    return parts.join('\n');
  }
}
