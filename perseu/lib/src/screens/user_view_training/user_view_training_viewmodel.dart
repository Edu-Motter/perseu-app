import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

class TrainingViewModel extends AppViewModel {
  String get authToken => session.authToken!;
  int get athleteId => session.userSession!.athlete!.id;

  ClientTraining clientTraining = locator<ClientTraining>();

  Future<Result<TrainingDTO>> getTraining() {
    return clientTraining.getTraining(athleteId, authToken);
  }
}
