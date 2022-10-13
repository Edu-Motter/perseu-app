import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/requests/assign_training.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/clients/client_team.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class AthletesToAssignTrainingModel {
  AthletesToAssignTrainingModel(
      {required this.athleteName,
      required this.athleteId,
      this.assigned = false});

  String athleteName;
  int athleteId;
  bool assigned;
}

class AssignTrainingViewModel extends AppViewModel {
  ClientTraining clientTraining = locator<ClientTraining>();
  ClientTeam clientTeam = locator<ClientTeam>();

  int get coachId => session.userSession!.user.id;

  Future<void> assign(TrainingModel training, List<AthletesToAssignTrainingModel> athletes) async {
    List<int> athletesIds = athletes
        .where((athlete) => athlete.assigned)
        .map((athlete) => athlete.athleteId)
        .toList();
    final trainingRequest =
        AssignTrainingRequest(athletesIds, training, coachId);

    await clientTraining.assignTraining(trainingRequest);
  }

  Future<Result<List<AthleteDTO>>> getAthletes() async {
    final result = await clientTeam.getAthletes(1, session.authToken!);
    if (result.success) {
      return Result.success(data: result.data);
    }
    return Result.error(message: result.message);
  }
}
