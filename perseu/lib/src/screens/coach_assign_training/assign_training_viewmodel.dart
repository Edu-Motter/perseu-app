import 'package:perseu/src/models/training_model.dart';

class AthletesToAssignTrainingModel {
  AthletesToAssignTrainingModel({required this.athleteName, required this.athleteId, this.assigned = false});

  String athleteName;
  double athleteId;
  bool assigned;
}

class AssignTrainingModel {
  AssignTrainingModel({required this.training, required this.athletes});

  TrainingModel training;
  List<AthletesToAssignTrainingModel> athletes;
}