import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/invite_dto.dart';
import 'package:perseu/src/models/dtos/team_dto.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class CoachManageRequestsViewModel extends AppViewModel {
  TeamDTO get team => session.userSession!.team!;
  String get authToken => session.authToken!;

  ClientTeam clientTeam = locator<ClientTeam>();
  ClientCoach clientCoach = locator<ClientCoach>();

  Future<Result<List<InviteDTO>>> getRequests(int teamId) async {
    await Future.delayed(const Duration(seconds: 2));
    return await clientCoach.getRequests(teamId, authToken);
  }

  Future<Result> acceptRequest(int athleteId) async {
    return await clientCoach.acceptRequest(athleteId, authToken);
  }

  Future<Result> declineRequest(int athleteId) async {
    return await clientCoach.declineRequest(athleteId, authToken);
  }

  Future<Result<TeamInfoDTO>> getTeamInfo() async {
    final result = await clientTeam.getTeamInfo(team.id, session.authToken!);
    final resultNumberAthletes = await clientTeam.getAthletesCount(team.id, session.authToken!);
    if (result.success && resultNumberAthletes.success) {
      final teamInfo = result.data!.copyWith(numberOfAthletes: resultNumberAthletes.data);
      return Result.success(data: teamInfo);
    }
    return Result.error(message: result.message);
  }
}
