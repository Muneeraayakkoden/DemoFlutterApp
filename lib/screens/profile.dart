import 'package:flutter/material.dart';
import '../../constants/color_class.dart';
import '../../constants/textstyle_class.dart';

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
        title: Text('Profile',      
        style: TextStyleClass.primaryFont500(20, ColorClass.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Profile Screen'),
          ],
        ),
      ),
    );
  }
}
