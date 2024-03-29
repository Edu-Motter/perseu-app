import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:perseu/src/components/dialogs/athlete_information_dialog.dart';
import 'package:perseu/src/components/dialogs/checkin_dialog/checkin_viewmodel.dart';
import 'package:perseu/src/screens/assign_training/assign_training_viewmodel.dart';
import 'package:perseu/src/screens/athlete_checks/athlete_checks_viewmodel.dart';
import 'package:perseu/src/screens/athlete_home/athlete_home_viewmodel.dart';
import 'package:perseu/src/screens/athlete_request/athlete_request_viewmodel.dart';
import 'package:perseu/src/screens/athlete_trainings_details/athlete_trainings_details_viewmodel.dart';
import 'package:perseu/src/screens/change_team_name/change_team_name_viewmodel.dart';
import 'package:perseu/src/screens/chats/chats_viewmodel.dart';
import 'package:perseu/src/screens/coach_assign_training/athletes_assign_training_viewmodel.dart';
import 'package:perseu/src/screens/coach_home/coach_home_viewmodel.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_viewmodel.dart';
import 'package:perseu/src/screens/group_chat/group_chat_viewmodel.dart';
import 'package:perseu/src/screens/group_details/group_details_viewmodel.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_viewmodel.dart';
import 'package:perseu/src/screens/manage_groups/manage_groups_viewmodel.dart';
import 'package:perseu/src/screens/new_team/new_team_viewmodel.dart';
import 'package:perseu/src/screens/new_training/new_training_viewmodel.dart';
import 'package:perseu/src/screens/profile_screen/profile_viewmodel.dart';
import 'package:perseu/src/screens/sign_up/sign_up_viewmodel.dart';
import 'package:perseu/src/screens/training_details/training_details_viewmodel.dart';
import 'package:perseu/src/screens/training_to_athlete/training_to_athlete_viewmodel.dart';
import 'package:perseu/src/screens/trainings_by_team/trainings_by_team_viewmodel.dart';
import 'package:perseu/src/screens/user_chat/user_chat_viewmodel.dart';
import 'package:perseu/src/screens/user_drawer/user_drawer_viewmodel.dart';
import 'package:perseu/src/screens/user_view_training/user_view_training_viewmodel.dart';
import 'package:perseu/src/screens/users_to_chat/users_to_chat_viewmodel.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/clients/client_firebase.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/services/fcm_service.dart';
import 'package:perseu/src/states/style.dart';
import 'package:perseu/src/viewModels/login_view_model.dart';

import '../screens/athlete_pending_request/athlete_pending_request_viewmodel.dart';
import '../screens/bootstrap/bootstrap_viewmodel.dart';
import '../screens/change_password/change_password_viewmodel.dart';
import '../screens/team_chat/team_chat_viewmodel.dart';
import '../states/session.dart';

final GetIt locator = GetIt.I;

Future<void> initializeLocator() async {
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options
      ..baseUrl =
          'http://10.0.2.2:3000/'
      ..connectTimeout = 5000
      ..receiveTimeout = 5000
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        'common-header': 'xx',
      };

    return dio;
  });

  locator.registerLazySingleton<FirebaseFirestore>((){
    return FirebaseFirestore.instance;
  });

  locator.registerLazySingleton<ClientFirebase>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //
    } else {
      return ClientFirebase();
    }
  });

  locator.registerLazySingleton<FcmService>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //
    } else {
      return FcmService();
    }
  });


  locator.registerLazySingleton<ClientAthlete>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //
    } else {
      return ClientAthlete();
    }
  });
  locator.registerLazySingleton<ClientCoach>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //return HttpClientPerseuMock();
    } else {
      return ClientCoach();
    }
  });
  locator.registerLazySingleton<ClientUser>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //
    } else {
      return ClientUser();
    }
  });
  locator.registerLazySingleton<ClientTraining>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //
    } else {
      return ClientTraining();
    }
  });
  locator.registerLazySingleton<ClientTeam>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //
    } else {
      return ClientTeam();
    }
  });

  //Global states:
  locator.registerSingleton<Session>(PersistentSession());
  locator.registerSingleton<Style>(Style());

  //Local states:
  locator.registerFactory<BootstrapViewModel>(() => BootstrapViewModel());
  locator.registerFactory<LoginViewModel>(() => LoginViewModel());
  locator.registerFactory<UserDrawerViewModel>(() => UserDrawerViewModel());
  locator.registerFactory<ProfileViewModel>(() => ProfileViewModel());
  locator.registerFactory<ChangePasswordViewModel>(() => ChangePasswordViewModel());
  locator.registerFactory<NewTeamViewModel>(() => NewTeamViewModel());
  locator.registerFactory<NewTrainingViewModel>(() => NewTrainingViewModel());
  locator.registerFactory<AthleteRequestViewModel>(() => AthleteRequestViewModel());
  locator.registerFactory<SignUpViewModel>(() => SignUpViewModel());
  locator.registerFactory<ChangeTeamNameViewModel>(() => ChangeTeamNameViewModel());
  locator.registerFactory<AthletePendingRequestViewModel>(() => AthletePendingRequestViewModel());
  locator.registerFactory<CoachManageRequestsViewModel>(() => CoachManageRequestsViewModel());
  locator.registerFactory<ChatsViewModel>(() => ChatsViewModel());
  locator.registerFactory<UserChatViewModel>(() => UserChatViewModel());
  locator.registerFactory<TeamChatViewModel>(() => TeamChatViewModel());
  locator.registerFactory<UsersToChatViewModel>(() => UsersToChatViewModel());
  locator.registerFactory<CoachHomeViewModel>(() => CoachHomeViewModel());
  locator.registerFactory<AthleteHomeViewModel>(() => AthleteHomeViewModel());
  locator.registerFactory<TrainingViewModel>(() => TrainingViewModel());
  locator.registerFactory<AthletesAssignTrainingViewModel>(() => AthletesAssignTrainingViewModel());
  locator.registerFactory<AssignTrainingViewModel>(() => AssignTrainingViewModel());
  locator.registerFactory<AthleteInformationViewModel>(() => AthleteInformationViewModel());
  locator.registerFactory<TrainingsByTeamViewModel>(() => TrainingsByTeamViewModel());
  locator.registerFactory<TrainingDetailsViewModel>(() => TrainingDetailsViewModel());
  locator.registerFactory<ManageAthletesViewModel>(() => ManageAthletesViewModel());
  locator.registerFactory<ManageGroupsViewModel>(() => ManageGroupsViewModel());
  locator.registerFactory<AthleteTrainingsDetailsViewModel>(() => AthleteTrainingsDetailsViewModel());
  locator.registerFactory<TrainingToAthleteViewModel>(() => TrainingToAthleteViewModel());
  locator.registerFactory<CheckInDialogViewModel>(() => CheckInDialogViewModel());
  locator.registerFactory<AthleteChecksViewModel>(() => AthleteChecksViewModel());
  locator.registerFactory<GroupDetailsViewModel>(() => GroupDetailsViewModel());
  locator.registerFactory<GroupChatViewModel>(() => GroupChatViewModel());

  initializeDateFormatting();
}
