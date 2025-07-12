import 'package:flutter/material.dart';
import '../../../../constants/color_class.dart';
import '../../../../constants/textstyle_class.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/item_list.dart';
import '../widgets/powered_by.dart';
import '../widgets/profile_box.dart';
import '../../login_screen/provider/auth_provider.dart';
import '../provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when screen loads
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    if (!mounted) return;
    await context.read<ProfileProvider>().fetchProfileData();
  }

  Future<void> _handleLogout() async {
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    await authProvider.handleLogout(context);
  }

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
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (profileProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(profileProvider.error),
                  ElevatedButton(
                    onPressed: () => _initializeProfile(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                ProfileBox(
                  userName: profileProvider.name,
                  phone: profileProvider.phoneNumber,
                ),
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
                        onTap: _handleLogout,
                      ),
                      const SizedBox(height: 16),
                      const PoweredBy(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
