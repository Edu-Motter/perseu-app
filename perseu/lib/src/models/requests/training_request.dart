import 'package:perseu/src/screens/coach_assign_training/assign_training_viewmodel.dart';
import 'dart:convert';

class TrainingRequest {
  final AssignTrainingModel assign;

  TrainingRequest({required this.assign});

  Map<String, dynamic> toMap() {
    return {'name': assign.training.name};
  }

  String toJson() => json.encode(toMap());
}
