import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Factory')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Delivery Factory!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/delivery_logo.png',
              height: 150,
              // If the image doesn't exist yet, you'll need to add it or replace this widget
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.local_shipping,
                    size: 150,
                    color: Colors.blue,
                  ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your one-stop solution for fast deliveries',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
