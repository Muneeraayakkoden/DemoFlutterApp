import 'package:flutter/material.dart';
import '../../../../constants/color_class.dart';
import '../../../../constants/textstyle_class.dart';
import '../../user_screens/home/view/user_home.dart';
import '../../profile_screen/view/profile.dart';
import '../../user_screens/notification/view/user_notification.dart';

class BottomNavBar extends StatefulWidget {

  const BottomNavBar({super.key,});
    @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorClass.white,
        selectedItemColor: ColorClass.greenDarker,
        unselectedItemColor: ColorClass.neutral400,
        selectedLabelStyle: TextStyleClass.poppinsSemiBold(
          fontSize: 14,
        ),

        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 28),
            activeIcon: Icon(Icons.home, size: 34),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none, size: 28),
            activeIcon: Icon(Icons.notifications, size: 34),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28),
            activeIcon: Icon(Icons.person, size: 34),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
