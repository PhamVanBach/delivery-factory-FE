class Address {
  final String fullName;
  final String streetAddress;
  final String? apartment;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;
  final bool isDefault;

  Address({
    required this.fullName,
    required this.streetAddress,
    this.apartment,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country = 'United States',
    this.phone,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      fullName: json['fullName'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      apartment: json['apartment'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? 'United States',
      phone: json['phone'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fullName': fullName,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };

    if (apartment != null && apartment!.isNotEmpty) {
      data['apartment'] = apartment;
    }
    if (phone != null) data['phone'] = phone;
    data['isDefault'] = isDefault;

    return data;
  }

  // Format the address for display
  String get formattedAddress {
    final parts = <String>[];

    parts.add(streetAddress);

    if (apartment != null && apartment!.isNotEmpty) {
      parts.add(apartment!);
    }

    final cityStateZip = <String>[city, state, zipCode];
    parts.add(cityStateZip.join(', '));

    parts.add(country);

    return parts.join('\n');
  }

  // Format address for display in a single line
  String get singleLineAddress {
    final parts = <String>[];

    parts.add(streetAddress);

    if (apartment != null && apartment!.isNotEmpty) {
      parts.add(apartment!);
    }

    parts.add('$city, $state $zipCode');

    return parts.join(', ');
  }

  // Get city and state formatted
  String get cityState {
    return '$city, $state';
  }
}
