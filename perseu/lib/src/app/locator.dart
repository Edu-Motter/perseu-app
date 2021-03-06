import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:perseu/src/screens/athlete_drawer/athlete_drawer_viewmodel.dart';
import 'package:perseu/src/screens/athlete_request/athlete_request_viewmodel.dart';
import 'package:perseu/src/screens/change_team_name/change_team_name_viewmodel.dart';
import 'package:perseu/src/screens/new_team/new_team_viewmodel.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_viewmodel.dart';
import 'package:perseu/src/screens/profile_screen/profile_viewmodel.dart';
import 'package:perseu/src/screens/sign_up/sign_up_viewmodel.dart';
import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/viewModels/login_view_model.dart';

import '../screens/athlete_pending_request/athlete_pending_request_viewmodel.dart';
import '../screens/bootstrap/bootstrap_viewmodel.dart';
import '../screens/change_password/change_password_viewmodel.dart';
import '../states/session.dart';

final GetIt locator = GetIt.I;

void initializeLocator() {
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options
      ..baseUrl =
          'http://10.0.2.2:3333/' //'http://0.0.0.0:8080/'
      ..connectTimeout = 5000
      ..receiveTimeout = 5000
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        'common-header': 'xx',
      };

    return dio;
  });

  locator.registerLazySingleton<HttpClientPerseu>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //return HttpClientPerseuMock();
    } else {
      return HttpClientPerseu();
    }
  });
  //Global states:
  locator.registerSingleton<Session>(PersistentSession());

  //Local states:
  locator.registerFactory<BootstrapViewModel>(() => BootstrapViewModel());
  locator.registerFactory<LoginViewModel>(() => LoginViewModel());
  locator.registerFactory<AthleteDrawerViewModel>(() => AthleteDrawerViewModel());
  locator.registerFactory<ProfileViewModel>(() => ProfileViewModel());
  locator.registerFactory<ChangePasswordViewModel>(() => ChangePasswordViewModel());
  locator.registerFactory<NewTeamViewModel>(() => NewTeamViewModel());
  locator.registerFactory<AthleteRequestViewModel>(() => AthleteRequestViewModel());
  locator.registerFactory<SignUpViewModel>(() => SignUpViewModel());
  locator.registerFactory<ChangeTeamNameViewModel>(() => ChangeTeamNameViewModel());
  locator.registerFactory<AthletePendingRequestViewModel>(() => AthletePendingRequestViewModel());
  locator.registerFactory<CoachManageRequestsViewModel>(() => CoachManageRequestsViewModel());
}
