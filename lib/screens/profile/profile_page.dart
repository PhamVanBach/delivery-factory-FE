import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('john.doe@example.com'),
            const SizedBox(height: 10),
            const Text('+1 123-456-7890'),
            const SizedBox(height: 30),
            const Divider(),
            _buildProfileMenuItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pushNamed(context, '/settings');
                // Navigate to settings
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.history,
              title: 'Order History',
              onTap: () {
                // Navigate to order history
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.location_on,
              title: 'My Addresses',
              onTap: () {
                // Navigate to addresses
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.payment,
              title: 'Payment Methods',
              onTap: () {
                // Navigate to payment methods
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                // Navigate to help & support
              },
            ),
            _buildProfileMenuItem(
              icon: Icons.exit_to_app,
              title: 'Logout',
              onTap: () {
                // Handle logout
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : null),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red : null),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
