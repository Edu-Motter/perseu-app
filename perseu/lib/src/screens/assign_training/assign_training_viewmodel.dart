import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/screens/coach_assign_training/athletes_assign_training_viewmodel.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class AssignTrainingViewModel extends AppViewModel {
  ClientTraining clientTraining = locator<ClientTraining>();
  ClientTeam clientTeam = locator<ClientTeam>();

  int get teamId => session.userSession!.team!.id;
  String get authToken => session.authToken!;

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

  Future<Result> assign(TrainingDTO training,
      List<AthletesToAssignTrainingModel> athletes) async {
    List<int> athletesIds = athletes
        .where((athlete) => athlete.assigned)
        .map((athlete) => athlete.athleteId)
        .toList();

    if (athletesIds.isEmpty) {
      return const Result.error(
          message: 'Deve ter ao menos um atleta selecionado');
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