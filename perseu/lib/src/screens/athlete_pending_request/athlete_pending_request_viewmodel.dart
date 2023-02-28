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
        athleteId,
        authToken,
      );
      if (result.success) {
        final String status = parseStatus(result.data as String);
        if (status.contains('endente')) {
          return Result.success(message: status, data: false);
        } else {
          return Result.success(message: status, data: true);
        }
      } else {
        return result;
      }
    });
  }

  Future<Result> cancelRequest() {
    return tryExec(() async {
      Result result = await athleteClient.cancelRequest(
        athleteId,
        authToken,
      );
      if (result.success) {
        return const Result.success(message: 'Solicitação foi cancelada');
      } else {
        return result;
      }
    });
  }

  String parseStatus(String status) {
    switch (status) {
      case 'PENDING':
        return 'Solicitação está pendente';
      case 'ACCEPTED':
        return 'Solicitação foi aprovada, realize o login';
      case 'DECLINED':
        return 'Solicitação foi recusada, cancele e tente outra equipe';
      default:
        return 'Erro ao processar sua solicitação';
    }
  }

  void logout() {
    session.setAuthTokenAndUser(null, null);
    notifyListeners();
  }
}
