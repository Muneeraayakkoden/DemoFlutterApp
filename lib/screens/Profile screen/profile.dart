import 'package:flutter/material.dart';
import '../../../constants/color_class.dart';
import '../../../constants/textstyle_class.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../constants/icons_class.dart';
import '../../../constants/global_variables.dart';

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
            ProfileCard(),
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
  const ProfileCard({super.key});
  @override
  Widget build(BuildContext context) {
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
              children: [
                Text(
                  'User',
                  style: TextStyleClass.primaryFont500(20, ColorClass.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//ItemList
class ItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const ItemCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

//powered by
class PoweredBy extends StatelessWidget {
  const PoweredBy({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Powered by',
          style: TextStyleClass.poppinsMedium(
            fontSize: 14,
            color: ColorClass.neutral400,
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(IconClass.d4dxLogo, height: 60),
        const SizedBox(height: 8),
        Text(
          'v${GlobalVariables.appVersion}',
          style: TextStyleClass.poppinsRegular(
            fontSize: 12,
            color: ColorClass.neutral400,
          ),
        ),
      ],
    );
  }
}