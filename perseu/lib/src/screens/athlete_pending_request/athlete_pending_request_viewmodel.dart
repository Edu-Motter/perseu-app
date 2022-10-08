import 'package:perseu/src/states/foundation.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';

import '../../services/foundation.dart';
import '../../app/locator.dart';

class AthletePendingRequestViewModel extends AppViewModel {
  ClientAthlete athleteClient = locator<ClientAthlete>();
  int get athleteId => session.userSession!.athlete!.id;
  String get authToken => session.authToken!;

  Future<Result> checkRequestStatus() {
    return tryExec(() async {
      Result result = await athleteClient.getRequestByAthlete(
        session.userSession!.athlete!.id,
        authToken,
      );
      if (result.success) {
        return const Result.success(message: 'Solicitação aceita!');
      } else {
        return result;
      }
    });
  }

  Future<Result> cancelRequest() {
    return tryExec(() async {
      Result result = await athleteClient.cancelRequest(
        session.userSession!.athlete!.id,
        authToken,
      );
      if (result.success) {
        return const Result.success(message: 'Solicitação cancelada');
      } else {
        return result;
      }
    });
  }
}
