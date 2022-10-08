import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/invite_dto.dart';
import 'package:perseu/src/models/dtos/team_dto.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class CoachManageRequestsViewModel extends AppViewModel {
  TeamDTO get team => session.userSession!.team!;
  String get authToken => session.authToken!;

  ClientCoach clientCoach = locator<ClientCoach>();

  Future<Result<List<InviteDTO>>> getRequests(int teamId) async {
    return await clientCoach.getRequests(teamId, authToken);
  }

  Future<Result> acceptRequest(int athleteId) {
    return tryExec(
      () async => await clientCoach.acceptRequest(athleteId, authToken),
    );
  }

  Future<Result> declineRequest(int athleteId) {
    return tryExec(
      () async => await clientCoach.declineRequest(athleteId, authToken),
    );
  }

  Future<Result<TeamInfoDTO>> getTeamInfo() async {
    final result = await clientCoach.getTeamInfo(team.id, session.authToken!);
    if (result.success) {
      return Result.success(data: result.data);
    }
    return Result.error(message: result.message);
  }
}
