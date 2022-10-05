import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/team_dto.dart';
import 'package:perseu/src/models/requests/team_info_request.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/states/foundation.dart';

class CoachHomeViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();

  TeamDTO get team => session.userSession!.team!;
  String get teamName => team.name;
  int get teamId => team.id;

  TeamInfoRequest? teamInfo;
  int get teamSize => teamInfo != null ? teamInfo!.athletesIds.length : 0;

  String get userName => session.userSession!.isCoach
      ? session.userSession!.coach!.name
      : session.userSession!.athlete!.name;

  void getTeamInfo() {
    tryExec(() async {
      final result = await clientCoach.getTeamInfo(teamId);
      if (result.success) teamInfo = result.data;
      return result;
    });
  }
}
