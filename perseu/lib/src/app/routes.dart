import 'package:flutter/material.dart';
import 'package:perseu/src/screens/athlete_home_screen.dart';
import 'package:perseu/src/screens/login_screen.dart';
import 'package:perseu/src/screens/sign_up_screen.dart';

class Routes {
  static const String login = "/login";
  static const String athleteHome = "/athlete-home";
  static const String signUp = "/signUp";

  static Map<String, WidgetBuilder> map = {
    login: (context) => LoginScreen(),
    signUp: (context) => SignUpScreen(),
    athleteHome: (context) => const AthleteHomeScreen(),
  };
}
