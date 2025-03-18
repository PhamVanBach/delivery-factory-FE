import 'package:flutter/material.dart';
import 'package:delivery_factory_app/screens/home/home_page.dart';
import 'package:delivery_factory_app/screens/orders/orders_page.dart';
import 'package:delivery_factory_app/screens/profile/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomePage(),
    OrdersPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // This SafeArea is for the screen content
        bottom:
            false, // Don't add bottom padding since we'll handle that in the navigation bar
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: SafeArea(
        // This SafeArea is specifically for the navigation bar
        top: false, // We only need bottom padding for the navigation bar
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_filled, Icons.home_outlined, 'Home'),
              _buildNavItem(
                1,
                Icons.list_alt,
                Icons.list_alt_outlined,
                'Orders',
              ),
              _buildNavItem(2, Icons.person, Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
    String label,
  ) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
