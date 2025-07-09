import 'package:flutter/material.dart';
import '../../../../../../constants/color_class.dart';
import '../../../../../../constants/textstyle_class.dart';
import '../widgets/advertisement.dart';
import '../widgets/meal_card.dart';
import '../services/meals.dart';
import '../services/meetings.dart';
import '../services/contacts.dart';

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
            // Advertisement Banner
            Advertisement(),
            const SizedBox(height: 10),
            // Meal Card
            MealCard(),
            const SizedBox(height: 16),
            // Mark Meal
            MealService(),
            const SizedBox(height: 16),
            // Meetings
            MeetingService(),
            const SizedBox(height: 16),
            // All Users
            ContactService(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
