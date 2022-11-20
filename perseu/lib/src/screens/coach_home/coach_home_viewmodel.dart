import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class CoachHomeViewModel extends AppViewModel {
  ClientTeam clientTeam = locator<ClientTeam>();

  int get teamId => session.userSession!.team!.id;
  String get coachName => session.userSession?.coach?.name ?? ' - - ';

  String get userName => session.userSession!.isCoach
      ? session.userSession!.coach!.name
      : session.userSession!.athlete!.name;

  Future<Result<TeamInfoDTO>> getTeamInfo() async {
    final result = await clientTeam.getTeamInfo(teamId, session.authToken!);
    final resultNumberAthletes =
        await clientTeam.getAthletesCount(teamId, session.authToken!);
    if (result.success && resultNumberAthletes.success) {
      final teamInfo =
          result.data!.copyWith(numberOfAthletes: resultNumberAthletes.data);
      return Result.success(data: teamInfo);
    }
    return Result.error(message: result.message);
  }

  void refresh() => notifyListeners();
}
