import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/splash_screen/view/splash_screen.dart';
import 'package:flutter_application_1/screens/login_screen/view/login_screen.dart';
import 'package:flutter_application_1/screens/bottom_navbar/view/bottom_navbar.dart';
import 'routes_names.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.home: (context) => const BottomNavBar(),
  };
}
