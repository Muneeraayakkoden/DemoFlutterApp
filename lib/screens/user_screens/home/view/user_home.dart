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
            // 1. Advertisement Banner
            Advertisement(),
            const SizedBox(height: 10),
            // 2. Meal Count Card
            MealCard(),
            const SizedBox(height: 16),
            // 3. Mark Meal Widget
            MealService(),
            const SizedBox(height: 16),
            // 4. Meetings Widget (Enhanced with edit/delete)
            MeetingService(),
            const SizedBox(height: 16),
            // 5. All Users Widget
            ContactService(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
