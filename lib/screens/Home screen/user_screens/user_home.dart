import 'package:flutter/material.dart';
import '../../../../../constants/color_class.dart';
import '../../../../../constants/textstyle_class.dart';

class UserHome extends StatefulWidget {
 const UserHome({super.key});

  @override
  State<UserHome> createState() => UserHomeState();
}

class UserHomeState extends State<UserHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorClass.greenDarker,
        title: Text('Hira +',
        style: TextStyleClass.primaryFont500(20, ColorClass.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('User Home Page.'),
          ],
        ),
      ),
    );
  }
}
