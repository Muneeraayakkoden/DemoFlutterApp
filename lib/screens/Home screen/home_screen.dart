import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
import 'bottom navbar/bottom_navbar.dart'; 
import 'user_screens/user_home.dart';
import 'user_screens/user_notifcation.dart';
import '../Profile screen/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    UserHome(),
    UserNotification(),
    ProfileScreen(),
  ];
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
