import 'dart:convert';

import 'package:perseu/src/models/dtos/session_dto.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';

class AssignTrainingRequest {
  final String name;
  final List<int> athletes;
  final List<dynamic> sessions;

  AssignTrainingRequest._({
    required this.name,
    required this.athletes,
    required this.sessions,
  });

  factory AssignTrainingRequest.dto(
    TrainingDTO trainingDTO,
    List<int> athletesIds,
  ) {
    return AssignTrainingRequest._(
      name: trainingDTO.name,
      athletes: athletesIds,
      sessions: trainingDTO.sessions!.map((s) => s.toJson()).toList(),
    );
  }

  factory AssignTrainingRequest.model(
    TrainingModel trainingModel,
    List<int> athletesIds,
  ) {
    return AssignTrainingRequest._(
      name: trainingModel.name,
      athletes: athletesIds,
      sessions: trainingModel.sessions.map((s) => s.toMap()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'athletes': athletes,
      'sessions': sessions,
    };
  }

  String toJson() => json.encode(toMap());
}
