import 'dart:convert';

import 'package:perseu/src/models/exercise_model.dart';

class SessionModel {
  final double id;
  String name;
  final List<ExerciseModel> exercises;

  SessionModel({required this.id, required this.name, required this.exercises});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'],
      name: map['name'],
      exercises: map['exercises'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SessionModel{id: $id, name: $name, exercises: $exercises}';
  }
}
