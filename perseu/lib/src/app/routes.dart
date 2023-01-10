import 'package:flutter/material.dart';
import 'package:perseu/src/screens/athlete_checks/athlete_checks_screen.dart';
import 'package:perseu/src/screens/athlete_home/athlete_home_screen.dart';
import 'package:perseu/src/screens/athlete_pending_request/athlete_pending_request_screen.dart';
import 'package:perseu/src/screens/athlete_request/athlete_request_screen.dart';
import 'package:perseu/src/screens/bootstrap/bootstrap_screen.dart';
import 'package:perseu/src/screens/change_password/change_password_screen.dart';
import 'package:perseu/src/screens/change_team_name/change_team_name_screen.dart';
import 'package:perseu/src/screens/chats/chats_screen.dart';
import 'package:perseu/src/screens/coach_home/coach_home_screen.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/login_screen.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/screens/manage_groups/manage_groups_screen.dart';
import 'package:perseu/src/screens/new_team/new_team_screen.dart';
import 'package:perseu/src/screens/profile_screen/profile_screen.dart';
import 'package:perseu/src/screens/sign_up/sign_up_screen.dart';
import 'package:perseu/src/screens/team_chat/team_chat_screen.dart';
import 'package:perseu/src/screens/trainings_by_team/trainings_by_team_screen.dart';
import 'package:perseu/src/screens/user_view_training/user_view_training_screen.dart';
import 'package:perseu/src/screens/users_to_chat/users_to_chat_screen.dart';

class Routes {
  static const String bootstrap = 'bootstrap';
  static const String login = 'login';
  static const String signUp = 'sign-up';
  static const String athleteHome = 'athlete-home';
  static const String coachHome = 'coach-home';
  static const String newTraining = 'new-training';
  static const String manageInvites = 'manage-invites';
  static const String profile = 'profile';
  static const String changePassword = 'change-password';
  static const String newTeam = 'new-team';
  static const String athleteRequest = 'athlete-request';
  static const String athletePendingRequest = 'athlete-pending-request';
  static const String changeTeamName = 'change-team-name';
  static const String userViewTraining = 'user-view-training';
  static const String chats = 'chats';
  static const String teamChat = 'team-chat';
  static const String usersToChat = 'users-to-chat';
  static const String trainingsByTeam = 'trainingsByTeam';
  static const String manageAthletes = 'manage-athletes';
  static const String manageGroups = 'manage-groups';
  static const String trainingToAthlete = 'training-to-athlete';
  static const String athleteChecks = 'athlete-checks';

  static Map<String, WidgetBuilder> map = {
    bootstrap: (context) => const BootstrapScreen(),
    login: (context) => LoginScreen(),
    signUp: (context) => const SignUpScreen(),
    athleteHome: (context) => AthleteHomeScreen(),
    coachHome: (context) => CoachHomeScreen(),
    manageInvites: (context) => const CoachManageRequestsScreen(),
    profile: (context) => const ProfileScreen(),
    changePassword: (context) => const ChangePasswordScreen(),
    newTeam: (context) => const NewTeamScreen(),
    changeTeamName: (context) => const ChangeTeamNameScreen(),
    athleteRequest: (context) => const AthleteRequestScreen(),
    athletePendingRequest: (context) => AthletePendingRequestScreen(),
    userViewTraining: (context) => const UserViewTrainingScreen(),
    chats : (context) => const ChatsScreen(),
    teamChat : (context) => const TeamChatScreen(),
    usersToChat : (context) => const UsersToChatScreen(),
    trainingsByTeam : (context) => const TrainingsByTeamScreen(),
    manageGroups : (context) => const ManageGroupsScreen(),
    manageAthletes : (context) => const ManageAthletesScreen(),
    athleteChecks : (context) => const AthleteChecksScreen(),
    // newTraining: (context) => const NewTrainingScreen(),
    // trainingToAthlete : (context) => const TrainingToAthleteScreen(),
    // trainingDetails : (context) => const TrainingDetailsScreen(),
  };
}
