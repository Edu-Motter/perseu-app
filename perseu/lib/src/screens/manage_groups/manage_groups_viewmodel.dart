import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/group_name_dto.dart';
import 'package:perseu/src/models/dtos/training_by_team_dto.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class ManageGroupsViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();
  ClientTeam clientTeam = locator<ClientTeam>();

  String get authToken => session.authToken!;
  int get teamId => session.userSession!.team!.id;

  List<AthleteToGroup> athletes = [];

  List<GroupToGroup> groups = [];

  Future<Result<List<TrainingByTeamDTO>>> getTrainings() {
    return clientCoach.getTrainings(authToken, teamId);
  }

  Future<Result<List<GroupNameDTO>>> getGroups() {
    return clientTeam.getGroups(authToken, teamId);
  }

  Future<Result> getAthletes() async {
    final Result<List<AthleteDTO>> result = await clientTeam.getAthletes(
        session.userSession!.team!.id, session.authToken!);

    if (result.error) return Result.error(message: result.message);

    athletes = result.data!
        .map(
          (i) => AthleteToGroup(name: i.name, id: i.id, checked: false),
        )
        .toList();
    return const Result.success();
  }

  Future<Result> createGroup(String groupName) {
    final athletesIds =
        athletes.where((a) => a.checked == true).map((a) => a.id).toList();
    return clientTeam.createGroup(groupName, athletesIds, teamId, authToken);
  }
}

class AthleteToGroup {
  final int id;
  final String name;

  bool checked;

  AthleteToGroup({required this.id, required this.name, required this.checked});
}

class GroupToGroup {
  final int id;
  final String name;

  bool checked;

  GroupToGroup({required this.id, required this.name, required this.checked});
}
