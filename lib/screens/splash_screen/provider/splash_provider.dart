  import 'package:flutter/material.dart';
  import 'dart:developer' as developer;
  import 'package:provider/provider.dart';
  import '../../login_screen/provider/auth_provider.dart';
  import '../../../utils/navigation_helper.dart';
  import '../../../routes/routes_names.dart';

  Future<void> checkAuthAndNavigate(BuildContext context) async {
    try {
      // Wait for animations to play
      await Future.delayed(const Duration(milliseconds: 2000));
      if (!context.mounted) return;

      developer.log('Checking authentication status...',
        name: 'SplashScreen',
      );

      // Initialize auth state
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initializeAuth();

      if (!context.mounted) return;

      // Navigate based on auth status
      if (authProvider.isLoggedIn) {
        developer.log('User is logged in, navigating to home',
          name: 'SplashScreen',
        );
        navigateReplaceTo(context: context, route: RouteNames.home);
      } else {
        developer.log('User is not logged in, navigating to login',
          name: 'SplashScreen',
        );
        navigateReplaceTo(context: context, route: RouteNames.login);
      }
    } catch (e) {
      developer.log('Error during auth check: $e',
        name: 'SplashScreen',
        error: e,
      );
      // On error, safely navigate to login
      if (!context.mounted) return;
      navigateReplaceTo(context: context, route: RouteNames.login);
    }
  }