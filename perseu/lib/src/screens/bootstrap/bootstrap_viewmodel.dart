import 'package:perseu/src/models/requests/status_login.dart';
import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

enum LoadSessionResult {
  successAthlete, successCoach, failure
}

class BootstrapViewModel extends AppViewModel {
  HttpClientPerseu clientPerseu = locator<HttpClientPerseu>();

  Future<StatusLogin> loadSession() async {
    setBusy(true);
    bool result = await session.load();
    if(result){
      final userUpdated = await clientPerseu.getUser(session.user!.email);
      if(userUpdated.success){
        session.setAuthTokenAndUser(session.authToken, userUpdated.data);
        return session.user!.status;
      }
    }
    session.reset();
    await Future.delayed(const Duration(seconds: 2));
    return StatusLogin.unknown;
  }
}