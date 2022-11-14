import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class ManageAthletesViewModel extends AppViewModel {
  ClientTeam clientTeam = locator<ClientTeam>();

  String get authToken => session.authToken!;
  int get teamId => session.userSession!.team!.id;

  Future<Result<List<AthleteDTO>>> getAthletes() {
    return clientTeam.getAthletes(teamId, authToken);
  }
}
