import 'package:flutter/material.dart';
import 'package:perseu/src/screens/login_screen.dart';
import 'package:perseu/src/screens/sign_up_screen.dart';
import 'package:perseu/src/screens/athlete_home_screen.dart';
import 'package:perseu/src/screens/coach_home_screen.dart';
import 'package:perseu/src/screens/coach_screens/new_training_screening.dart';

class Routes {
  static const String login = "/login";
  static const String signUp = "/sign-up";
  static const String athleteHome = "/athlete-home";
  static const String coachHome = "/coach-home";
  static const String newTraining = "/new-training";

  static Map<String, WidgetBuilder> map = {
    login: (context) => LoginScreen(),
    signUp: (context) => SignUpScreen(),
    athleteHome: (context) => const AthleteHomeScreen(),
    coachHome: (context) => const CoachHomeScreen(),
    newTraining: (context) => const NewTrainingScreen(),
  };
}
