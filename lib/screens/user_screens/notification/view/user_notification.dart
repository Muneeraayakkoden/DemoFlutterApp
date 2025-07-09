import 'package:flutter/material.dart';
import '../../../../constants/color_class.dart';
import '../../../../constants/textstyle_class.dart';

class UserNotification extends StatefulWidget {
 const UserNotification({super.key});

  @override
  State<UserNotification> createState() => UserNotificationState();
}

class UserNotificationState extends State<UserNotification> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorClass.greenDarker,
        title: Text('Notifications',      
        style: TextStyleClass.primaryFont500(20, ColorClass.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              color: ColorClass.neutral400,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyleClass.primaryFont500(
                  18, ColorClass.textSub500),
            ),
          ],
        ),
      ),
    );
  }
}
