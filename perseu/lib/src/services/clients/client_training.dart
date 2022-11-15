import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/models/requests/assign_training.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientTraining with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result> assignAndCreateTraining(
    AssignTrainingRequest assignTraining,
    int teamId,
    String jwt,
  ) async {
    return process(
        dio.post('/team/$teamId/training',
            data: assignTraining.toJson(),
            options: Options(headers: {'Authorization': 'Bearer $jwt'})),
        onSuccess: (response) {
          return const Result.success(message: 'Treino atribuído com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao atribuir treino'));
  }

  Future<Result> assignTraining(
    List<int> athletesIds,
    int trainingId,
    String jwt,
  ) async {
    return process(
        dio.post('/training/$trainingId',
            data: jsonEncode({'athletes': athletesIds}),
            options: Options(headers: {'Authorization': 'Bearer $jwt'})),
        onSuccess: (response) {
          return const Result.success(message: 'Treino atribuído com sucesso');
        },
        onError: (response) =>
            const Result.error(message: 'Falha ao atribuir treino'));
  }

  Future<Result> checkIn(
    int athleteId,
    int trainingId,
    int effort,
    String authToken,
  ) async {
    DateTime now = DateTime.now();
    return process(
        dio.post('/training/$trainingId/athlete/$athleteId/check-in',
            data: jsonEncode({'date': now.toIso8601String(), 'effort': effort}),
            options: Options(headers: {'Authorization': 'Bearer $authToken'})),
        onSuccess: (response) {
          return const Result.success(message: 'Sucesso no check-in');
        },
        onError: (response) =>
            const Result.error(message: 'Falha no check-in'));
  }

  Future<Result<TrainingDTO>> getTraining(int athleteId, String jwt) async {
    return process(
        dio.get('/athlete/$athleteId/training',
            options: Options(headers: {'Authorization': 'Bearer $jwt'})),
        onSuccess: (response) {
      TrainingDTO trainingInfo = TrainingDTO.fromJson(response.data);
      return Result.success(data: trainingInfo);
    }, onError: (response) {
      return const Result.error(message: 'Falha ao atribuir treino');
    });
  }
}
