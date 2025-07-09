import 'package:flutter/material.dart';
import '../screens/user_screens/home/view/user_home.dart';
import 'package:flutter_application_1/screens/splash_screen/view/splash_screen.dart';
import 'package:flutter_application_1/screens/login_screen/view/login_screen.dart';
import 'package:flutter_application_1/screens/profile_screen/view/profile.dart';
import '../screens/user_screens/notification/view/user_notification.dart';
import 'package:flutter_application_1/screens/bottom_navbar/view/bottom_navbar.dart';
import 'routes_names.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
      RouteNames.splash: (context) => const SplashScreen(),
      RouteNames.login: (context) => const LoginScreen(),
      RouteNames.bottomNav: (context) => const BottomNavBar(),
      RouteNames.home: (context) => const UserHome(),
      RouteNames.notifications: (context) => const UserNotification(),
      RouteNames.profile: (context) => ProfileScreen()
  };
}
