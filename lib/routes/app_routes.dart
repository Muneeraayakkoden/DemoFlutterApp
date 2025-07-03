import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'routes_names.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
      RouteNames.home: (context) => const HomeScreen(),
      RouteNames.splash: (context) => const SplashScreen(),
      RouteNames.login: (context) => const LoginScreen(),
      RouteNames.signup: (context) => const SignupScreen(),
  };
}
