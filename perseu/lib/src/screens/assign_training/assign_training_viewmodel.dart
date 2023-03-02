import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/screens/coach_assign_training/athletes_assign_training_viewmodel.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../models/dtos/group_name_dto.dart';

class AssignTrainingViewModel extends AppViewModel {
  ClientTraining clientTraining = locator<ClientTraining>();
  ClientTeam clientTeam = locator<ClientTeam>();

  int get teamId => session.userSession!.team!.id;
  String get authToken => session.authToken!;

  List<AthletesToAssignTrainingModel> athletes = [];
  List<AthletesToAssignTrainingModel> groups = [];

  Future<Result> getAthletes() async {
    final Result<List<AthleteDTO>> rAthletes = await clientTeam.getAthletes(
      session.userSession!.team!.id,
      session.authToken!,
    );

    final Result<List<GroupNameDTO>> rGroups = await clientTeam.getGroups(
      session.authToken!,
      session.userSession!.team!.id,
    );

    if (rAthletes.error) return Result.error(message: rAthletes.message);

    if (rGroups.error) return Result.error(message: rGroups.message);

    athletes = rAthletes.data!
        .map((i) => AthletesToAssignTrainingModel(
      name: i.name,
      id: i.id,
    ))
        .toList();

    groups = rGroups.data!
        .map((i) => AthletesToAssignTrainingModel(
      id: i.id,
      name: i.name,
      isGroupOfAthletes: true,
    ))
        .toList();

    athletes += groups;

    return const Result.success();
  }

  Future<Result> assign(TrainingDTO training,
      List<AthletesToAssignTrainingModel> athletesAndGroups) async {
    List<int> athletesIds = athletesAndGroups
        .where((athlete) => athlete.assigned && !athlete.isGroupOfAthletes)
        .map((athlete) => athlete.id)
        .toList();

    List<int> groupsIds = athletesAndGroups
        .where((group) => group.assigned && group.isGroupOfAthletes)
        .map((group) => group.id)
        .toList();

    if (athletesIds.isEmpty && groupsIds.isEmpty) {
      return const Result.error(
        message: 'Deve ter ao menos um atleta ou grupo selecionado',
      );
    }

    //Aq antes puxar os ids dos atletas dos grupos e fazer athletesIds += AthletesOfGroups;
    for (int groupId in groupsIds) {
      final result = await clientTeam.getGroupDetails(authToken, groupId);
      if (result.error) {
        return const Result.error(message: 'Falha ao buscar atletas do grupo');
      }
      List<int> athletesIdsOfGroup =
      result.data!.athletes.map((a) => a.id).toList();
      athletesIds += athletesIdsOfGroup;
    }

    final Result result = await clientTraining.assignTraining(
      athletesIds,
      training.id,
      authToken,
    );
    if (result.success) {
      return Result.success(message: result.message);
    }
    return Result.error(message: result.message);
  }
}