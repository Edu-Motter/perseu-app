import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/assign_training.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/services/clients/client_training.dart';
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

class AssignTrainingViewModel extends AppViewModel {
  ClientTraining clientTraining = locator<ClientTraining>();

  AssignTrainingViewModel({required this.training, required this.athletes});

  TrainingModel training;
  List<AthletesToAssignTrainingModel> athletes;

  Future<void> assign() async {
    List<double> athletesIds = athletes
        .where((athlete) => athlete.assigned)
        .map((athlete) => athlete.athleteId)
        .toList();
    final trainingRequest =
        AssignTrainingRequest(athletesIds, training, session.user!.id);

    await clientTraining.assignTraining(trainingRequest);
  }
}
