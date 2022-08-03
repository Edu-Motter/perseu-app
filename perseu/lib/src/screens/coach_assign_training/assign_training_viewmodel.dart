import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/training_request.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/states/foundation.dart';

class AthletesToAssignTrainingModel {
  AthletesToAssignTrainingModel(
      {required this.athleteName,
      required this.athleteId,
      this.assigned = false});

  String athleteName;
  double athleteId;
  bool assigned;
}

class AssignTrainingModel extends AppViewModel {
  HttpClientPerseu httpClientPerseu = locator<HttpClientPerseu>();
  AssignTrainingModel({required this.training, required this.athletes});

  TrainingModel training;
  List<AthletesToAssignTrainingModel> athletes;

  Future<void> assign() async {
    final assign = AssignTrainingModel(training: training, athletes: athletes);
    final trainingRequest = TrainingRequest(assign: assign);

    await httpClientPerseu.assignTraining(trainingRequest);
  }
}
