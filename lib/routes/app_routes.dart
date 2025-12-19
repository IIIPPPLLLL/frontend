import 'package:flutter/material.dart';
import '../views/launch.dart';
import '../views/onboard.dart';
import '../views/onboard2.dart';
import '../views/onboard4.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboard1 = '/onboard';
  static const String onboard2 = '/onboard2';
  static const String onboard4 = '/onboard4';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const AnimatedSplashScreen(),
    onboard1: (context) => const AOnBoarding(),
    onboard2: (context) => const BOnBoarding(),
    onboard4: (context) => const DOnBoarding(),
  };
}
