import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

class AthleteRequestViewModel extends AppViewModel {
  ClientAthlete athleteClient = locator<ClientAthlete>();
  String? requestCode;

  Future<Result> createRequest() async {
    return tryExec(() async {
      Result result = await athleteClient.createRequest(
        requestCode!,
        session.user!.athlete!.id,
      );
      if (result.success) {
        return Result.success(
            message:
                'Sucesso ao criar pedido de ingresso, '
                    'atualmente seu pedido está ${result.data}');
      } else {
        return result;
      }
    });
  }
}
