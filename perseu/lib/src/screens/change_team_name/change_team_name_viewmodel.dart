import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class ChangeTeamNameViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();

  String get authToken => session.authToken!;
  int get teamId => session.userSession!.team!.id;
  String get oldTeamName => session.userSession!.team!.name;

  String? teamName;

  Future<Result> changeTeamName() {
    return tryExec(
      () async =>
          await clientCoach.changeTeamName(teamName!, teamId, authToken),
    );
  }

  void updateTeamSession() {
    session.userSession!.team =
        session.userSession!.team!.copyWith(name: teamName ?? oldTeamName);
  }
}
