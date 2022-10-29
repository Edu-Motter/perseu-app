import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/training_by_team_dto.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class TrainingsByTeamViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();

  String get authToken => session.authToken!;
  int get teamId => session.userSession!.team!.id;

  Future<Result<List<TrainingByTeamDTO>>> getTrainings() {
    return clientCoach.getTrainings(authToken, teamId);
  }
}
