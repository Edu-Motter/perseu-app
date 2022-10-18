import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

class AthleteRequestViewModel extends AppViewModel {
  ClientAthlete athleteClient = locator<ClientAthlete>();
  String? requestCode;

  String get athleteName => session.userSession!.athlete!.name;
  String get authToken => session.authToken!;

  Future<Result> createRequest() async {
    return tryExec(() async {
      Result result = await athleteClient.createRequest(
        requestCode!,
        session.userSession!.athlete!.id,
        authToken,
      );
      if (result.success) {
        return const Result.success(
            message:
                'Solicitação enviada! Aguarde a resposta.');
      } else {
        return result;
      }
    });
  }
}
