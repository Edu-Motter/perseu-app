import 'dart:convert';

import 'package:perseu/src/models/training_model.dart';

class AssignTrainingRequest {
  final TrainingModel training;
  final List<double> athletesIds;
  AssignTrainingRequest(this.athletesIds, this.training);

  Map<String, dynamic> toMap() {
    return {'athletes': athletesIds, 'training': training.toMap()};
  }

  String toJson() => json.encode(toMap());
}
