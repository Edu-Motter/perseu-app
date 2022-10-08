import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/services/clients/client_training.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

class TrainingViewModel extends AppViewModel {
  String get authToken => session.authToken!;
  TrainingDTO? trainingInfo;

  ClientTraining clientTraining = locator<ClientTraining>();

  Future<Result<TrainingDTO>> getTraining(int athleteId) {
    return clientTraining.getTraining(athleteId, authToken);
  }
}
