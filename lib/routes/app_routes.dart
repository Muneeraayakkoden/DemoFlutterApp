import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Home%20screen/home_screen.dart';
import 'package:flutter_application_1/screens/Splash%20screen/splash_screen.dart';
import 'package:flutter_application_1/screens/Login%20screen/login_screen.dart';
import 'routes_names.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
      RouteNames.home: (context) => const HomeScreen(),
      RouteNames.splash: (context) => const SplashScreen(),
      RouteNames.login: (context) => const LoginScreen(),
  };
}
