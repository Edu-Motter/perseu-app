import 'package:flutter/material.dart';
import 'package:perseu/src/models/requests/status_login.dart';
import 'package:perseu/src/states/foundation.dart';

enum LoadSessionResult {
  successAthlete, successCoach, failure
}

class BootstrapViewModel extends AppViewModel {
  Future<StatusLogin> loadSession() async {
    setBusy(true);
    bool result = await session.load();
    if(result){
      await Future.delayed(const Duration(seconds: 2));
      //session.setAuthTokenAndUser(session.authToken, session.user);
      /// When log with sharedPreferences we need to update
      /// user and token with a GET in backend
      return session.user!.status;
    }
    session.reset();
    await Future.delayed(const Duration(seconds: 2));
    return StatusLogin.unknown;
  }
}