import 'package:flutter/material.dart';
import '../../../../../../constants/color_class.dart';
import '../../../../../../constants/textstyle_class.dart';
import '../widgets/advertisement.dart';
import '../widgets/meal_box.dart';
import '../widgets/mealscard.dart';
import '../widgets/meetingcard.dart';
import '../widgets/contactcard.dart';

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
            const SizedBox(height: 8),
            // Advertisement Banner
            Advertisement(),
            const SizedBox(height: 10),
            //Meal box to display the meal counts
            MealBox(),
            const SizedBox(height: 20),
            // Meal Card
            Mealscard(),
            const SizedBox(height: 16),
            // Meetings
            Meetingcard(),
            const SizedBox(height: 16),
            // All Users
            Contactcard(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
