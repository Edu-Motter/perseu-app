import 'dart:convert';

import 'package:perseu/src/models/training_model.dart';

class AssignTrainingRequest {
  final TrainingModel training;
  final List<int> athletesIds;
  final int coachId;

  AssignTrainingRequest(this.athletesIds, this.training, this.coachId);

  Map<String, dynamic> toMap() {
    return {
      'athletes': athletesIds,
      'training': training.toMap(),
      'coachId': coachId
    };
  }

  String toJson() => json.encode(toMap());
}
