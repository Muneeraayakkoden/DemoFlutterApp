import 'package:flutter/material.dart';
import '../../../constants/color_class.dart';
import '../../../constants/textstyle_class.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: ColorClass.white,
      selectedItemColor: ColorClass.greenDarker,
      unselectedItemColor: ColorClass.neutral400,
      selectedLabelStyle: TextStyleClass.poppinsSemiBold(
        fontSize: 14,
      ),
      currentIndex: currentIndex,
      onTap: onTap,
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
    );
  }
}
