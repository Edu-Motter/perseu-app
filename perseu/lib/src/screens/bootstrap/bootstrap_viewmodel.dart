import 'package:flutter/material.dart';
import 'package:perseu/src/states/foundation.dart';

enum LoadSessionResult {
  successAthlete, successCoach, failure
}

class BootstrapViewModel extends AppViewModel {
  Future<LoadSessionResult> loadSession() async {
    setBusy(true);
    bool result = await session.load();
    if(result){
      await Future.delayed(const Duration(seconds: 5));
      //session.setAuthTokenAndUser(session.authToken, session.user);
      if(session.user?.name == 'Atleta'){
        return LoadSessionResult.successAthlete;
      } else {
        return LoadSessionResult.successCoach;
      }
    }
    session.reset();
    await Future.delayed(const Duration(seconds: 5));
    debugPrint('Returning..');
    return LoadSessionResult.failure;
  }
}