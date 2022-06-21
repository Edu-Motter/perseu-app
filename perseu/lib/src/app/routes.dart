import 'package:flutter/material.dart';
import 'package:perseu/src/screens/change_password/change_password_screen.dart';
import 'package:perseu/src/screens/change_team_name/change_team_name_screen.dart';
import 'package:perseu/src/screens/coach_screens/new_exercise_screening.dart';
import 'package:perseu/src/screens/coach_screens/new_session_screening.dart';
import 'package:perseu/src/screens/login_screen.dart';
import 'package:perseu/src/screens/new_team/new_team_screen.dart';
import 'package:perseu/src/screens/profile_screen/profile_screen.dart';
import 'package:perseu/src/screens/sign_up/sign_up_screen.dart';
import 'package:perseu/src/screens/athlete_home_screen.dart';
import 'package:perseu/src/screens/coach_home_screen.dart';
import 'package:perseu/src/screens/coach_screens/new_training_screening.dart';
import 'package:perseu/src/screens/coach_manage_requests/manage_invites_screen.dart';
import 'package:perseu/src/screens/without_team_screens/athlete_enter_team_screen.dart';
import 'package:perseu/src/screens/without_team_screens/coach_creates_team_screen.dart';

import '../screens/athlete_pending_request/athlete_pending_request_screen.dart';
import '../screens/athlete_request/athlete_request_screen.dart';
import '../screens/bootstrap/bootstrap_screen.dart';

class Routes {
  static const String bootstrap = "bootstrap";
  static const String login = "login";
  static const String signUp = "sign-up";
  static const String athleteHome = "athlete-home";
  static const String coachHome = "coach-home";
  static const String newTraining = "new-training";
  static const String newSession = "new-session";
  static const String newExercice = "new-exercise";
  static const String manageInvites = "manage-invites";
  static const String athleteEnterTeam = "athlete-enter-team";
  static const String coachCreatesTeam = "coach-creates-team";
  static const String profile = "profile";
  static const String changePassword = "change-password";
  static const String newTeam = "new-team";
  static const String athleteRequest = "athlete-request";
  static const String athletePendingRequest = "athlete-pending-request";
  static const String changeTeamName = "change-team-name";

  static Map<String, WidgetBuilder> map = {
    bootstrap: (context) => const BootstrapScreen(),
    login: (context) => LoginScreen(),
    signUp: (context) => SignUpScreen(),
    athleteHome: (context) => AthleteHomeScreen(),
    coachHome: (context) => CoachHomeScreen(),
    newTraining: (context) => const NewTrainingScreen(),
    newSession: (context) => const NewSessionScreen(),
    newExercice: (context) => const NewExerciseScreen(),
    manageInvites: (context) => const CoachManageRequestsScreen(),
    athleteEnterTeam: (context) => const AthleteEnterTeam(),
    coachCreatesTeam: (context) => const CoachCreatesTeam(),
    profile: (context) => const ProfileScreen(),
    changePassword: (context) => const ChangePasswordScreen(),
    newTeam: (context) => const NewTeamScreen(),
    changeTeamName: (context) => const ChangeTeamNameScreen(),
    athleteRequest: (context) => const AthleteRequestScreen(),
    athletePendingRequest: (context) => const AthletePendingRequestScreen()
  };
}
