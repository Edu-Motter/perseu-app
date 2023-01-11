import 'dart:math';

import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/states/foundation.dart';

class NewTrainingViewModel extends AppViewModel {
  final TrainingModel training = TrainingModel(
    id: 0,
    name: '',
    sessions: <SessionModel>[],
  );

  late SessionModel baseSession;

  bool get hasNoSession => training.sessions.isEmpty;
  bool get hasNoExercise => baseSession.exercises.isEmpty;

  void startNewSession() => baseSession =  SessionModel(
    id: 0,
    name: '',
    exercises: <ExerciseModel>[],
  );

  void saveSession(SessionModel session, int? index){
    if (index != null) {
      training.sessions.removeWhere((e) => e.id == session.id);
      training.sessions.insert(index, session);
    } else {
      training.sessions.add(session);
    }
    notifyListeners();
  }

  SessionModel createSession({
    required String name,
    int? id,
  }) {
    id ??= Random().nextInt(99999);
    return SessionModel(id: id, name: name, exercises: baseSession.exercises);
  }

  void saveExercise(ExerciseModel exercise, int? index) {
    if (index != null) {
      baseSession.exercises.removeWhere((e) => e.id == exercise.id);
      baseSession.exercises.insert(index, exercise);
    } else {
      baseSession.exercises.add(exercise);
    }
    notifyListeners();
  }

  ExerciseModel createExercise({
    required String name,
    required String description,
    int? id,
  }) {
    id ??= Random().nextInt(99999);
    return ExerciseModel(id: id, name: name, description: description);
  }

  Future<void> removeExercise(index) async {
    baseSession.exercises.removeAt(index);
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  Future<void> removeSession(index) async {
    training.sessions.removeAt(index);
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }
}
