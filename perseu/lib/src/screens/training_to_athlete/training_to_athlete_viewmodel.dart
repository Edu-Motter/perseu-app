import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/training_by_team_dto.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class TrainingToAthleteViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();
  ClientTraining clientTraining = locator<ClientTraining>();

  String get authToken => session.authToken!;
  int get teamId => session.userSession!.team!.id;

  Future<Result<List<TrainingByTeamDTO>>> getTrainings() {
    return clientCoach.getTrainings(authToken, teamId);
  }

  Future<Result> assignTraining(int athleteId, int trainingId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return await clientTraining.assignTraining([athleteId], trainingId, authToken);
  }
}
