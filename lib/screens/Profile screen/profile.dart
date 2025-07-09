import 'package:flutter/material.dart';
import '../../../constants/color_class.dart';
import '../../../constants/textstyle_class.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'Item_card.dart';
import 'powered_by.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorClass.greenDarker,
        title: Text(
          'Profile',
          style: TextStyleClass.primaryFont500(20, ColorClass.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            ProfileCard(userName:'', phone:'', designation:''),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ItemCard(
                    title: 'Feedback',
                    icon: LucideIcons.messageCircle,
                    onTap: () {},
                  ),
                  ItemCard(
                    title: 'Privacy Policy',
                    icon: LucideIcons.shieldCheck,
                    onTap: () {},
                  ),
                  ItemCard(
                    title: 'Contact Us',
                    icon: LucideIcons.phone,
                    onTap: () {},
                  ),
                  ItemCard(
                    title: 'About Us',
                    icon: LucideIcons.info,
                    onTap: () {},
                  ),
                  ItemCard(
                    title: 'Raise a bug',
                    icon: LucideIcons.bug,
                    onTap: () {},
                  ),
                  const Divider(height: 24),
                  ItemCard(
                    title: 'Logout',
                    icon: LucideIcons.logOut,
                    isDestructive: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  PoweredBy(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Profile Card
class ProfileCard extends StatelessWidget {
  final String userName;
  final String phone;
  final String designation;

  const ProfileCard({super.key, 
    required this.userName,
    required this.phone,
    required this.designation,
  });

  bool get isEmptyData =>
    userName.trim().isEmpty &&
    phone.trim().isEmpty &&
    designation.trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    if (isEmptyData) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorClass.greenDarker,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: ColorClass.brandLightGreen,
              child: Icon(LucideIcons.user, color: ColorClass.greenDarker, size: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text('No data available',
                  style: TextStyleClass.primaryFont500(16, ColorClass.white)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorClass.greenDarker,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: ColorClass.brandLightGreen,
            child: Text(userName[0].toUpperCase()),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $userName'),
                Text('Phone: $phone'),
                Text('Designation: $designation'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}