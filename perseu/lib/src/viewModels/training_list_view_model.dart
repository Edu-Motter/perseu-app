import 'package:perseu/src/models/exercise_model.dart';

class TrainingCard {
  String headerValue;
  bool isExpanded;
  List<ExerciseModel> exercises;

  TrainingCard({
    required this.headerValue,
    required this.exercises,
    this.isExpanded = false,
  });
}
