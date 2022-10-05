import 'package:perseu/src/models/dtos/status.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

enum LoadSessionResult {
  successAthlete, successCoach, failure
}

class BootstrapViewModel extends AppViewModel {
  ClientUser clientUser = locator<ClientUser>();

  Future<Status> loadSession() async {
    setBusy(true);
    bool result = await session.load();
    if(result){
      final userUpdated = await clientUser.getUser(session.authToken!);
      if(userUpdated.success){
        session.setAuthTokenAndUser(session.authToken, userUpdated.data);
        return session.userSession!.status;
      }
    }
    session.reset();
    await Future.delayed(const Duration(seconds: 2));
    return Status.unknown;
  }
}