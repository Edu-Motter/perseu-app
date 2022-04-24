import 'package:perseu/src/models/exercise_model.dart';

class SessionCard {
  String headerValue;
  bool isExpanded;
  List<ExerciseModel> exercises;

  SessionCard({
    required this.headerValue,
    required this.exercises,
    this.isExpanded = false,
  });
}
