import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/models/requests/assign_training.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientTraining with ApiHelper {
  final dio = locator.get<Dio>();

  Future<Result> assignTraining(AssignTrainingRequest assignTraining) async {
    return process(dio.post('/api/criar-treino', data: assignTraining.toJson()),
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
