import 'dart:convert';

import 'package:perseu/src/models/training_model.dart';

class AssignTrainingRequest {
  final TrainingModel training;
  final List<int> athletesIds;

  AssignTrainingRequest(this.athletesIds, this.training);

  Map<String, dynamic> toMap() {
    return {
      'athletes': athletesIds,
      'sessions': training.sessions.map((s) => s.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
