import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(index % 3),
                child: Icon(_getStatusIcon(index % 3), color: Colors.white),
              ),
              title: Text('Order #${index + 1}'),
              subtitle: Text('Status: ${_getStatusText(index % 3)}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to order details with arguments
                Navigator.pushNamed(
                  context,
                  '/order-details',
                  arguments: {
                    'orderId': index + 1,
                    'status': _getStatusText(index % 3),
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  // The status helper methods remain the same
  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Delivered';
      case 1:
        return 'In Transit';
      case 2:
        return 'Processing';
      default:
        return 'Unknown';
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.check_circle;
      case 1:
        return Icons.local_shipping;
      case 2:
        return Icons.pending;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
