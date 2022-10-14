import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/clients/client_user.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class NewTeamViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();
  ClientUser clientUser = locator<ClientUser>();

  String get coachName => session.userSession!.coach!.name;
  int get coachId => session.userSession!.coach!.id;
  String get authToken => session.authToken!;

  String? teamName;

  Future<Result> createTeam() {
    Result result;
    return tryExec(() async {
      result = await clientCoach.createTeam(teamName!, coachId, authToken);

      if (result.error) return result;
      final String name = result.data!;

      final userUpdated = await clientUser.getUser(authToken);
      if (userUpdated.error) {
        return const Result.error(message: 'Falha ao recarregar seus dados');
      }

      session.setAuthTokenAndUser(userUpdated.data!.token, userUpdated.data);
      return Result.success(message: 'Equipe $name criada com sucesso');
    });
  }
}
