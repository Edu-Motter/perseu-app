import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class CoachHomeViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();

  int get teamId => session.userSession!.team!.id;

  TeamInfoDTO? teamInfo;
  String get teamName => teamInfo != null ? teamInfo!.name : 'Carregando..';
  int get teamSize =>
      8; //TODO: teamInfo != null ? teamInfo!.athletesIds.length : 0;

  String get userName => session.userSession!.isCoach
      ? session.userSession!.coach!.name
      : session.userSession!.athlete!.name;

  Future<Result<TeamInfoDTO>> getTeamInfo() async {
    final result = await clientCoach.getTeamInfo(teamId, session.authToken!);
    if (result.success) {
      return Result.success(data: result.data);
    }
    return Result.error(message: result.message);
  }
}
