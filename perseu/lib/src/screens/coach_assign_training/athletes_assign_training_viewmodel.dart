import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/requests/assign_training.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../models/dtos/group_name_dto.dart';

class AthletesToAssignTrainingModel {
  AthletesToAssignTrainingModel({
    required this.name,
    required this.id,
    this.assigned = false,
    this.isGroupOfAthletes = false,
  });

  int id;
  String name;
  bool assigned;
  bool isGroupOfAthletes;
}

class AthletesAssignTrainingViewModel extends AppViewModel {
  ClientTraining clientTraining = locator<ClientTraining>();
  ClientTeam clientTeam = locator<ClientTeam>();

  int get teamId => session.userSession!.team!.id;
  String get authToken => session.authToken!;

  Future<Result> assign(TrainingModel training,
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

    final trainingRequest = AssignTrainingRequest.model(training, athletesIds);

    final Result result = await clientTraining.assignAndCreateTraining(
      trainingRequest,
      teamId,
      authToken,
    );
    if (result.success) {
      return const Result.success(message: 'Treino atribuído com sucesso!');
    }
    return Result.error(message: result.message);
  }

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
}
