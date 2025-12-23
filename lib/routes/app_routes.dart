import 'package:flutter/material.dart';
import 'package:impal/views/Setup.dart';
import 'package:impal/views/activity.dart';
import 'package:impal/views/profile.dart';
import 'package:impal/views/recomend.dart';
import 'package:impal/views/signup.dart';
import '../views/launch.dart';
import '../views/meal2.dart';
import '../views/onboard.dart';
import '../views/onboard2.dart';
import '../views/onboard4.dart';
import '../views/onboard3.dart';
import '../views/login.dart';
import '../views/signup.dart';
import '../views/gender.dart';
import '../views/old.dart';
import '../views/height.dart';
import '../views/weight.dart';
import '../views/activity.dart';
import '../views/profile.dart';
import '../views/goal.dart';
import '../views/home.dart';
import '../views/recomend.dart';
import '../views/eat1.dart';
import '../views/eat2.dart';
import '../views/progressTracking.dart';
import '../views/notif.dart';
import '../views/workout.dart';
import '../views/meal1.dart';
import '../views/meal2.dart';
import '../views/meal3.dart';
import '../views/meal4.dart';
import '../views/meal5.dart';
import '../views/consult.dart';
import '../views/recipe.dart';
import '../views/trainer1.dart';
import '../views/trainer2.dart';
import '../views/nutri1.dart';
import '../views/nutri2.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboard1 = '/onboard';
  static const String onboard2 = '/onboard2';
  static const String onboard4 = '/onboard4';
  static const String onboard3 = '/onboard3';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String setup = '/setup';
  static const String gender = '/gender';
  static const String old = '/old';
  static const String height = '/height';
  static const String weight = '/weight';
  static const String activity = '/activity';
  static const String profile = '/profile';
  static const String goal = '/goal';
  static const String home = '/home';
  static const String recomend = '/recomend';
  static const String eat1 = '/eat1';
  static const String eat2 = '/eat2';
  static const String tracking = '/progressTracking';
  static const String notif = '/Notification';
  static const String workout = '/WorkoutLogs';
  static const String meal = '/MealPlans';
  static const String meal2 = '/MealPlans2';
  static const String meal3 = '/MealPlans3';
  static const String meal4 = '/MealPlans4';
  static const String meal5 = '/MealPlans5';
  static const String consult = '/Consultation';
  static const String recipe = '/Recipe';
  static const String trainer1 = '/Trainer';
  static const String trainer2 = '/Trainer2';
  static const String nutri1 = '/Nutritionist1';
  static const String nutri2 = '/Nutritionist2';





  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const AnimatedSplashScreen(),
    onboard1: (context) => const AOnBoarding(),
    onboard2: (context) => const BOnBoarding(),
    onboard4: (context) => const DOnBoarding(),
    onboard3: (context) => const COnBoarding(),
    login: (context) => const ALogIn(),
    signup: (context) => const BSignUp(),
    setup : (context) => const ASetUp(),
    gender: (context) => const GenderA(),
    old: (context) => const AHowOld(),
    height: (context) => const Height(),
    weight: (context) => const Weight(),
    activity: (context) => const ActivityLevel(),
    profile: (context) => const Profile(),
    goal: (context) => const Goal(),
    home: (context) => const Home(),
    recomend: (context) => const Rekomendasi(),
    eat1: (context) => EatSchedule(),
    eat2: (context) => EatSchedule2(),
    tracking: (context) => ProgressTracking(),
    notif: (context) => Notification1(),
    workout: (context) => WorkoutLogs(),
    meal: (context) => MealPlans(),
    meal2: (context) => MealPlans2(),
    meal3: (context) => MealPlans3(),
    meal4: (context) => MealPlans4(),
    meal5: (context) => MealPlans5(),
    consult: (context) => Consultation(),
    recipe: (context) => Recipe(),
    trainer1: (context) => Trainer(),
    trainer2: (context) => Trainer2(),
    nutri1: (context) => Nutritionist1(),
    nutri2: (context) => Nutritionist2()
  };
}
