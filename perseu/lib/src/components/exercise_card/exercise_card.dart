import 'package:flutter/material.dart';

import '../../models/exercise_model.dart';

class ExerciseCard extends StatelessWidget {
  final ExerciseModel exerciseModel;

  const ExerciseCard({Key? key, required this.exerciseModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              exerciseModel.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(exerciseModel.description),
          ],
        ),
      ),
    );
  }
}
