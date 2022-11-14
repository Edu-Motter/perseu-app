import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/services/clients/client_coach.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

class AthleteTrainingsDetailsViewModel extends AppViewModel {
  ClientCoach clientCoach = locator<ClientCoach>();

  String get authToken => session.authToken!;
  int get teamId => session.userSession!.team!.id;
  TrainingDTO? training;

  Future<Result<TrainingDTO>> getTraining(int trainingId) async {
    Result<TrainingDTO> result =
        await clientCoach.getTraining(authToken, trainingId);
    if (result.success) training = result.data;
    return result;
  }
}
