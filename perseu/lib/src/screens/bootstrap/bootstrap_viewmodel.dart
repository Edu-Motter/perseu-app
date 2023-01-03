import 'package:flutter/foundation.dart';
import 'package:perseu/src/models/dtos/login_dto.dart';
import 'package:perseu/src/models/dtos/status.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/services/fcm_service.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

enum LoadSessionResult {
  successAthlete, successCoach, failure
}

class BootstrapViewModel extends AppViewModel {
  ClientUser clientUser = locator<ClientUser>();
  FcmService fcmService = locator<FcmService>();

  Future<Status> loadSession() async {
    setBusy(true);
    bool result = await session.load();
    if(result){
      final userUpdated = await clientUser.getUser(session.authToken!);
      if(userUpdated.success){
        final fcmResult = await handleFcmCredentials(userUpdated.data!);
        if(fcmResult.error){
          session.reset();
          await Future.delayed(const Duration(seconds: 2));
          return Status.unknown;
        }
        session.setAuthTokenAndUser(userUpdated.data!.token, userUpdated.data);
        debugPrint('Success with bootstrap and fcm token refresh');
        return session.userSession!.status;
      }
    }
    session.reset();
    await Future.delayed(const Duration(seconds: 2));
    return Status.unknown;
  }

  Future<Result> handleFcmCredentials(LoginDTO login) async {
    final String? deviceToken = await fcmService.getDeviceToken();
    if (deviceToken == null) {
      return const Result.error(message: 'Erro ao gerar device token');
    }

    return fcmService.saveDeviceToken(deviceToken, login.user.id, login.token);
  }
}