import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes/routes_names.dart';
import 'package:flutter_application_1/constants/icons_class.dart';
import 'package:flutter_application_1/constants/textstyle_class.dart';
import 'package:flutter_application_1/constants/color_class.dart';
import 'package:flutter_application_1/utils/navigation_helper.dart';
import 'package:flutter_application_1/constants/global_variables.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.7).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.7, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_animationController);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();  
    Future.delayed(Duration(milliseconds: 4000), () {
      if (mounted) {
        navigateReplaceTo(context: context, route: RouteNames.login);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorClass.brandDarkGreen, // top
              ColorClass.middleGradient, 
              ColorClass.bottomGradient,// bottom
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Image.asset(
                      IconClass.splashLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.asset(
                      IconClass.splashImage,
                      width: MediaQuery.of(context).size.width,
                      height:null,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        IconClass.dxLogoWhite,
                        width: 58,
                        height: 58,
                      ),
                    SizedBox(height: 8),
                    Text(
                      'v${GlobalVariables.appVersion}',
                      style: TextStyleClass.poppinsRegular(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),  
          ],
        ),
      ),
    );
  }
}

