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
