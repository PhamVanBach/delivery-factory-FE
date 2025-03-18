import 'package:delivery_factory_app/screens/orders/details/order_details_page.dart';
import 'package:delivery_factory_app/screens/profile/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:delivery_factory_app/screens/main_screen.dart';

void main() {
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Factory',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/order-details': (context) => const OrderDetailsPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
