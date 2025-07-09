import 'package:flutter/material.dart';
import '../../../../constants/color_class.dart';
import '../../../../constants/textstyle_class.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/item_list.dart';
import '../widgets/powered_by.dart';
import '../widgets/profile_box.dart';

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
            ProfileBox(userName:'', phone:'', designation:''),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ItemList(
                    title: 'Feedback',
                    icon: LucideIcons.messageCircle,
                    onTap: () {},
                  ),
                  ItemList(
                    title: 'Privacy Policy',
                    icon: LucideIcons.shieldCheck,
                    onTap: () {},
                  ),
                  ItemList(
                    title: 'Contact Us',
                    icon: LucideIcons.phone,
                    onTap: () {},
                  ),
                  ItemList(
                    title: 'About Us',
                    icon: LucideIcons.info,
                    onTap: () {},
                  ),
                  ItemList(
                    title: 'Raise a bug',
                    icon: LucideIcons.bug,
                    onTap: () {},
                  ),
                  const Divider(height: 24),
                  ItemList(
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

