import 'package:flutter/material.dart';

abstract class ExerciseItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

class Exercise implements ExerciseItem {
  final String exercise;
  final String description;

  Exercise(this.exercise, this.description);

  @override
  Widget buildTitle(BuildContext context) => Text(exercise);

  @override
  Widget buildSubtitle(BuildContext context) => Text(description);
}
