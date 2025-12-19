import 'package:flutter/material.dart';
import '../views/launch.dart';
import '../views/onboard.dart';
import '../views/onboard2.dart';
import '../views/onboard3.dart';
import '../views/login.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboard1 = '/onboard';
  static const String onboard2 = '/onboard2';
  static const String onboard3 = '/onboard3';
  static const String login = '/login';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const AnimatedSplashScreen(),
    onboard1: (context) => const AOnBoarding(),
    onboard2: (context) => const BOnBoarding(),
    onboard3: (context) => const COnBoarding(),
    login: (context) => const ALogIn()
  };
}
