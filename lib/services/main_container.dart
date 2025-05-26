import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomify/components/hooks/UserProvider.dart';
import 'package:roomify/screens/main/Add.dart';
import 'package:roomify/screens/main/Home.dart';
import 'package:roomify/screens/main/Map.dart';
import 'package:roomify/screens/main/Profile.dart';

class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    MapScreen(),
    AddScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    final role = userData?['role'];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildFooter(role),
    );
  }

  Widget _buildFooter(String? role) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildNavIcon(Icons.home, 0),
            _buildNavIcon(Icons.map, 1),
            if (role == 'Arrendatario') _buildNavIcon(Icons.add, 2),
            _buildNavIcon(Icons.person, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          color: _currentIndex == index ? Colors.blue : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
