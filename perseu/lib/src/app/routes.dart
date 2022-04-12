import 'package:flutter/material.dart';
import 'package:perseu/src/screens/coach_screens/new_session_screening.dart';
import 'package:perseu/src/screens/login_screen.dart';
import 'package:perseu/src/screens/sign_up_screen.dart';
import 'package:perseu/src/screens/athlete_home_screen.dart';
import 'package:perseu/src/screens/coach_home_screen.dart';
import 'package:perseu/src/screens/coach_screens/new_training_screening.dart';
import 'package:perseu/src/screens/coach_screens/manage_invites_screen.dart';

class Routes {
  static const String login = "/login";
  static const String signUp = "/sign-up";
  static const String athleteHome = "/athlete-home";
  static const String coachHome = "/coach-home";
  static const String newTraining = "/new-training";
  static const String newSession = "/new-session";
  static const String manageInvites = "/manage-invites";

  static Map<String, WidgetBuilder> map = {
    login: (context) => LoginScreen(),
    signUp: (context) => SignUpScreen(),
    athleteHome: (context) => const AthleteHomeScreen(),
    coachHome: (context) => const CoachHomeScreen(),
    newTraining: (context) => const NewTrainingScreen(),
    newSession: (context) => const NewSessionScreen(),
    manageInvites: (context) => const ManageInvitesScreen(),
  };
}
