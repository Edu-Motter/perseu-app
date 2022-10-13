import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/requests/assign_training.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class AthletesToAssignTrainingModel {
  AthletesToAssignTrainingModel({
    required this.athleteName,
    required this.athleteId,
    this.assigned = false,
  });

  String athleteName;
  int athleteId;
  bool assigned;
}

class AssignTrainingViewModel extends AppViewModel {
  ClientTraining clientTraining = locator<ClientTraining>();
  ClientTeam clientTeam = locator<ClientTeam>();

  int get coachId => session.userSession!.user.id;

  Future<Result> assign(TrainingModel training,
      List<AthletesToAssignTrainingModel> athletes) async {
    //TODO: Validar se ele está com pelo menos um atleta selecionado, retornar
    //Result.error(Deve ter ao menos um atleta selecionado)

    List<int> athletesIds = athletes
        .where((athlete) => athlete.assigned)
        .map((athlete) => athlete.athleteId)
        .toList();
    final trainingRequest =
        AssignTrainingRequest(athletesIds, training, coachId);

    await clientTraining.assignTraining(trainingRequest);
    return const Result.success(message: 'Treino atribuído com sucesso!');
  }

  List<AthletesToAssignTrainingModel> athletes = [];

  Future<Result> getAthletes() async {
    final Result<List<AthleteDTO>> result = await clientTeam.getAthletes(
        session.userSession!.team!.id, session.authToken!);
    if (result.success) {
      athletes = result.data!
          .map(
            (i) => AthletesToAssignTrainingModel(
                athleteName: i.name, athleteId: i.id, assigned: false),
          )
          .toList();
      return const Result.success();
    }
    return Result.error(message: result.message);
  }
}
