import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class ChangeTeamNameViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();

  String? teamName;

  Future<Result> changeTeamName() {
    return tryExec(() async {
      return await clientCoach.changeTeamName(teamName!, 7);
    });
  }
}
